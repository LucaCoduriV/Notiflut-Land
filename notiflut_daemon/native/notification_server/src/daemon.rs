use ::dbus::{message::SignalArgs, Path};
use std::{
    sync::{mpsc::Receiver, Arc, Mutex},
    thread::JoinHandle,
    time::Duration,
};

use crate::{
    db,
    dbus::{self, DaemonEvent, DbusEvent, DbusServer},
    dbus_definition,
    notification::Notification,
};
#[derive(thiserror::Error, Debug)]
pub enum DaemonError {
    #[error("An error occured")]
    Error,
    #[error("The daemon is already down")]
    AlreadyDown,
    #[error("The daemon is aldready up")]
    AlreadyUp,
}

pub enum ChannelMessage {
    DaemonAction(AppEvent),
    DbusEvent(DbusEvent),
    Stop,
}

/// Actions or events coming from the user interface
#[derive(Debug)]
pub enum AppEvent {
    Close(u32),
    CloseAll,
    CloseAllApp(String),
    ActionInvoked(u32, String),
    CloseNotification,
}

pub struct NotificationDaemon {
    pub sender: Option<std::sync::mpsc::Sender<ChannelMessage>>,

    stop: Arc<Mutex<bool>>,
    notification_join_handle: Option<JoinHandle<Result<(), DaemonError>>>,
    signal_recv: Arc<Mutex<Option<Receiver<::dbus::message::Message>>>>,
    dbus_server: Option<Arc<Mutex<DbusServer>>>,
}

impl NotificationDaemon {
    pub fn new() -> Self {
        NotificationDaemon {
            stop: Arc::new(Mutex::new(false)),
            notification_join_handle: None,
            sender: None,
            dbus_server: None,
            signal_recv: Arc::new(Mutex::new(None)),
            // cron_join_handle: None,
        }
    }

    pub fn run_daemon(
        &mut self,
        flutter_stream_sink: std::sync::mpsc::Sender<DaemonEvent>,
    ) -> Result<(), DaemonError> {
        if *self.stop.lock().unwrap() {
            return Err(DaemonError::AlreadyUp).into();
        }
        let mut dbus_server = dbus::DbusServer::init().map_err(|_| DaemonError::Error)?;
        let (sender, dbus_events_recv) = std::sync::mpsc::channel::<ChannelMessage>();
        self.sender = Some(sender.clone());
        dbus_server
            .register_notification_handler(sender)
            .map_err(|_| DaemonError::Error)?;
        self.dbus_server = Some(Arc::new(Mutex::new(dbus_server)));
        self.handle_actions_and_events(flutter_stream_sink, dbus_events_recv);

        let dbus_server_mutex = Arc::clone(self.dbus_server.as_ref().unwrap());
        let stop = Arc::clone(&self.stop);
        let arc_signal_recv = Arc::clone(&self.signal_recv);
        // Start listening for notification and sends signals if there is some
        // waiting to be sended.
        let thread_handle = std::thread::spawn(move || {
            let mut recv: Option<Receiver<::dbus::message::Message>> = None;
            while !*stop.lock().unwrap() {
                // TODO this code is bit messy and really need a refactor
                // recv could still not be initialized by the handle_action thread
                if recv.is_some() {
                    if let Ok(message) = recv.as_mut().unwrap().try_recv() {
                        println!("sending signal: {:?}", message);
                        let dbus_server_guard = dbus_server_mutex.lock().unwrap();
                        let result = dbus_server_guard.connection.channel().send(message);
                        println!("Signal result: {:?}", result);
                    }
                } else {
                    let mut lock = arc_signal_recv.lock().unwrap();
                    if lock.is_some() {
                        recv = lock.take();
                    }
                }
                match dbus_server_mutex
                    .lock()
                    .unwrap()
                    .wait_and_process(Duration::from_millis(200))
                    .map_err(|_| DaemonError::Error)
                {
                    Ok(it) => it,
                    Err(err) => return Err(err),
                };
            }

            Ok(())
        });
        self.notification_join_handle = Some(thread_handle);
        Ok(())
    }

    /// Handles all messages received from flutter and dbus
    /// * `flutter_sender` - the channel to send data to flutter
    /// * `flutter_and_dbus_recv` - the channel used to get events from flutter and dbus
    fn handle_actions_and_events(
        &mut self,
        flutter_sender: std::sync::mpsc::Sender<DaemonEvent>,
        flutter_and_dbus_recv: Receiver<ChannelMessage>,
    ) -> JoinHandle<Result<(), DaemonError>> {
        // We set the channel that will be used to send signals by an other
        // thread.
        let (signal_sender, signal_recv) = std::sync::mpsc::channel::<::dbus::message::Message>();
        {
            let mut sr = self.signal_recv.lock().unwrap();
            *sr = Some(signal_recv);
        }

        let action_join_handler = std::thread::spawn(move || {
            let mut data = crate::daemon_data::DaemonData::new();

            loop {
                let result = match flutter_and_dbus_recv.recv().unwrap() {
                    ChannelMessage::DaemonAction(action) => match action {
                        AppEvent::Close(id) => Self::on_notification_closed(
                            &mut data.notifications,
                            &signal_sender,
                            &flutter_sender,
                            id,
                        ),
                        AppEvent::CloseAll => Self::on_all_notifications_closed(
                            &mut data.notifications,
                            &signal_sender,
                            &flutter_sender,
                        ),
                        AppEvent::ActionInvoked(id, action_key) => Self::on_action_invoked(
                            &mut data.notifications,
                            &signal_sender,
                            &flutter_sender,
                            id,
                            action_key,
                        ),
                        AppEvent::CloseNotification => {
                            data.is_open = false;
                            Ok(())
                        }
                        AppEvent::CloseAllApp(app_name) => Self::on_all_app_notifications_closed(
                            &mut data.notifications,
                            &signal_sender,
                            &flutter_sender,
                            app_name,
                        ),
                    },
                    ChannelMessage::DbusEvent(event) => match event {
                        DbusEvent::NewNotification(notification) => Self::show_notification(
                            &mut data.notifications,
                            &flutter_sender,
                            notification,
                        ),

                        DbusEvent::CloseNotification(id) => {
                            Self::close_notification(&mut data.notifications, &flutter_sender, id)
                        }

                        DbusEvent::ShowNotificationCenter => {
                            flutter_sender
                                .send(DaemonEvent::ShowNotificationCenter)
                                .unwrap();
                            data.is_open = true;
                            Ok(())
                        }

                        DbusEvent::HideNotificationCenter => {
                            flutter_sender
                                .send(DaemonEvent::HideNotificationCenter)
                                .unwrap();
                            data.is_open = false;
                            Ok(())
                        }

                        DbusEvent::ToggleNotificationCenter => {
                            match data.is_open {
                                true => {
                                    flutter_sender
                                        .send(DaemonEvent::HideNotificationCenter)
                                        .unwrap();
                                    data.is_open = false;
                                }
                                false => {
                                    flutter_sender
                                        .send(DaemonEvent::ShowNotificationCenter)
                                        .unwrap();
                                    data.is_open = true;
                                }
                            }
                            Ok(())
                        }
                    },
                    ChannelMessage::Stop => {
                        return Ok(());
                    }
                };

                if result.is_err() {
                    return result;
                }
            }
        });
        action_join_handler
    }

    /// It tells to flutter to show a new notification
    pub fn show_notification(
        notifications_mutex: &mut Vec<Notification>,
        flutter_sender: &std::sync::mpsc::Sender<DaemonEvent>,
        notification: Notification,
    ) -> Result<(), DaemonError> {
        notifications_mutex.retain(|v| v.id != notification.id);
        notifications_mutex.push(notification.clone());
        let last_index = notifications_mutex.len() as i64 - 1;
        let last_index = if last_index < 0 {
            None
        } else {
            Some(last_index as usize)
        };
        if let Err(_error) =
            flutter_sender.send(DaemonEvent::Update(notifications_mutex.clone(), last_index))
        {
            Err(DaemonError::Error)
        } else {
            Ok(())
        }
    }

    pub fn on_action_invoked(
        notifications_mutex: &mut Vec<Notification>,
        signal_sender: &std::sync::mpsc::Sender<::dbus::message::Message>,
        flutter_sender: &std::sync::mpsc::Sender<DaemonEvent>,
        id: u32,
        action_key: String,
    ) -> Result<(), DaemonError> {
        notifications_mutex.retain(|v| v.id != id);
        let message = dbus_definition::OrgFreedesktopNotificationsActionInvoked { id, action_key };
        let path = Path::new(dbus::NOTIFICATION_PATH).unwrap();
        let _result = signal_sender.send(message.to_emit_message(&path));

        if let Err(_error) =
            flutter_sender.send(DaemonEvent::Update(notifications_mutex.clone(), None))
        {
            Err(DaemonError::Error)
        } else {
            Ok(())
        }
    }

    /// It tells to dbus that a user closed a notification from flutter.
    /// This allows app to now if a notification was read.
    pub fn on_notification_closed(
        notifications_mutex: &mut Vec<Notification>,
        signal_sender: &std::sync::mpsc::Sender<::dbus::message::Message>,
        flutter_sender: &std::sync::mpsc::Sender<DaemonEvent>,
        id: u32,
    ) -> Result<(), DaemonError> {
        notifications_mutex.retain(|v| v.id != id);
        let message = dbus_definition::OrgFreedesktopNotificationsNotificationClosed {
            id,
            reason: 2, // 2 means dismissed by user
        };
        let path = Path::new(dbus::NOTIFICATION_PATH).unwrap();
        let _result = signal_sender.send(message.to_emit_message(&path));

        if let Err(_error) =
            flutter_sender.send(DaemonEvent::Update(notifications_mutex.clone(), None))
        {
            Err(DaemonError::Error)
        } else {
            Ok(())
        }
    }

    /// It closes a notification.
    /// Usually this will be called by apps to close their notification when not needed anymore.
    pub fn close_notification(
        notifications_mutex: &mut Vec<Notification>,
        flutter_sender: &std::sync::mpsc::Sender<DaemonEvent>,
        id: u32,
    ) -> Result<(), DaemonError> {
        notifications_mutex.retain(|v| v.id != id);
        if let Err(_error) =
            flutter_sender.send(DaemonEvent::Update(notifications_mutex.clone(), None))
        {
            Err(DaemonError::Error)
        } else {
            Ok(())
        }
    }

    /// Allows flutter to close all notifications..
    /// It removes everthing from the list.
    ///
    /// # Errors
    ///
    /// This function will return an error if channel are closed.
    pub fn on_all_notifications_closed(
        notifications_mutex: &mut Vec<Notification>,
        signal_sender: &std::sync::mpsc::Sender<::dbus::message::Message>,
        flutter_sender: &std::sync::mpsc::Sender<DaemonEvent>,
    ) -> Result<(), DaemonError> {
        for notification in notifications_mutex.iter() {
            let message = dbus_definition::OrgFreedesktopNotificationsNotificationClosed {
                id: notification.id,
                reason: 2, // 2 means dismissed by user
            };
            let path = Path::new(dbus::NOTIFICATION_PATH).unwrap();
            let _result = signal_sender.send(message.to_emit_message(&path));
        }

        notifications_mutex.clear();
        if let Err(_error) =
            flutter_sender.send(DaemonEvent::Update(notifications_mutex.clone(), None))
        {
            Err(DaemonError::Error)
        } else {
            Ok(())
        }
    }

    /// It allow Flutter to close all notification related to a specific app.
    pub fn on_all_app_notifications_closed(
        notifications_mutex: &mut Vec<Notification>,
        signal_sender: &std::sync::mpsc::Sender<::dbus::message::Message>,
        flutter_sender: &std::sync::mpsc::Sender<DaemonEvent>,
        app_name: String,
    ) -> Result<(), DaemonError> {
        for notification in notifications_mutex
            .iter()
            .filter(|n| n.app_name == app_name)
        {
            let message = dbus_definition::OrgFreedesktopNotificationsNotificationClosed {
                id: notification.id,
                reason: 2, // 2 means dismissed by user
            };
            let path = Path::new(dbus::NOTIFICATION_PATH).unwrap();
            let _result = signal_sender.send(message.to_emit_message(&path));
        }

        notifications_mutex.retain(|n| n.app_name != app_name);
        if let Err(_error) =
            flutter_sender.send(DaemonEvent::Update(notifications_mutex.clone(), None))
        {
            return Err(DaemonError::Error);
        }
        Ok(())
    }

    /// It Stop the daemon. If stopped, notification arn't processed anymore.
    pub fn stop_daemon(&mut self) -> Result<(), DaemonError> {
        *self.stop.lock().unwrap() = true;
        let handle = self.notification_join_handle.take();
        let result = match handle {
            Some(h) => h.join(),
            None => {
                return Err(DaemonError::AlreadyDown);
            }
        };
        print!("Stop result: {result:?}");
        // TODO join every thread
        return Ok(());
    }
}

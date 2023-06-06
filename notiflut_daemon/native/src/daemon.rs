use ::dbus::{message::SignalArgs, Path};
use flutter_rust_bridge::StreamSink;
use std::{
    sync::{mpsc::Receiver, Arc, Mutex, RwLock},
    thread::JoinHandle,
    time::Duration,
};

use crate::{
    dbus::{self, DaemonAction, DbusServer},
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

pub enum ChannelMessage<T> {
    Message(T),
    Stop,
}

pub struct NotificationDaemon {
    pub sender: Option<std::sync::mpsc::Sender<ChannelMessage<DaemonAction>>>,

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
        flutter_stream_sink: StreamSink<DaemonAction>,
    ) -> Result<(), DaemonError> {
        if *self.stop.lock().unwrap() {
            return Err(DaemonError::AlreadyUp).into();
        }
        let mut dbus_server = dbus::DbusServer::init().map_err(|_| DaemonError::Error)?;
        let (sender, dbus_events_recv) = std::sync::mpsc::channel::<ChannelMessage<DaemonAction>>();
        self.sender = Some(sender.clone());
        dbus_server
            .register_notification_handler(sender)
            .map_err(|_| DaemonError::Error)?;
        self.dbus_server = Some(Arc::new(Mutex::new(dbus_server)));
        self.handle_actions(flutter_stream_sink, dbus_events_recv);

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
    fn handle_actions(
        &mut self,
        flutter_sender: StreamSink<DaemonAction>,
        flutter_and_dbus_recv: Receiver<ChannelMessage<DaemonAction>>,
    ) -> JoinHandle<Result<(), DaemonError>> {
        // We set the channel that will be used to send signals by an other
        // thread.
        let (signal_sender, signal_recv) = std::sync::mpsc::channel::<::dbus::message::Message>();
        {
            let mut sr = self.signal_recv.lock().unwrap();
            *sr = Some(signal_recv);
        }

        // this vector will handle all notifications received by dbus
        // and will remain alive till the app is killed
        let notifications: Arc<RwLock<Vec<Notification>>> = Arc::new(RwLock::new(Vec::new()));

        let action_join_handler = std::thread::spawn(move || {
            // let mut notifications: Vec<Notification> = Vec::new();
            loop {
                let action = match flutter_and_dbus_recv.recv().unwrap() {
                    ChannelMessage::Message(m) => m,
                    ChannelMessage::Stop => {
                        return Ok(());
                    }
                };

                match action {
                    DaemonAction::Show(notification) => {
                        notifications
                            .write()
                            .unwrap()
                            .retain(|v| v.id != notification.id);
                        notifications.write().unwrap().push(notification.clone());
                        let last_index = notifications.read().unwrap().len() as i64 - 1;
                        let last_index = if last_index < 0 {
                            None
                        } else {
                            Some(last_index as usize)
                        };
                        if let false = flutter_sender.add(DaemonAction::Update(
                            notifications.read().unwrap().clone(),
                            last_index,
                        )) {
                            return Err(DaemonError::Error);
                        }
                    }
                    DaemonAction::Close(id) => {
                        notifications.write().unwrap().retain(|v| v.id != id);
                        if let false = flutter_sender.add(DaemonAction::Update(
                            notifications.read().unwrap().clone(),
                            None,
                        )) {
                            return Err(DaemonError::Error);
                        }
                    }
                    DaemonAction::FlutterClose(id) => {
                        notifications.write().unwrap().retain(|v| v.id != id);
                        let message =
                            dbus_definition::OrgFreedesktopNotificationsNotificationClosed {
                                id,
                                reason: 2, // 2 means dismissed by user
                            };
                        let path = Path::new(dbus::NOTIFICATION_PATH).unwrap();
                        let _result = signal_sender.send(message.to_emit_message(&path));

                        if let false = flutter_sender.add(DaemonAction::Update(
                            notifications.read().unwrap().clone(),
                            None,
                        )) {
                            return Err(DaemonError::Error);
                        }
                    }
                    DaemonAction::FlutterCloseAll => {
                        let mut notifications_mutex = notifications.write().unwrap();

                        for notification in notifications_mutex.iter() {
                            let message =
                                dbus_definition::OrgFreedesktopNotificationsNotificationClosed {
                                    id: notification.id,
                                    reason: 2, // 2 means dismissed by user
                                };
                            let path = Path::new(dbus::NOTIFICATION_PATH).unwrap();
                            let _result = signal_sender.send(message.to_emit_message(&path));
                        }

                        notifications_mutex.clear();
                        if let false = flutter_sender
                            .add(DaemonAction::Update(notifications_mutex.clone(), None))
                        {
                            return Err(DaemonError::Error);
                        }
                    }
                    DaemonAction::FlutterActionInvoked(id, action_key) => {
                        notifications.write().unwrap().retain(|v| v.id != id);
                        let message = dbus_definition::OrgFreedesktopNotificationsActionInvoked {
                            id,
                            action_key,
                        };
                        let path = Path::new(dbus::NOTIFICATION_PATH).unwrap();
                        let _result = signal_sender.send(message.to_emit_message(&path));

                        if let false = flutter_sender.add(DaemonAction::Update(
                            notifications.read().unwrap().clone(),
                            None,
                        )) {
                            return Err(DaemonError::Error);
                        }
                    }
                    DaemonAction::ShowNc => {
                        flutter_sender.add(DaemonAction::ShowNc);
                    }
                    DaemonAction::CloseNc => {
                        flutter_sender.add(DaemonAction::CloseNc);
                    }
                    _ => {}
                };
            }
        });
        action_join_handler
    }

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

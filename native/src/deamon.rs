use std::{
    sync::{Arc, Mutex, mpsc::Receiver, RwLock},
    time::Duration, thread::JoinHandle,
};
use ::dbus::{Path, message::SignalArgs};
use flutter_rust_bridge::StreamSink;

use crate::{dbus::{self, DeamonAction, DbusServer}, notification::Notification, dbus_definition};
#[derive(thiserror::Error, Debug)]
pub enum DeamonError{
    #[error("An error occured")]
    Error,
    #[error("The deamon is already down")]
    AlreadyDown,
    #[error("The deamon is aldready up")]
    AlreadyUp 
}

pub enum ChannelMessage<T>{
    Message(T),
    Stop,
}

pub struct NotificationDeamon{
    pub sender: Option<std::sync::mpsc::Sender<ChannelMessage<DeamonAction>>>,

    stop: Arc<Mutex<bool>>,
    notification_join_handle: Option<JoinHandle<Result<(), DeamonError>>>,
    signal_recv: Arc<Mutex<Option<Receiver<::dbus::message::Message>>>>,
    cron_join_handle: Option<JoinHandle<Result<(), DeamonError>>>,
    dbus_server: Option<Arc<Mutex<DbusServer>>>,
}

impl NotificationDeamon {

    pub fn new() -> Self {
        NotificationDeamon { 
            stop: Arc::new(Mutex::new(false)),
            notification_join_handle: None,
            sender: None,
            dbus_server: None,
            signal_recv: Arc::new(Mutex::new(None)),
            cron_join_handle: None,
        }
    } 

    pub fn run_deamon(&mut self, flutter_stream_sink: StreamSink<DeamonAction>) -> Result<(), DeamonError> {
        if *self.stop.lock().unwrap(){
            return Err(DeamonError::AlreadyUp).into();
        }
        let mut dbus_server = dbus::DbusServer::init().map_err(|_|DeamonError::Error)?;
        let (sender, recv) = std::sync::mpsc::channel::<ChannelMessage<DeamonAction>>();
        self.sender = Some(sender.clone());
        dbus_server.register_notification_handler(sender).map_err(|_|DeamonError::Error)?;
        self.dbus_server = Some(Arc::new(Mutex::new(dbus_server)));
        self.handle_actions(flutter_stream_sink, recv);
        
        let dbus_server = Arc::clone(self.dbus_server.as_ref().unwrap());
        let stop = Arc::clone(&self.stop);
        let arc_signal_recv = Arc::clone(&self.signal_recv);
        // start listening for notification
        let thread_handle = std::thread::spawn(move ||{
            let mut recv: Option<Receiver<::dbus::message::Message>>= None;
            while !*stop.lock().unwrap() {
                // TODO this code is bit messy and really need a refactor
                // recv could still not be initialized by the handle_action thread
                if recv.is_some() {
                  if let Ok(message) = recv.as_mut().unwrap().try_recv() {
                      println!("sending signal: {:?}", message);
                      let dbus_server_guard = dbus_server.lock().unwrap();
                      let result = dbus_server_guard.connection.channel().send(message);
                      println!("Signal result: {:?}", result);
                  } 
                }else {
                    let mut lock = arc_signal_recv.lock().unwrap();
                    if lock.is_some(){
                        recv = lock.take();
                    }
                }
                match dbus_server.lock().unwrap()
                    .wait_and_process(Duration::from_millis(200)).map_err(|_|DeamonError::Error) {
                        Ok(it) => it,
                        Err(err) => return Err(err),
                    };
            }

            Ok(())
        });
        self.notification_join_handle = Some(thread_handle);
        Ok(())
    }

    fn cron_job(stop: Arc<Mutex<bool>>, notifications: Arc<RwLock<Vec<Notification>>>)
        -> JoinHandle<Result<(), DeamonError>> {
        std::thread::spawn(move ||{
            loop {
                std::thread::sleep(Duration::from_secs(1));
                // add time to each notification
                if let Ok(mut notifications) = notifications.write() {
                    for notif in notifications.iter_mut() {
                        notif.time_since_display += 1000;
                    }
                } else {
                    return Err(DeamonError::Error);
                }

                if *stop.lock().unwrap() {
                    return Ok(());
                }
            }
        })
    }

    fn handle_actions(&mut self, sender:StreamSink<DeamonAction>, recv:Receiver<ChannelMessage<DeamonAction>>) 
        -> JoinHandle<Result<(), DeamonError>> {

        let stop_cron_job = Arc::clone(&self.stop);
        let (signal_sender, signal_recv) = std::sync::mpsc::channel::<::dbus::message::Message>();
        {
            let mut sr = self.signal_recv.lock().unwrap();
            *sr = Some(signal_recv);
        }
        // self.signal_join_handle = Some(self.signal_thread(signal_recv));

        let notifications:Arc<RwLock<Vec<Notification>>> = Arc::new(RwLock::new(Vec::new()));
        self.cron_join_handle = Some(NotificationDeamon::cron_job(stop_cron_job, Arc::clone(&notifications)));

        let action_join_handler = std::thread::spawn(move ||{
            // let mut notifications: Vec<Notification> = Vec::new();
            loop {
                let action = match recv.recv().unwrap() {
                    ChannelMessage::Message(m) => m,
                    ChannelMessage::Stop => {
                        return Ok(());
                    },
                };

                match action {
                    DeamonAction::Show(notification) => {
                        notifications.write().unwrap().retain(|v|v.id != notification.id); 
                        notifications.write().unwrap().push(notification.clone());
                        if let false = sender.add(DeamonAction::Update(notifications.read().unwrap().clone())){
                            return Err(DeamonError::Error);
                        }
                    },
                    DeamonAction::Close(id) => {
                       notifications.write().unwrap().retain(|v|v.id != id);
                        if let false = sender.add(DeamonAction::Update(notifications.read().unwrap().clone())){
                           return Err(DeamonError::Error);
                        }
                    },
                    DeamonAction::ClientClose(id) => {
                        notifications.write().unwrap().retain(|v|v.id != id);
                        let message = dbus_definition::OrgFreedesktopNotificationsNotificationClosed{
                            id,
                            reason : 2, // 2 means dismissed by user
                        };
                        let path = Path::new(dbus::NOTIFICATION_PATH).unwrap();
                        let _result = signal_sender.send(message.to_emit_message(&path));

                        if let false = sender.add(DeamonAction::Update(notifications.read().unwrap().clone())){
                           return Err(DeamonError::Error);
                        }
                    },
                    DeamonAction::ClientActionInvoked(id, action_key) => {
                        notifications.write().unwrap().retain(|v|v.id != id);
                        let message = dbus_definition::OrgFreedesktopNotificationsActionInvoked{
                            id,
                            action_key,
                        };
                        let path = Path::new(dbus::NOTIFICATION_PATH).unwrap();
                        let _result = signal_sender.send(message.to_emit_message(&path));

                        if let false = sender.add(DeamonAction::Update(notifications.read().unwrap().clone())){
                           return Err(DeamonError::Error);
                        }
                    },
                    _ => {},
                };
            }
        });
        action_join_handler 
    }

    pub fn stop_deamon(&mut self) -> Result<(), DeamonError> {
        *self.stop.lock().unwrap() = true;
        let handle = self.notification_join_handle.take();
        let result = match handle {
            Some(h) => h.join(),
            None => {return Err(DeamonError::AlreadyDown);},
        };
        print!("Stop result: {result:?}");
        // TODO join every thread
        return Ok(());
    }
}

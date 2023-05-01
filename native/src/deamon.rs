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

pub struct NotificationDeamon{
    stop: Arc<Mutex<bool>>,
    join_handle: Option<JoinHandle<Result<(), DeamonError>>>,
    pub sender: Option<std::sync::mpsc::Sender<DeamonAction>>,
    dbus_server: Option<Arc<Mutex<DbusServer>>>,
}

impl NotificationDeamon {

    pub fn new() -> Self {
        NotificationDeamon { stop: Arc::new(Mutex::new(false)), join_handle: None, sender: None, dbus_server: None,}
    } 

    pub fn run_deamon(&mut self, flutter_stream_sink: StreamSink<DeamonAction>) -> Result<(), DeamonError> {
        if *self.stop.lock().unwrap(){
            return Err(DeamonError::AlreadyUp).into();
        }
        let mut dbus_server = dbus::DbusServer::init().map_err(|_|DeamonError::Error)?;
        let (sender, recv) = std::sync::mpsc::channel::<DeamonAction>();
        self.sender = Some(sender.clone());
        dbus_server.register_notification_handler(sender).map_err(|_|DeamonError::Error)?;
        self.dbus_server = Some(Arc::new(Mutex::new(dbus_server)));
        self.handle_actions(flutter_stream_sink, recv);
        let dbus_server = Arc::clone(self.dbus_server.as_ref().unwrap());
        let stop = Arc::clone(&self.stop);

        // start listening for notification
        let thread_handle = std::thread::spawn(move ||{
            while !*stop.lock().unwrap() {
                match dbus_server.lock().unwrap().wait_and_process(Duration::from_secs(1)).map_err(|_|DeamonError::Error) {
                    Ok(it) => it,
                    Err(err) => return Err(err),
                };
            }

            Ok(())
        });
        self.join_handle = Some(thread_handle);
        Ok(())
    }

    fn cron_job(stop: Arc<Mutex<bool>>, notifications: Arc<RwLock<Vec<Notification>>>)-> JoinHandle<Result<(), DeamonError>> {
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

    fn handle_actions(&mut self, sender:StreamSink<DeamonAction>, recv:Receiver<DeamonAction>) -> JoinHandle<Result<(), DeamonError>> {
        let dbus_server = Arc::clone(self.dbus_server.as_ref().unwrap());
        let stop_cron_job = Arc::clone(&self.stop);
        let stop_action_handling = Arc::clone(&self.stop);
        let stop_action_join_handler = std::thread::spawn(move ||{
            // let mut notifications: Vec<Notification> = Vec::new();
            let notifications:Arc<RwLock<Vec<Notification>>> = Arc::new(RwLock::new(Vec::new()));
            let cron_handle = NotificationDeamon::cron_job(stop_cron_job, Arc::clone(&notifications));
            loop {
                let action = recv.recv().unwrap();
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
                        let result = dbus_server.lock().unwrap()
                            .connection.channel().send(message.to_emit_message(&path));
                        match result {
                            Ok(_) => {},
                            Err(_) => {
                                dbus_server.lock().unwrap().connection.channel().flush();
                            },
                        };
                        if let false = sender.add(DeamonAction::Update(notifications.read().unwrap().clone())){
                           return Err(DeamonError::Error);
                       }
                    },
                    DeamonAction::ClientActionInvoked(id, action_key) => {
                        let message = dbus_definition::OrgFreedesktopNotificationsActionInvoked{
                            id,
                            action_key,
                        };
                        let path = Path::new(dbus::NOTIFICATION_PATH).unwrap();
                        let result = dbus_server.lock().unwrap().connection.channel().send(message.to_emit_message(&path));
                        match result {
                            Ok(_) => {},
                            Err(_) => {
                                dbus_server.lock().unwrap().connection.channel().flush();
                            },
                        };
                    },
                    _ => {},
                };

                if *stop_action_handling.lock().unwrap(){
                    let _cron_job_result = cron_handle.join().unwrap();
                    return Ok(());
                }
            }
        });
        stop_action_join_handler 
    }

    pub fn stop_deamon(&mut self) -> Result<(), DeamonError> {
        *self.stop.lock().unwrap() = true;
        let handle = self.join_handle.take();
        let result = match handle {
            Some(h) => h.join(),
            None => {return Err(DeamonError::AlreadyDown);},
        };
        print!("{result:?}");
        return Ok(());
    }
}

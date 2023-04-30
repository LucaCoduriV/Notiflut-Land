use std::{
    sync::{Arc, Mutex, mpsc::Receiver},
    time::Duration, thread::JoinHandle,
};
use flutter_rust_bridge::StreamSink;

use crate::{dbus::{self, DeamonAction}, notification::Notification};
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
}

impl NotificationDeamon {

    pub fn new() -> Self {
        NotificationDeamon { stop: Arc::new(Mutex::new(false)), join_handle: None, sender: None }
    } 

    pub fn run_deamon(&mut self, flutter_stream_sink: StreamSink<DeamonAction>) -> Result<(), DeamonError> {
        if *self.stop.lock().unwrap(){
            return Err(DeamonError::AlreadyUp).into();
        }
        let mut dbus_server = dbus::DbusServer::init().map_err(|_|DeamonError::Error)?;
        let (sender, recv) = std::sync::mpsc::channel::<DeamonAction>();
        self.sender = Some(sender.clone());
        NotificationDeamon::handle_actions(flutter_stream_sink, recv);
        dbus_server.register_notification_handler(sender).map_err(|_|DeamonError::Error)?;
        let stop = Arc::clone(&self.stop);
        let thread_handle = std::thread::spawn(move ||{
            while !*stop.lock().unwrap() {
                match dbus_server.wait_and_process(Duration::from_secs(1)).map_err(|_|DeamonError::Error) {
                    Ok(it) => it,
                    Err(err) => return Err(err),
                };
            }

            Ok(())
        });
        self.join_handle = Some(thread_handle);
        Ok(())
    }

    fn handle_actions(sender:StreamSink<DeamonAction>, recv:Receiver<DeamonAction>) -> JoinHandle<Result<(), DeamonError>> {
        let join_handle = std::thread::spawn(move ||{
            let mut notifications: Vec<Notification> = Vec::new();
            for action in recv {
                match action {
                    DeamonAction::Show(notification) => {
                       notifications.retain(|v|v.id != notification.id);
                       notifications.push(notification.clone()); 
                       if let false = sender.add(DeamonAction::Show(notification)){
                           return Err(DeamonError::Error)
                       }
                    },
                    DeamonAction::Close(id) => {
                       notifications.retain(|v|v.id != id);
                       if let false = sender.add(DeamonAction::Close(id)){
                           return Err(DeamonError::Error)
                       }
                    },
                    DeamonAction::ClientClose(id) => {
                       notifications.retain(|v|v.id != id);
                       if let false = sender.add(DeamonAction::Close(id)){
                           return Err(DeamonError::Error)
                       }
                    },
                }
            }
            Ok(())
        });
        join_handle
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

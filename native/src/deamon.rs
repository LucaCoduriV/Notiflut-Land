use std::{
    sync::{Arc, Mutex, mpsc::Sender},
    time::Duration, thread::JoinHandle,
};
use flutter_rust_bridge::StreamSink;

use crate::dbus::{self, DeamonAction};
#[derive(thiserror::Error, Debug)]
pub enum DeamonResult{
    #[error("An error occured")]
    Error,
    #[error("The deamon is already down")]
    AlreadyDown,
    #[error("The deamon is aldready up")]
    AlreadyUp 
}

pub struct NotificationDeamon{
    stop: Arc<Mutex<bool>>,
    join_handle: Option<JoinHandle<Result<(), DeamonResult>>>
}

impl NotificationDeamon {

    pub fn new() -> Self {
        NotificationDeamon { stop: Arc::new(Mutex::new(false)), join_handle: None }
    } 

    pub fn run_deamon(&mut self, sdr: StreamSink<DeamonAction>) -> Result<(), DeamonResult> {
        println!("coucou");
        if *self.stop.lock().unwrap(){
            return Err(DeamonResult::AlreadyUp).into();
        }
        let mut dbus_server = dbus::DbusServer::init().map_err(|_|DeamonResult::Error)?;

        dbus_server.register_notification_handler(sdr).map_err(|_|DeamonResult::Error)?;
        let stop = Arc::clone(&self.stop);
        let thread_handle = std::thread::spawn(move ||{
            while !*stop.lock().unwrap() {
                match dbus_server.wait_and_process(Duration::from_secs(1)).map_err(|_|DeamonResult::Error) {
                    Ok(it) => it,
                    Err(err) => return Err(err),
                };
            }

            Ok(())
        });
        self.join_handle = Some(thread_handle);
        Ok(())
    }

    pub fn stop_deamon(&mut self) -> Result<(), DeamonResult> {
        *self.stop.lock().unwrap() = true;
        let handle = self.join_handle.take();
        let result = match handle {
            Some(h) => h.join(),
            None => {return Err(DeamonResult::AlreadyDown);},
        };
        print!("{result:?}");
        return Ok(());
    }
}

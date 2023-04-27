use std::{
    sync::{Arc, Mutex},
    time::Duration, thread::JoinHandle,
};
use crate::dbus;
#[derive(thiserror::Error, Debug)]
pub enum DeamonResult{
    #[error("An error occured")]
    Error,
    #[error("The deamon is already down")]
    AlreadyDown
}

pub struct NotificationDeamon{
    stop: Arc<Mutex<bool>>,
    join_handle: Option<JoinHandle<Result<(), DeamonResult>>>
}
impl NotificationDeamon {

    pub fn new() -> Self {
        NotificationDeamon { stop: Arc::new(Mutex::new(false)), join_handle: None }
    } 

    pub fn run_deamon(&mut self) -> Result<(), Box<dyn std::error::Error>> {
        let (sdr, _recv) = std::sync::mpsc::channel();
        let mut dbus_server = dbus::DbusServer::init()?;

        dbus_server.register_notification_handler(sdr)?;
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
            None => {return Err(DeamonResult::Error);},
        };
        print!("{result:?}");
        return Ok(());
    }
}

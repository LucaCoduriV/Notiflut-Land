use std::{
    sync::{Arc, Mutex},
    time::Duration, thread::JoinHandle,
};
use crate::dbus;
pub enum DeamonResult{
    Error,
    Success,
}
pub struct NotificationDeamon{
    stop: Arc<Mutex<bool>>,
    join_handle: Option<JoinHandle<Result<(), Box<dyn std::error::Error>>>>
}
impl NotificationDeamon {
    
    pub fn run_deamon(&mut self) -> Result<(), Box<dyn std::error::Error>> {
        let (sdr, _recv) = std::sync::mpsc::channel();
        let mut dbus_server = dbus::DbusServer::init()?;

        dbus_server.register_notification_handler(sdr)?;
        let stop = Arc::clone(&self.stop);
        let thread_handle = std::thread::spawn(move ||{
            while !*stop.lock().unwrap() {
                dbus_server.wait_and_process(Duration::from_secs(1))?;
            }

            Ok(())
        });
        self.join_handle = Some(thread_handle);
        Ok(())
    }

    pub fn stop_deamon(&self) {
        let result = self.join_handle.unwrap().join();
    }
}

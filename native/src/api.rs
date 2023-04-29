use std::sync::Mutex;

use anyhow::Ok;
use flutter_rust_bridge::StreamSink;
use once_cell::sync::OnceCell;

use crate::{deamon::NotificationDeamon, dbus::DeamonAction};

// static SINK: OnceCell<StreamSink<i32>> = OnceCell::new();
static DEAMON:Mutex<Option<NotificationDeamon>> = Mutex::new(None);

pub fn setup(){
    *DEAMON.lock().unwrap() = Some(NotificationDeamon::new());
}

pub fn start_deamon(s:StreamSink<DeamonAction>) -> anyhow::Result<()>   {
    DEAMON.lock().unwrap().as_mut().unwrap().run_deamon(s)?;
    Ok(())
}

pub fn stop_deamon() -> anyhow::Result<()>{
    DEAMON.lock().unwrap().as_mut().unwrap().stop_deamon()?;
    Ok(())
}

// pub fn create_sink(s: StreamSink<i32>) {
//     SINK.set(s).ok();
// }
//
// pub fn generate_number() {
//     if let Some(sink) = SINK.get() {
//         for i in 0..10 {
//             sink.add(i);
//             std::thread::sleep(std::time::Duration::from_secs(1))
//         }
//     }
// }

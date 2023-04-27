use std::sync::Mutex;

use flutter_rust_bridge::StreamSink;
use once_cell::sync::OnceCell;

use crate::deamon::NotificationDeamon;

static SINK: OnceCell<StreamSink<i32>> = OnceCell::new();
static DEAMON:Mutex<Option<NotificationDeamon>> = Mutex::new(None);

pub fn setup(){
    *DEAMON.lock().unwrap() = Some(NotificationDeamon::new());
}

pub fn start_deamon()   {
    DEAMON.lock().unwrap().as_mut().unwrap().run_deamon().ok();
}

pub fn stop_deamon() {
    DEAMON.lock().unwrap().as_mut().unwrap().stop_deamon().ok();
}

pub fn create_sink(s: StreamSink<i32>) {
    SINK.set(s).ok();
}

pub fn generate_number() {
    if let Some(sink) = SINK.get() {
        for i in 0..10 {
            sink.add(i);
            std::thread::sleep(std::time::Duration::from_secs(1))
        }
    }
}

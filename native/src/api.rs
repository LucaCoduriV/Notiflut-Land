use std::sync::Mutex;

use anyhow::Ok;
use flutter_rust_bridge::StreamSink;

use crate::{deamon::{NotificationDeamon, ChannelMessage}, dbus::DeamonAction};

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

pub fn send_deamon_action(action: DeamonAction) -> anyhow::Result<()> {
    DEAMON.lock().unwrap().as_mut().unwrap().sender.as_mut().unwrap().send(ChannelMessage::Message(action))?;
    Ok(())
}

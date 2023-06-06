use std::sync::Mutex;

use anyhow::Ok;
use flutter_rust_bridge::StreamSink;

use crate::{
    daemon::{ChannelMessage, NotificationDaemon},
    dbus::DaemonAction,
};

static DAEMON: Mutex<Option<NotificationDaemon>> = Mutex::new(None);

pub fn setup() {
    *DAEMON.lock().unwrap() = Some(NotificationDaemon::new());
}

pub fn start_daemon(s: StreamSink<DaemonAction>) -> anyhow::Result<()> {
    DAEMON.lock().unwrap().as_mut().unwrap().run_daemon(s)?;
    Ok(())
}

pub fn stop_daemon() -> anyhow::Result<()> {
    DAEMON.lock().unwrap().as_mut().unwrap().stop_daemon()?;
    Ok(())
}

pub fn send_daemon_action(action: DaemonAction) -> anyhow::Result<()> {
    DAEMON
        .lock()
        .unwrap()
        .as_mut()
        .unwrap()
        .sender
        .as_mut()
        .unwrap()
        .send(ChannelMessage::Message(action))?;
    Ok(())
}

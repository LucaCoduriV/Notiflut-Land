use std::sync::Mutex;

use anyhow::Ok;
use flutter_rust_bridge::StreamSink;

use crate::{
    daemon::{ChannelMessage, DaemonError, NotificationDaemon},
    dbus::DaemonAction,
};

/// Global instance of the daemon
static DAEMON: Mutex<Option<NotificationDaemon>> = Mutex::new(None);

/// This needs to be called first
pub fn setup() {
    *DAEMON.lock().unwrap() = Some(NotificationDaemon::new());
}

/// Starts the daemon
/// This can fail if setup was not called before
pub fn start_daemon(s: StreamSink<DaemonAction>) -> anyhow::Result<()> {
    DAEMON
        .lock()
        .unwrap()
        .as_mut()
        .ok_or(DaemonError::Error)?
        .run_daemon(s)?;
    Ok(())
}

/// Stop the daemon
pub fn stop_daemon() -> anyhow::Result<()> {
    DAEMON
        .lock()
        .unwrap()
        .as_mut()
        .ok_or(DaemonError::Error)?
        .stop_daemon()?;
    Ok(())
}

/// Sends an event to rust code
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

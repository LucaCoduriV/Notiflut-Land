use std::sync::mpsc::Sender;
use std::sync::Mutex;

use anyhow::Ok;

use crate::{
    daemon::{AppEvent, ChannelMessage, DaemonError, NotificationDaemon},
    dbus::DaemonEvent,
};

/// Global instance of the daemon
static DAEMON: Mutex<Option<NotificationDaemon>> = Mutex::new(None);

/// This needs to be called first
pub fn setup() {
    *DAEMON.lock().unwrap() = Some(NotificationDaemon::new());
}

/// Starts the daemon
/// This can fail if setup was not called before
pub fn start_daemon(s: Sender<DaemonEvent>) -> anyhow::Result<()> {
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
pub fn send_app_event(action: AppEvent) -> anyhow::Result<()> {
    DAEMON
        .lock()
        .unwrap()
        .as_mut()
        .unwrap()
        .sender
        .as_mut()
        .unwrap()
        .send(ChannelMessage::DaemonAction(action))?;
    Ok(())
}

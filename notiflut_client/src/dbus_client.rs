use anyhow::Result;
use dbus::blocking::Connection;
use dbus::blocking::Proxy;
use std::time::Duration;

/// D-Bus interface for desktop notifications.
pub const NOTIFICATION_INTERFACE: &str = "org.freedesktop.Notifications";

/// D-Bus path for desktop notifications.
pub const NOTIFICATION_PATH: &str = "/org/freedesktop/Notifications";

pub struct DbusClient {
    connection: Connection,
}

impl DbusClient {
    pub fn init() -> Result<Self> {
        let connection = Connection::new_session()?;
        Ok(Self { connection })
    }

    pub fn open_nc(&self) -> Result<()> {
        let proxy = Proxy::new(
            NOTIFICATION_INTERFACE,
            format!("{NOTIFICATION_PATH}/ctl"),
            Duration::from_millis(1000),
            &self.connection,
        );

        let result: (String,) = proxy.method_call(NOTIFICATION_INTERFACE, "OpenNC", ())?;
        println!("{}", result.0);

        Ok(())
    }

    pub fn close_nc(&self) -> Result<()> {
        let proxy = Proxy::new(
            NOTIFICATION_INTERFACE,
            format!("{NOTIFICATION_PATH}/ctl"),
            Duration::from_millis(1000),
            &self.connection,
        );

        let result: (String,) = proxy.method_call(NOTIFICATION_INTERFACE, "CloseNC", ())?;
        println!("{}", result.0);

        Ok(())
    }
}

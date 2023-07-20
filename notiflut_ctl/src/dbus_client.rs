use anyhow::Result;
use dbus::blocking::Connection;
use dbus::blocking::Proxy;
use std::rc::Rc;
use std::time::Duration;

/// D-Bus interface for desktop notifications.
pub const NOTIFICATION_INTERFACE: &str = "org.freedesktop.Notifications";

/// D-Bus path for desktop notifications.
pub const NOTIFICATION_PATH: &str = "/org/freedesktop/Notifications";

pub struct DbusClient<'a> {
    connection: Rc<Connection>,
    proxy: Proxy<'a, Rc<Connection>>,
}

impl<'a> DbusClient<'a> {
    pub fn init() -> Result<Self> {
        let connection = Connection::new_session()?;
        let ref_counter = Rc::new(connection);
        let dc: DbusClient = Self {
            connection: ref_counter.clone(),
            proxy: Proxy::new(
                NOTIFICATION_INTERFACE,
                format!("{NOTIFICATION_PATH}/ctl"),
                Duration::from_millis(1000),
                ref_counter,
            ),
        };

        Ok(dc)
    }

    pub fn show_nc(&self) -> Result<String> {
        let result: (String,) = self
            .proxy
            .method_call(NOTIFICATION_INTERFACE, "OpenNC", ())?;

        Ok(result.0)
    }

    pub fn toggle_nc(&self) -> Result<String> {
        let result: (String,) = self
            .proxy
            .method_call(NOTIFICATION_INTERFACE, "ToggleNC", ())?;

        Ok(result.0)
    }

    pub fn hide_nc(&self) -> Result<String> {
        let result: (String,) = self
            .proxy
            .method_call(NOTIFICATION_INTERFACE, "CloseNC", ())?;

        Ok(result.0)
    }
}

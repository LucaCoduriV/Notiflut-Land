use std::{
    collections::VecDeque,
    error::Error,
    sync::{
        atomic::{AtomicU32, Ordering},
        mpsc::Sender,
    },
    time::Duration,
};

use dbus::{
    arg::{prop_cast, RefArg},
    blocking::Connection,
    channel::MatchingReceiver,
    message::MatchRule,
    MethodErr,
};
use dbus_crossroads::Crossroads;

use crate::{
    daemon::ChannelMessage,
    dbus_definition,
    desktop_file_manager::DesktopFileManager,
    notification::{Hints, ImageData, ImageSource, Notification},
};
/// D-Bus interface for desktop notifications.
pub const NOTIFICATION_INTERFACE: &str = "org.freedesktop.Notifications";

/// D-Bus path for desktop notifications.
pub const NOTIFICATION_PATH: &str = "/org/freedesktop/Notifications";

/// Specifically, the server name, vendor, version, and spec version from freedesktop Notification.
const SERVER_INFO: (&str, &str, &str, &str) = (
    env!("CARGO_PKG_NAME"),
    env!("CARGO_PKG_AUTHORS"),
    env!("CARGO_PKG_VERSION"),
    "1.2",
);

static ID_COUNT: AtomicU32 = AtomicU32::new(1);
/// D-Bus server capabilities.
///
/// "action-icons"       Supports using icons instead of text for displaying actions.
///                      Using icons for actions must be enabled on a per-notification basis using the "action-icons" hint.
///
/// "actions"            The server will provide the specified actions to the user. Even if this cap is missing,
///                      actions may still be specified by the client, however the server is free to ignore them.
///
/// "body"               Supports body text. Some implementations may only show the summary (for instance, onscreen displays, marquee/scrollers)
/// "body-hyperlinks"    The server supports hyperlinks in the notifications.
/// "body-images"        The server supports images in the notifications.
/// "body-markup"        Supports markup in the body text. If marked up text is sent to a server that does not give this cap,
///                      the markup will show through as regular text so must be stripped clientside.
///
/// "icon-multi"         The server will render an animation of all the frames in a given image array.
///                      The client may still specify multiple frames even if this cap and/or "icon-static" is missing,
///                      however the server is free to ignore them and use only the primary frame.
///
/// "icon-static"        Supports display of exactly 1 frame of any given image array.
///                      This value is mutually exclusive with "icon-multi", it is a protocol error for the server to specify both.
///
/// "persistence"        The server supports persistence of notifications. Notifications will be retained until they are acknowledged or
///                      removed by the user or recalled by the sender. The presence of this capability allows clients to depend
///                      on the server to ensure a notification is seen and eliminate the need for the client to display a reminding function
///                      (such as a status icon) of its own.
///
/// "sound"              The server supports sounds on notifications. If returned, the server must support the "sound-file" and "suppress-sound" hints.

const SERVER_CAPABILITIES: [&str; 8] = [
    "actions",
    "body",
    // "action-icons",
    "actions",
    "body-hyperlinks",
    "body-images",
    "body-markup",
    "icon-static",
    "persistence",
];

#[derive(Debug)]
pub enum DaemonAction {
    Show(Notification),
    ShowNc,
    CloseNc,
    Close(u32),
    Update(Vec<Notification>, Option<usize>),
    FlutterClose(u32),
    FlutterCloseAll,
    FlutterActionInvoked(u32, String),
}

/// DbusNotification is responsible to react to dbus callbacks by sending
/// all events through channel to let the daemon decide what to do
pub struct DbusNotification {
    sender: Sender<ChannelMessage<DaemonAction>>,
}

impl DbusNotification {
    /// This function helps to have a unique way to read image and icon
    /// from notifications. It gets all possible data entry and outputs one
    /// image and one icon.
    /// An implementation which can display both the image and icon
    /// must show the icon from the "app_icon" parameter and choose which image to display using the following order:
    ///     1. "image-data"
    ///     2. "image-path"
    ///     3. for compatibility reason, "icon_data"
    /// In case none of these parameter are provided we will try to use the
    /// application name to find the icon.
    fn get_icon_and_image(
        app_name: String,
        desktop_entry_name: Option<String>,
        app_icon: String,
        image_data: Option<ImageData>,
        image_path: Option<String>,
        icon_data: Option<ImageData>,
    ) -> (Option<ImageSource>, Option<ImageSource>) {
        let icon: Option<ImageSource> = if !app_icon.is_empty() {
            app_icon
                .starts_with("file://")
                .then(|| ImageSource::Path(app_icon.replace("file://", "")))
                .or(freedesktop_icons::lookup(&app_icon)
                    .find()
                    .and_then(|p| Some(p.to_str().unwrap().to_string()))
                    .and_then(|p| Some(ImageSource::Path(p))))
        } else {
            let desk = DesktopFileManager::new();
            let file_name = desktop_entry_name.unwrap_or_else(|| app_name.to_lowercase());

            // using find because the app name doesn't have to be the desktop file name.
            let icon = desk.find(&(file_name)).and_then(|v| v.icon);
            icon.and_then(|icon| {
                icon.starts_with("file://")
                    .then(|| ImageSource::Path(icon.replace("file://", "")))
                    .or(freedesktop_icons::lookup(&icon)
                        .find()
                        .and_then(|p| Some(p.to_str().unwrap().to_string()))
                        .and_then(|p| Some(ImageSource::Path(p))))
            })
        };

        let image: Option<ImageSource> = if image_data.is_some() {
            Some(ImageSource::Data(image_data.unwrap()))
        } else if let Some(image) = image_path {
            image
                .starts_with("file://")
                .then(|| ImageSource::Path(image.replace("file://", "")))
                .or(freedesktop_icons::lookup(&image)
                    .find()
                    .and_then(|p| Some(p.to_str().unwrap().to_string()))
                    .and_then(|p| Some(ImageSource::Path(p))))
        } else {
            icon_data.map(|data| ImageSource::Data(data))
        };

        (icon, image)
    }
}

impl dbus_definition::OrgFreedesktopNotifications for DbusNotification {
    fn get_server_information(
        &mut self,
    ) -> Result<(String, String, String, String), dbus::MethodErr> {
        Ok((
            SERVER_INFO.0.to_string(),
            SERVER_INFO.1.to_string(),
            SERVER_INFO.2.to_string(),
            SERVER_INFO.3.to_string(),
        ))
    }

    fn get_capabilities(&mut self) -> Result<Vec<String>, dbus::MethodErr> {
        Ok(SERVER_CAPABILITIES.map(|v| v.to_string()).to_vec())
    }

    fn close_notification(&mut self, id: u32) -> Result<(), dbus::MethodErr> {
        if let Err(_) = self
            .sender
            .send(ChannelMessage::Message(DaemonAction::Close(id)))
        {
            return Err(dbus::MethodErr::failed(
                "Error with channel, couldn't send the action.",
            ));
        }
        Ok(())
    }

    fn notify(
        &mut self,
        app_name: String,
        replaces_id: u32,
        app_icon: String,
        summary: String,
        body: String,
        actions: Vec<String>,
        hints: dbus::arg::PropMap,
        timeout: i32,
    ) -> Result<u32, dbus::MethodErr> {
        let id = if replaces_id == 0 {
            ID_COUNT.fetch_add(1, Ordering::Relaxed)
        } else {
            replaces_id
        };

        let image_data = match prop_cast::<VecDeque<Box<dyn RefArg>>>(&hints, "image-data") {
            Some(v) => ImageData::try_from(v).ok(),
            None => None,
        };

        let icon_data = match prop_cast::<VecDeque<Box<dyn RefArg>>>(&hints, "icon_data") {
            Some(v) => ImageData::try_from(v).ok(),
            None => None,
        };

        let image_path = prop_cast::<String>(&hints, "image-path").cloned();

        let hints = Hints::from(&hints);

        let (app_icon, app_image) = DbusNotification::get_icon_and_image(
            app_name.clone(),            // TODO should not clone
            hints.clone().desktop_entry, // TODO should not clone
            app_icon,
            image_data,
            image_path,
            icon_data,
        );

        let notification = Notification {
            id,
            app_name,
            replaces_id,
            summary,
            body,
            actions,
            hints,
            timeout,
            created_at: chrono::Utc::now(),
            app_image,
            app_icon,
        };
        println!("{notification:#?}");

        if let Err(_) = self
            .sender
            .send(ChannelMessage::Message(DaemonAction::Show(notification)))
        {
            return Err(dbus::MethodErr::failed(
                "Error with channel, couldn't send the action.",
            ));
        };

        Ok(id)
    }
}

/// DbusServer is responsible to register as a notification server and listen
/// to Notification events and events from our control app
pub struct DbusServer {
    pub connection: Connection,
}

impl DbusServer {
    pub fn init() -> Result<Self, Box<dyn Error>> {
        let conn = Connection::new_session()?;
        Ok(DbusServer { connection: conn })
    }

    pub fn register_notification_handler(
        &mut self,
        sender: Sender<ChannelMessage<DaemonAction>>,
    ) -> Result<(), Box<dyn Error>> {
        let mut crossroad = Crossroads::new();

        // register our notification server to dbus
        self.connection
            .request_name(NOTIFICATION_INTERFACE, false, true, false)?;
        let token = dbus_definition::register_org_freedesktop_notifications(&mut crossroad);
        crossroad.insert(
            NOTIFICATION_PATH,
            &[token],
            DbusNotification {
                sender: sender.clone(),
            },
        );

        // register our custom methods
        let token = crossroad.register(NOTIFICATION_INTERFACE, |builder| {
            let sender_clonded = sender.clone();
            builder.method("OpenNC", (), ("reply",), move |_, _, ()| {
                sender_clonded
                    .send(ChannelMessage::Message(DaemonAction::ShowNc))
                    .map_err(|e| MethodErr::failed(&e))?;
                Ok((String::from("Notification center open"),))
            });

            let sender_clonded = sender.clone();
            builder.method("CloseNC", (), ("reply",), move |_, _, ()| {
                sender_clonded
                    .send(ChannelMessage::Message(DaemonAction::CloseNc))
                    .map_err(|e| MethodErr::failed(&e))?;
                Ok((String::from("Notification center closed"),))
            });
        });

        crossroad.insert(format!("{NOTIFICATION_PATH}/ctl"), &[token], ());

        self.connection.start_receive(
            MatchRule::new_method_call(),
            Box::new(move |message, connection| {
                crossroad
                    .handle_message(message, connection)
                    .expect("failed to handle message");
                true
            }),
        );
        Ok(())
    }

    pub fn wait_and_process(&mut self, timeout: Duration) -> Result<bool, Box<dyn Error>> {
        let result = self.connection.process(timeout)?;
        self.connection.channel().flush();
        Ok(result)
    }
}

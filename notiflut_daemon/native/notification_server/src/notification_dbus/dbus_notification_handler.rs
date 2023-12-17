use std::{
    collections::VecDeque,
    sync::{Arc, Mutex},
};

use dbus::arg::{prop_cast, RefArg};
use tracing::debug;

use crate::desktop_file_manager::DesktopFileManager;
use crate::notification_dbus::models::notification::{Hints, ImageData, ImageSource, Notification};

use super::dbus_definition;

const SERVER_INFO: (&str, &str, &str, &str) = (
    env!("CARGO_PKG_NAME"),
    env!("CARGO_PKG_AUTHORS"),
    env!("CARGO_PKG_VERSION"),
    "1.2",
);

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

#[derive(Clone)]
pub struct DbusNotificationHandler {
    pub id_count: Arc<Mutex<u32>>,
    pub sender: tokio::sync::mpsc::Sender<InnerServerEvent>,
}

#[derive(Debug)]
pub enum InnerServerEvent {
    ToggleNotificationCenter,
    CloseNotificationCenter,
    OpenNotificationCenter,
    CloseNotification(u32),
    NewNotification(Box<Notification>),
    NewNotificationId(u32),
    Reload,
    ThemeDark,
    ThemeLight,
}

impl dbus_definition::OrgFreedesktopNotifications for DbusNotificationHandler {
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
        let id = {
            let mut id_count = self.id_count.lock().unwrap();

            if replaces_id == 0 {
                let id = *id_count;
                *id_count = id_count.wrapping_add(1);
                id
            } else {
                replaces_id
            }
        };
        let sender = self.sender.clone();
        tokio::spawn(async move {
            let result = sender.send(InnerServerEvent::NewNotificationId(id)).await;
            debug!("{:?}", result);
        });

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

        // If there is no app name we try to define one
        let app_name = if app_name.is_empty() {
            hints
                .desktop_entry
                .as_ref()
                .map(|e| {
                    e.clone()
                        .replace("org", "")
                        .replace(".desktop", "")
                        .replace("com", "")
                        .replace('.', "")
                        .replace("freedesktop", "")
                })
                .unwrap_or(String::from("Unknown"))
        } else {
            app_name
        };

        let (app_icon, app_image) = get_icon_and_image(
            &app_name,
            hints.desktop_entry.clone(),
            app_icon,
            image_data,
            image_path,
            icon_data,
        );

        let notification = Notification {
            n_id: id,
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

        let sender = self.sender.clone();
        tokio::spawn(async move {
            let result = sender
                .send(InnerServerEvent::NewNotification(Box::new(notification)))
                .await;
            debug!("{:?}", result);
        });

        Ok(id)
    }

    fn close_notification(&mut self, id: u32) -> Result<(), dbus::MethodErr> {
        let sender = self.sender.clone();
        tokio::spawn(async move {
            let result = sender.send(InnerServerEvent::CloseNotification(id)).await;
            debug!("{:?}", result);
        });
        Ok(())
    }

    fn get_capabilities(&mut self) -> Result<Vec<String>, dbus::MethodErr> {
        Ok(SERVER_CAPABILITIES.map(|v| v.to_string()).to_vec())
    }

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
}

/// An implementation which can display both the image and icon
/// must show the icon from the "app_icon" parameter and choose which image to display using the following order:
///     1. "image-data"
///     2. "image-path"
///     3. for compatibility reason, "icon_data"
/// This function helps to have a unique way to read image and icon
/// from notifications. It gets all possible data and outputs one
/// image and one icon.
/// In case none of these parameter are provided we will try to use the
/// application name to find the icon.
fn get_icon_and_image(
    app_name: &str,
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
                .with_size(48)
                .find()
                .map(|p| p.to_str().unwrap().to_string())
                .map(ImageSource::Path))
    } else {
        let desk = DesktopFileManager::new();
        let file_name = desktop_entry_name.unwrap_or_else(|| app_name.to_lowercase());

        // using find because the app name doesn't have to be the desktop file name.
        let icon = desk.find(&(file_name)).and_then(|v| v.icon);
        icon.and_then(|icon| {
            icon.starts_with("file://")
                .then(|| ImageSource::Path(icon.replace("file://", "")))
                .or(freedesktop_icons::lookup(&icon)
                    .with_size(48)
                    .find()
                    .map(|p| p.to_str().unwrap().to_string())
                    .map(ImageSource::Path))
        })
    };

    let image: Option<ImageSource> = if let Some(data) = image_data {
        Some(ImageSource::Data(data))
    } else if let Some(image) = image_path {
        image
            .starts_with("file://")
            .then(|| ImageSource::Path(image.replace("file://", "")))
            .or(freedesktop_icons::lookup(&image)
                .with_size(48)
                .find()
                .map(|p| p.to_str().unwrap().to_string())
                .map(ImageSource::Path))
    } else {
        icon_data.map(ImageSource::Data)
    };

    (icon, image)
}

use std::{error::Error, sync::{mpsc::Sender, atomic::{AtomicU32, Ordering}}, time::{Duration}};

use dbus::{blocking::Connection, message::MatchRule, channel::MatchingReceiver, MethodErr, };
use dbus_crossroads::Crossroads;

use crate::{notification::{Notification, Hints}, dbus_definition, deamon::ChannelMessage};
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
pub enum DeamonAction {
    Show(Notification),
    ShowNc,
    CloseNc,
    Close(u32),
    Update(Vec<Notification>, Option<usize>),
    ClientClose(u32),
    ClientActionInvoked(u32, String),
}

pub struct DbusNotification {
    sender: Sender<ChannelMessage<DeamonAction>>,
}

impl dbus_definition::OrgFreedesktopNotifications for DbusNotification {
    fn get_server_information(&mut self) -> Result<(String,String,String,String),dbus::MethodErr> {
        Ok((
            SERVER_INFO.0.to_string(),
            SERVER_INFO.1.to_string(),
            SERVER_INFO.2.to_string(),
            SERVER_INFO.3.to_string(),
        ))
    }

    fn get_capabilities(&mut self) -> Result<Vec<String>,dbus::MethodErr> {
        Ok(SERVER_CAPABILITIES.map(|v|v.to_string()).to_vec())
    }

    fn close_notification(&mut self,id:u32) -> Result<(),dbus::MethodErr> {
        if let Err(_) = self.sender.send(ChannelMessage::Message(DeamonAction::Close(id))){
            return Err(dbus::MethodErr::failed("Error with channel, couldn't send the action."));
        }
        Ok(())
    }

    fn notify(
            &mut self,
            app_name:String,
            replaces_id:u32,
            app_icon:String,
            summary:String,
            body:String,
            actions:Vec<String>,
            hints:dbus::arg::PropMap,
            timeout:i32
    ) -> Result<u32,dbus::MethodErr> {
        let id = if replaces_id == 0 {
            ID_COUNT.fetch_add(1, Ordering::Relaxed)
        } else {
            replaces_id
        };
        let mut icon = String::from("");
        if !app_icon.is_empty() {
            if app_icon.starts_with("file://"){
                icon = app_icon;
            } else {
                if let Some(path) = freedesktop_icons::lookup(&app_icon).find() {
                    if let Some(str_path) = path.to_str(){
                        icon = String::from(str_path);
                    }
                }
            }
        }

        let mut hints = Hints::from(&hints);
        if let Some(path) = hints.image_path.take() {
            if !path.starts_with("file://"){
                if let Some(path) = freedesktop_icons::lookup(&path).find() {
                    if let Some(str_path) = path.to_str(){
                        hints.image_path = Some(String::from(str_path));
                    }
                }
            }else{
                hints.image_path = Some(path);
            }
        }

        let notification = Notification{
            id,
            app_name,
            replaces_id,
            icon,
            summary,
            body,
            actions,
            hints,
            timeout,
            created_at: chrono::Utc::now(),
        };
        println!(
            "id: {}, replace_id: {}, app_name: {}, summary: {}, icon: {:?} | {:?} | {:?} | {:?}, body: {}, actions: {:?}, timeout: {}", 
            notification.id, 
            notification.replaces_id,
            notification.app_name,
            notification.summary,
            notification.hints.image_data.is_some(),
            notification.hints.image_path,
            notification.hints.icon_data.is_some(),
            notification.icon,
            notification.body,
            notification.actions,
            timeout,
        );
        if let Err(_) = self.sender.send(ChannelMessage::Message(DeamonAction::Show(notification))){
            return Err(dbus::MethodErr::failed("Error with channel, couldn't send the action."));
        };
         
        Ok(id)
    }
}

pub struct DbusServer{
    pub connection: Connection,
}

impl DbusServer {
    pub fn init() -> Result<Self, Box<dyn Error>> {
        let conn = Connection::new_session()?;
        Ok(DbusServer {  
            connection: conn,
        })
    }

    pub fn register_notification_handler(&mut self, sender: Sender<ChannelMessage<DeamonAction>>) -> Result<(), Box<dyn Error>> {
        let mut crossroad = Crossroads::new();

        // register our notification server to dbus
        self.connection.request_name(NOTIFICATION_INTERFACE, false, true, false)?;
        let token = dbus_definition::register_org_freedesktop_notifications(&mut crossroad);
        crossroad.insert(NOTIFICATION_PATH, &[token], DbusNotification{
            sender: sender.clone(),
        }); 

        // register our custom methods
        let token = crossroad.register(NOTIFICATION_INTERFACE, |builder|{
            let sender_clonded = sender.clone();
            builder.method("OpenNC", (), ("reply",), move |_,_,()|{
                sender_clonded 
                    .send(ChannelMessage::Message(DeamonAction::ShowNc))
                    .map_err(|e| MethodErr::failed(&e))?;
                Ok((String::from("Notification center open"),))
            });

            let sender_clonded = sender.clone();
            builder.method("CloseNC", (), ("reply",), move |_,_,()|{
                sender_clonded 
                    .send(ChannelMessage::Message(DeamonAction::CloseNc))
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

use std::{error::Error, sync::mpsc::Sender, time::Duration};

use dbus::{blocking::Connection, message::MatchRule, channel::MatchingReceiver, };
use dbus_crossroads::Crossroads;

mod dbus_server {
    #![allow(clippy::too_many_arguments)]
    include!(concat!(env!("OUT_DIR"), "/introspection.rs"));
}

/// D-Bus interface for desktop notifications.
const NOTIFICATION_INTERFACE: &str = "org.freedesktop.Notifications";

/// D-Bus path for desktop notifications.
const NOTIFICATION_PATH: &str = "/org/freedesktop/Notifications";

/// Specifically, the server name, vendor, version, and spec version from freedesktop Notification.
const SERVER_INFO: (&str, &str, &str, &str) = (
    env!("CARGO_PKG_NAME"),
    env!("CARGO_PKG_AUTHORS"),
    env!("CARGO_PKG_VERSION"),
    "1.2",
);


/// D-Bus server capabilities.
///
// "action-icons"       Supports using icons instead of text for displaying actions. 
//                      Using icons for actions must be enabled on a per-notification basis using the "action-icons" hint.
//
// "actions"            The server will provide the specified actions to the user. Even if this cap is missing, 
//                      actions may still be specified by the client, however the server is free to ignore them.
//
// "body"               Supports body text. Some implementations may only show the summary (for instance, onscreen displays, marquee/scrollers)
// "body-hyperlinks"    The server supports hyperlinks in the notifications.
// "body-images"        The server supports images in the notifications.
// "body-markup"        Supports markup in the body text. If marked up text is sent to a server that does not give this cap, 
//                      the markup will show through as regular text so must be stripped clientside.
//
// "icon-multi"         The server will render an animation of all the frames in a given image array.
//                      The client may still specify multiple frames even if this cap and/or "icon-static" is missing, 
//                      however the server is free to ignore them and use only the primary frame.
//
// "icon-static"        Supports display of exactly 1 frame of any given image array.
//                      This value is mutually exclusive with "icon-multi", it is a protocol error for the server to specify both.
//
// "persistence"        The server supports persistence of notifications. Notifications will be retained until they are acknowledged or 
//                      removed by the user or recalled by the sender. The presence of this capability allows clients to depend 
//                      on the server to ensure a notification is seen and eliminate the need for the client to display a reminding function 
//                      (such as a status icon) of its own.
//
// "sound"              The server supports sounds on notifications. If returned, the server must support the "sound-file" and "suppress-sound" hints.

const SERVER_CAPABILITIES: [&str; 2] = ["actions", "body"];

#[derive(Debug)]
pub enum Action {
    Show,
    ShowLast,
    Close,
    CloseAll,
}

pub struct DbusNotification {
    sender: Sender<Action>,
}

impl dbus_server::OrgFreedesktopNotifications for DbusNotification {
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
        Ok(())
    }

    fn notify(&mut self,app_name:String,id:u32,icon:String,summary:String,body:String,actions:Vec<String>,_hints:dbus::arg::PropMap,timeout:i32) -> Result<u32,dbus::MethodErr> {
        println!("app_name:{app_name}, icon:{icon}, summary:{summary}, body:{body}, actions:{:?}, timeout: {timeout}", actions);
        Ok(id)
    }
}

pub struct DbusServer{
    connection: Connection,
}

impl DbusServer {
    pub fn init() -> Result<Self, Box<dyn Error>> {
        let conn = Connection::new_session()?;
        Ok(DbusServer {  
            connection: conn,
        })
    }

    pub fn register_notification_handler(&mut self, sender: Sender<Action>) -> Result<(), Box<dyn Error>> {
        let mut crossroad = Crossroads::new();

        // register our notification server to dbus
        self.connection.request_name(NOTIFICATION_INTERFACE, false, true, false)?;
        let token = dbus_server::register_org_freedesktop_notifications(&mut crossroad);
        crossroad.insert(NOTIFICATION_PATH, &[token], DbusNotification{
            sender: sender.clone(),
        }); 
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
            Ok(result)
    }
}

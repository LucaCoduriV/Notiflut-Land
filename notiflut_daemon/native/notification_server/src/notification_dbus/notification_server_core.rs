use std::sync::Arc;

use dbus::channel::{MatchingReceiver, Sender};
use dbus::message::{MatchRule, SignalArgs};
use dbus::nonblock::SyncConnection;
use dbus::Path;
use dbus_crossroads::Crossroads;
use dbus_tokio::connection;
use tokio::task::JoinHandle;

use crate::notification_dbus::dbus_notification_handler::DbusNotificationHandler;
use crate::notification_dbus::Notification;

use super::{dbus_definition, dbus_notification_handler};

pub const NOTIFICATION_INTERFACE: &str = "org.freedesktop.Notifications";
pub const NOTIFICATION_PATH: &str = "/org/freedesktop/Notifications";

pub struct NotificationServerCore {
    handle: JoinHandle<()>,
    connection: std::sync::Arc<SyncConnection>,
}

impl NotificationServerCore {
    pub fn run<F1, F2, F3, F4, F5, F6>(
        id_start: u32,
        on_notification: F1,
        on_close: F2,
        on_open_notification_center: F3,
        on_close_notification_center: F4,
        on_toggle_notification_center: F5,
        on_new_id: F6,
    ) -> anyhow::Result<Self>
    where
        F1: Fn(Notification) + Send + Clone + 'static,
        F2: Fn(u32) + Send + Clone + 'static,
        F3: Fn() + Send + Clone + 'static,
        F4: Fn() + Send + Clone + 'static,
        F5: Fn() + Send + Clone + 'static,
        F6: Fn(u32) + Send + Clone + 'static,
    {
        // Connect to the D-Bus session bus (this is blocking, unfortunately).
        let (resource, c) = connection::new_session_sync()?;

        // The resource is a task that should be spawned onto a tokio compatible
        // reactor ASAP. If the resource ever finishes, you lost connection to D-Bus.
        //
        // To shut down the connection, both call _handle.abort() and drop the connection.
        let handle = tokio::spawn(async {
            let err = resource.await;
            panic!("Lost connection to D-Bus: {}", err);
        });

        let connection = c.clone();

        tokio::spawn(async move {
            // Let's request a name on the bus, so that clients can find us.
            c.request_name(NOTIFICATION_INTERFACE, false, true, false)
                .await
                .unwrap();

            // Create a new crossroads instance.
            // The instance is configured so that introspection and properties interfaces
            // are added by default on object path additions.
            let mut cr = Crossroads::new();

            // Enable async support for the crossroads instance.
            cr.set_async_support(Some((
                c.clone(),
                Box::new(|x| {
                    tokio::spawn(x);
                }),
            )));

            let token =
                crate::notification_dbus::dbus_definition::register_org_freedesktop_notifications(
                    &mut cr,
                );

            cr.insert(
                NOTIFICATION_PATH,
                &[token],
                DbusNotificationHandler {
                    id_count: Arc::new(id_start.into()),
                    on_notification,
                    on_close,
                    on_new_id,
                },
            );

            // register our custom methods
            let token = cr.register(NOTIFICATION_INTERFACE, |builder| {
                builder.method_with_cr_async("OpenNC", (), ("reply",), move |mut ctx, _, ()| {
                    on_open_notification_center();
                    let message = (String::from("Notification center open"),);
                    async move { ctx.reply(Ok(message)) }
                });

                builder.method_with_cr_async("CloseNC", (), ("reply",), move |mut ctx, _, ()| {
                    on_close_notification_center();
                    let message = (String::from("Notification center closed"),);
                    async move { ctx.reply(Ok(message)) }
                });

                builder.method_with_cr_async("ToggleNC", (), ("reply",), move |mut ctx, _, ()| {
                    on_toggle_notification_center();
                    let message = (String::from("Notification center toggled"),);
                    async move { ctx.reply(Ok(message)) }
                });
            });

            cr.insert(format!("{NOTIFICATION_PATH}/ctl"), &[token], ());

            // We add the Crossroads instance to the connection so that incoming method calls will be handled.
            c.start_receive(
                MatchRule::new_method_call(),
                Box::new(move |msg, conn| {
                    cr.handle_message(msg, conn).unwrap();
                    true
                }),
            );
        });

        Ok(NotificationServerCore { handle, connection })
    }

    pub fn invoke_action(&self, id: u32, action_key: String) {
        let message = dbus_definition::OrgFreedesktopNotificationsActionInvoked { id, action_key };
        let path = Path::new(NOTIFICATION_PATH).unwrap();
        self.connection
            .send(message.to_emit_message(&path))
            .unwrap();
    }
}

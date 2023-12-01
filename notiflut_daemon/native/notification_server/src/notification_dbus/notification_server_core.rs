use std::sync::Arc;

use dbus::channel::{MatchingReceiver, Sender};
use dbus::message::{MatchRule, SignalArgs};
use dbus::nonblock::SyncConnection;
use dbus::Path;
use dbus_crossroads::Crossroads;
use dbus_tokio::connection;
use futures::Future;
use tokio::task::JoinHandle;
use tracing::trace;

use crate::notification_dbus::dbus_notification_handler::DbusNotificationHandler;
use crate::notification_dbus::Notification;

use super::dbus_definition;

pub const NOTIFICATION_INTERFACE: &str = "org.freedesktop.Notifications";
pub const NOTIFICATION_PATH: &str = "/org/freedesktop/Notifications";

pub struct NotificationServerCoreBuilder<F1, F2, F3, F4, F5, F6, F7, F7Fut>
where
    F1: Fn(Notification) + Send + Clone + 'static,
    F2: Fn(u32) + Send + Clone + 'static,
    F3: Fn() + Send + Clone + 'static,
    F4: Fn() + Send + Clone + 'static,
    F5: Fn() + Send + Clone + 'static,
    F6: Fn(u32) + Send + Clone + 'static,
    F7: Fn() -> F7Fut + Send + Clone + 'static,
    F7Fut: Future<Output = u64> + Send + 'static,
{
    start_id: Option<u32>,
    on_notification: Option<F1>,
    on_close: Option<F2>,
    on_open_notification_center: Option<F3>,
    on_close_notification_center: Option<F4>,
    on_toggle_notification_center: Option<F5>,
    on_new_id: Option<F6>,
    notification_count: Option<F7>,
}

impl<F1, F2, F3, F4, F5, F6, F7, F7Fut>
    NotificationServerCoreBuilder<F1, F2, F3, F4, F5, F6, F7, F7Fut>
where
    F1: Fn(Notification) + Send + Clone + 'static,
    F2: Fn(u32) + Send + Clone + 'static,
    F3: Fn() + Send + Clone + 'static,
    F4: Fn() + Send + Clone + 'static,
    F5: Fn() + Send + Clone + 'static,
    F6: Fn(u32) + Send + Clone + 'static,
    F7: Fn() -> F7Fut + Send + Clone + 'static,
    F7Fut: Future<Output = u64> + Send + 'static,
{
    fn new() -> Self {
        NotificationServerCoreBuilder {
            start_id: None,
            on_notification: None,
            on_close: None,
            on_open_notification_center: None,
            on_close_notification_center: None,
            on_toggle_notification_center: None,
            on_new_id: None,
            notification_count: None,
        }
    }
    pub fn on_notification(mut self, f: F1) -> Self {
        self.on_notification = Some(f);
        self
    }
    pub fn on_close(mut self, f: F2) -> Self {
        self.on_close = Some(f);
        self
    }
    pub fn on_open_notification_center(mut self, f: F3) -> Self {
        self.on_open_notification_center = Some(f);
        self
    }
    pub fn on_close_notification_center(mut self, f: F4) -> Self {
        self.on_close_notification_center = Some(f);
        self
    }
    pub fn on_toggle_notification_center(mut self, f: F5) -> Self {
        self.on_toggle_notification_center = Some(f);
        self
    }
    pub fn on_new_id(mut self, f: F6) -> Self {
        self.on_new_id = Some(f);
        self
    }
    pub fn notification_count(mut self, f: F7) -> Self {
        self.notification_count = Some(f);
        self
    }
    pub fn start_id(mut self, id: u32) -> Self {
        self.start_id = Some(id);
        self
    }
    pub fn run(self) -> anyhow::Result<NotificationServerCore> {
        let mut core = NotificationServerCore {
            handle: None,
            connection: None,
        };

        core.run(self)?;

        Ok(core)
    }
}

pub struct NotificationServerCore {
    handle: Option<JoinHandle<()>>,
    connection: Option<std::sync::Arc<SyncConnection>>,
}

impl NotificationServerCore {
    pub fn builder<F1, F2, F3, F4, F5, F6, F7, F7Fut>(
    ) -> NotificationServerCoreBuilder<F1, F2, F3, F4, F5, F6, F7, F7Fut>
    where
        F1: Fn(Notification) + Send + Clone + 'static,
        F2: Fn(u32) + Send + Clone + 'static,
        F3: Fn() + Send + Clone + 'static,
        F4: Fn() + Send + Clone + 'static,
        F5: Fn() + Send + Clone + 'static,
        F6: Fn(u32) + Send + Clone + 'static,
        F7: Fn() -> F7Fut + Send + Clone + 'static,
        F7Fut: Future<Output = u64> + Send + 'static,
    {
        NotificationServerCoreBuilder::new()
    }
    pub fn run<F1, F2, F3, F4, F5, F6, F7, F7Fut>(
        &mut self,
        mut core_builder: NotificationServerCoreBuilder<F1, F2, F3, F4, F5, F6, F7, F7Fut>,
    ) -> anyhow::Result<()>
    where
        F1: Fn(Notification) + Send + Clone + 'static,
        F2: Fn(u32) + Send + Clone + 'static,
        F3: Fn() + Send + Clone + 'static,
        F4: Fn() + Send + Clone + 'static,
        F5: Fn() + Send + Clone + 'static,
        F6: Fn(u32) + Send + Clone + 'static,
        F7: Fn() -> F7Fut + Send + Clone + 'static,
        F7Fut: Future<Output = u64> + Send + 'static,
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
                    id_count: Arc::new(core_builder.start_id.unwrap().into()),
                    on_notification: core_builder.on_notification.unwrap(),
                    on_close: core_builder.on_close.unwrap(),
                    on_new_id: core_builder.on_new_id.unwrap(),
                },
            );

            // register our custom methods
            let token = cr.register(NOTIFICATION_INTERFACE, |builder| {
                builder.method_with_cr_async("OpenNC", (), ("reply",), move |mut ctx, _, ()| {
                    if let Some(func) = core_builder.on_open_notification_center.clone().take() {
                        func()
                    }
                    let message = (String::from("Notification center open"),);
                    async move { ctx.reply(Ok(message)) }
                });

                builder.method_with_cr_async("CloseNC", (), ("reply",), move |mut ctx, _, ()| {
                    if let Some(func) = core_builder.on_close_notification_center.clone().take() {
                        func();
                    }
                    let message = (String::from("Notification center closed"),);
                    async move { ctx.reply(Ok(message)) }
                });

                builder.method_with_cr_async("ToggleNC", (), ("reply",), move |mut ctx, _, ()| {
                    if let Some(func) = core_builder.on_toggle_notification_center.clone().take() {
                        func();
                    }
                    let message = (String::from("Notification center toggled"),);
                    async move { ctx.reply(Ok(message)) }
                });

                builder.method_with_cr_async(
                    "notificationCount",
                    (),
                    ("reply",),
                    move |mut ctx, _, ()| {
                        let callback = core_builder.notification_count.take().clone();
                        async move {
                            let result = match callback {
                                Some(func) => {
                                    let future = func();
                                    future.await as u64
                                }
                                None => 0,
                            };
                            ctx.reply(Ok((result,)))
                        }
                    },
                );
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

        self.handle = Some(handle);
        self.connection = Some(connection);
        Ok(())
    }

    pub fn invoke_action(&self, id: u32, action_key: String) {
        let message = dbus_definition::OrgFreedesktopNotificationsActionInvoked { id, action_key };
        let path = Path::new(NOTIFICATION_PATH).unwrap();
        self.connection
            .as_ref()
            .unwrap()
            .send(message.to_emit_message(&path))
            .unwrap();
    }
}

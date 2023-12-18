use std::sync::Arc;

use dbus::channel::{MatchingReceiver, Sender};
use dbus::message::{MatchRule, SignalArgs};
use dbus::nonblock::SyncConnection;
use dbus::Path;
use dbus_crossroads::Crossroads;
use dbus_tokio::connection;
use futures::Future;
use tokio::sync::mpsc::channel;
use tokio::task::JoinHandle;

use crate::notification_dbus::dbus_notification_handler::DbusNotificationHandler;

use super::dbus_definition;
use super::dbus_notification_handler::InnerServerEvent;

pub const NOTIFICATION_INTERFACE: &str = "org.freedesktop.Notifications";
pub const NOTIFICATION_PATH: &str = "/org/freedesktop/Notifications";

pub struct NotificationServerCoreBuilder<F7, F7Fut>
where
    F7: Fn() -> F7Fut + Send + Clone + 'static,
    F7Fut: Future<Output = u64> + Send + 'static,
{
    start_id: Option<u32>,
    notification_count: Option<F7>,
}

impl<F7, F7Fut> NotificationServerCoreBuilder<F7, F7Fut>
where
    F7: Fn() -> F7Fut + Send + Clone + 'static,
    F7Fut: Future<Output = u64> + Send + 'static,
{
    fn new() -> Self {
        NotificationServerCoreBuilder {
            start_id: None,
            notification_count: None,
        }
    }
    pub fn notification_count(mut self, f: F7) -> Self {
        self.notification_count = Some(f);
        self
    }
    pub fn start_id(mut self, id: u32) -> Self {
        self.start_id = Some(id);
        self
    }
    pub fn run(
        self,
    ) -> anyhow::Result<(
        NotificationServerCore,
        tokio::sync::mpsc::Receiver<InnerServerEvent>,
    )> {
        let mut core = NotificationServerCore {
            handle: None,
            connection: None,
        };

        let recv = core.run(self)?;

        Ok((core, recv))
    }
}

pub struct NotificationServerCore {
    handle: Option<JoinHandle<()>>,
    connection: Option<std::sync::Arc<SyncConnection>>,
}

impl NotificationServerCore {
    pub fn builder<F7, F7Fut>() -> NotificationServerCoreBuilder<F7, F7Fut>
    where
        F7: Fn() -> F7Fut + Send + Clone + 'static,
        F7Fut: Future<Output = u64> + Send + 'static,
    {
        NotificationServerCoreBuilder::new()
    }
    pub fn run<F7, F7Fut>(
        &mut self,
        core_builder: NotificationServerCoreBuilder<F7, F7Fut>,
    ) -> anyhow::Result<tokio::sync::mpsc::Receiver<InnerServerEvent>>
    where
        F7: Fn() -> F7Fut + Send + Clone + 'static,
        F7Fut: Future<Output = u64> + Send + 'static,
    {
        let (sndr, recv) = channel::<InnerServerEvent>(20);
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
                    sender: sndr.clone(),
                },
            );

            // register our custom methods
            let token = cr.register(NOTIFICATION_INTERFACE, |builder| {
                let sender = sndr.clone();
                builder.method_with_cr_async("OpenNC", (), ("reply",), move |mut ctx, _, ()| {
                    let sender = sender.clone();
                    tokio::spawn(async move {
                        sender.send(InnerServerEvent::OpenNotificationCenter).await
                    });
                    let message = (String::from("Notification center open"),);
                    async move { ctx.reply(Ok(message)) }
                });

                let sender = sndr.clone();
                builder.method_with_cr_async("CloseNC", (), ("reply",), move |mut ctx, _, ()| {
                    let sender = sender.clone();
                    tokio::spawn(async move {
                        sender.send(InnerServerEvent::CloseNotificationCenter).await
                    });
                    let message = (String::from("Notification center closed"),);
                    async move { ctx.reply(Ok(message)) }
                });

                let sender = sndr.clone();
                builder.method_with_cr_async("ToggleNC", (), ("reply",), move |mut ctx, _, ()| {
                    let sender = sender.clone();
                    tokio::spawn(async move {
                        sender
                            .send(InnerServerEvent::ToggleNotificationCenter)
                            .await
                    });
                    let message = (String::from("Notification center toggled"),);
                    async move { ctx.reply(Ok(message)) }
                });

                let sender = sndr.clone();
                builder.method_with_cr_async("Reload", (), ("reply",), move |mut ctx, _, ()| {
                    let sender = sender.clone();
                    tokio::spawn(async move { sender.send(InnerServerEvent::Reload).await });
                    let message = (String::from("Notification center reloaded"),);
                    async move { ctx.reply(Ok(message)) }
                });

                let sender = sndr.clone();
                builder.method_with_cr_async("ThemeDark", (), ("reply",), move |mut ctx, _, ()| {
                    let sender = sender.clone();
                    tokio::spawn(async move { sender.send(InnerServerEvent::ThemeDark).await });
                    let message = (String::from("Theme changed to dark"),);
                    async move { ctx.reply(Ok(message)) }
                });

                let sender = sndr.clone();
                builder.method_with_cr_async(
                    "ThemeLight",
                    (),
                    ("reply",),
                    move |mut ctx, _, ()| {
                        let sender = sender.clone();
                        tokio::spawn(
                            async move { sender.send(InnerServerEvent::ThemeLight).await },
                        );
                        let message = (String::from("Theme changed to light"),);
                        async move { ctx.reply(Ok(message)) }
                    },
                );

                builder.method_with_cr_async(
                    "notificationCount",
                    (),
                    ("reply",),
                    move |mut ctx, _, ()| {
                        let callback = core_builder.notification_count.clone().take();
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
        Ok(recv)
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

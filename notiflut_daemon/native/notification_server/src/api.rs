#![allow(dead_code)]
use std::sync::{Arc, Mutex};

use crate::{
    cache,
    config::{ConfigIO, Settings, StyleInner, ThemeSettings},
    db::{AppSettings, Database},
    notification_dbus::ImageSource,
    notification_dbus::{notification_server_core::NotificationServerCore, InnerServerEvent},
    Notification, Style,
};

use tokio::sync::mpsc::channel;
use tracing::{debug, error, info, trace};

#[derive(Debug)]
pub enum NotificationCenterCommand {
    Open,
    Close,
    Toggle,
}

#[derive(Debug)]
pub enum NotificationServerEvent {
    ToggleNotificationCenter,
    CloseNotificationCenter,
    OpenNotificationCenter,
    CloseNotification(u32),
    NewNotification(Box<Notification>),
    StyleUpdate(Box<Style>),
    ThemeSelected(ThemeSettings),
}

pub struct NotificationServer {
    core: Option<Arc<NotificationServerCore>>,
    db: Arc<Database>,
    config: Arc<Settings>,
    style: Arc<Mutex<StyleInner>>,
}

impl NotificationServer {
    pub async fn new() -> Self {
        let config = Arc::new(Settings::from_file());
        let style = Arc::new(Mutex::new(StyleInner::from_file()));
        let db = Arc::new(Database::new().await);
        Self {
            core: None,
            db,
            config,
            style,
        }
    }

    pub async fn run(
        &mut self,
    ) -> anyhow::Result<tokio::sync::mpsc::Receiver<NotificationServerEvent>> {
        let (sndr, result_recv) = channel::<NotificationServerEvent>(20);

        // setup front-end
        Self::send_notification_in_db(self.db.clone(), sndr.clone());

        let style = { self.style.lock().unwrap().clone() };

        sndr.send(NotificationServerEvent::StyleUpdate(Box::new(style.into())))
            .await
            .unwrap();

        sndr.send(NotificationServerEvent::ThemeSelected(
            self.config.theme.clone(),
        ))
        .await
        .unwrap();

        let db = Arc::clone(&self.db);
        let config = Arc::clone(&self.config);

        let id = match self.db.get_app_settings().await.unwrap_or(None) {
            Some(a) => a.id_count,
            None => 1,
        };

        let (core, mut core_recv) = NotificationServerCore::builder()
            .start_id(id)
            .notification_count(move || {
                let db = db.clone();
                async move {
                    match db.get_notifications_count().await {
                        Ok(res) => res.unwrap_or(0),
                        Err(err) => {
                            error!("{}", err);
                            0
                        }
                    }
                }
            })
            .run()?;

        let db = self.db.clone();
        let style = self.style.clone();
        tokio::spawn(async move {
            while let Some(event) = core_recv.recv().await {
                match event {
                    InnerServerEvent::ToggleNotificationCenter => {
                        trace!("Toggle NotificationCenter");
                        sndr.send(NotificationServerEvent::ToggleNotificationCenter)
                            .await
                            .unwrap();
                    }
                    InnerServerEvent::CloseNotificationCenter => {
                        trace!("Close NotificationCenter");
                        sndr.send(NotificationServerEvent::CloseNotificationCenter)
                            .await
                            .unwrap();
                    }
                    InnerServerEvent::OpenNotificationCenter => {
                        trace!("Open NotificationCenter");
                        sndr.send(NotificationServerEvent::OpenNotificationCenter)
                            .await
                            .unwrap();
                    }
                    InnerServerEvent::CloseNotification(id) => {
                        let db = db.clone();
                        tokio::spawn(async move {
                            match db.delete_notification(id.into()).await {
                                Ok(_) => (),
                                Err(e) => error!("{}", e),
                            };
                            cache::delete_file_cache(&id.to_string()).await;
                        });

                        sndr.send(NotificationServerEvent::CloseNotification(id))
                            .await
                            .unwrap();
                    }
                    InnerServerEvent::NewNotification(mut boxed_notification) => 'nn: {
                        let notification = boxed_notification.as_mut();
                        debug!("{:?}", notification);
                        if let Some(emit_cfg) =
                            config.find_notification_emitter_settings(&notification.app_name)
                        {
                            if emit_cfg.ignore {
                                break 'nn;
                            }

                            if let Some(ref urgency) = notification.hints.urgency {
                                match urgency {
                                    crate::Urgency::Low => {
                                        notification.hints.urgency =
                                            Some((&emit_cfg.urgency_low_as).into())
                                    }
                                    crate::Urgency::Normal => {
                                        notification.hints.urgency =
                                            Some((&emit_cfg.urgency_normal_as).into())
                                    }
                                    crate::Urgency::Critical => {
                                        notification.hints.urgency =
                                            Some((&emit_cfg.urgency_critical_as).into())
                                    }
                                }
                            }
                        }

                        let n2 = notification.clone();
                        let db = db.clone();
                        tokio::spawn(async move {
                            match db.put_notification(&n2).await {
                                Ok(_) => (),
                                Err(e) => error!("{}", e),
                            };
                            if let Some(ImageSource::Path(ref path)) = n2.app_image {
                                debug!("New image: {}", path);
                                cache::insert_file_cache(&n2.n_id.to_string(), path).await;
                            }
                        });

                        sndr.send(NotificationServerEvent::NewNotification(boxed_notification))
                            .await
                            .unwrap();
                    }
                    InnerServerEvent::NewNotificationId(new_id) => {
                        let db = db.clone();
                        tokio::spawn(async move {
                            let mut app_settings = db
                                .get_app_settings()
                                .await
                                .unwrap_or(Some(AppSettings::default()))
                                .unwrap_or(AppSettings::default());

                            app_settings.id_count = new_id;

                            db.put_appsettings(app_settings).await.unwrap();
                        });
                    }
                    InnerServerEvent::Reload => {
                        let style = {
                            let mut s = style.lock().unwrap();
                            if let Err(err) = s.read_file() {
                                Err(err)
                            } else {
                                Ok(s.clone())
                            }
                        };

                        match style {
                            Ok(style) => {
                                sndr.send(NotificationServerEvent::StyleUpdate(Box::new(
                                    style.into(),
                                )))
                                .await
                                .unwrap();
                            }
                            Err(err) => {
                                error!("Couldn't reload: {}", err);
                            }
                        };
                    }
                    InnerServerEvent::ThemeDark => {
                        sndr.send(NotificationServerEvent::ThemeSelected(ThemeSettings::Dark))
                            .await
                            .unwrap();
                    }
                    InnerServerEvent::ThemeLight => {
                        sndr.send(NotificationServerEvent::ThemeSelected(ThemeSettings::Light))
                            .await
                            .unwrap();
                    }
                };
            }
        });

        self.core = Some(core.into());
        info!("Listening for new notification");
        Ok(result_recv)
    }

    /// calls the callback for each notification registered in the db.
    fn send_notification_in_db(
        db: Arc<Database>,
        sndr: tokio::sync::mpsc::Sender<NotificationServerEvent>,
    ) {
        tokio::spawn(async move {
            let sndr = sndr;
            let notifications = match db.get_notifications().await {
                Ok(notifications) => Some(notifications),
                Err(e) => {
                    error!("{}", e);
                    None
                }
            };

            if let Some(notifications) = notifications {
                for mut noti in notifications {
                    let sndr = sndr.clone();
                    tokio::spawn(async move {
                        if let Some(ImageSource::Path(old_path)) = noti.app_image {
                            tracing::debug!("New image: {}", old_path);
                            let path = cache::load_cache(&noti.n_id.to_string()).await;
                            noti.app_image = Some(ImageSource::Path(path));
                        }
                        sndr.send(NotificationServerEvent::NewNotification(Box::new(noti)))
                            .await
                            .unwrap();
                    });
                }
            }
        });
    }

    pub fn close_notification(&self, notification_id: u32) {
        trace!("Closing notification {}", notification_id);
        let db = self.db.clone();
        tokio::spawn(async move {
            match db.delete_notification(notification_id.into()).await {
                Ok(_) => (),
                Err(e) => error!("{}", e),
            };
            cache::delete_file_cache(&notification_id.to_string()).await;
        });
    }

    pub fn close_all_notifications(&self) {
        trace!("Closing all notifications");
        let db = self.db.clone();
        tokio::spawn(async move {
            match db.delete_notifications().await {
                Ok(_) => (),
                Err(e) => error!("{}", e),
            };
            cache::clear_cache().await;
        });
    }
    pub fn close_all_notification_from_app(&self, app_name: String) {
        trace!("Closing all notifications of {}", app_name);
        let db = self.db.clone();
        tokio::spawn(async move {
            let deleted_notifications = match db.delete_notification_with_app_name(&app_name).await
            {
                Ok(notifications) => Some(notifications),
                Err(e) => {
                    error!("{}", e);
                    None
                }
            };
            if let Some(notifications) = deleted_notifications {
                for n in notifications {
                    tokio::spawn(async move {
                        cache::delete_file_cache(&n.n_id.to_string()).await;
                    });
                }
            }
        });
    }
    pub fn invoke_action(&self, notification_id: u32, action: String) {
        trace!("Invoking {} for notification {}", action, notification_id);
        let core = self.core.clone();
        let db = self.db.clone();
        tokio::spawn(async move {
            core.unwrap().invoke_action(notification_id, action);
            match db.delete_notification(notification_id.into()).await {
                Ok(_) => (),
                Err(e) => error!("{}", e),
            };
        });
    }
}

#[cfg(test)]
mod test {
    use std::future;

    use crate::api::NotificationServer;

    #[ignore]
    #[tokio::test]
    async fn notification_server_live_test() -> Result<(), Box<dyn std::error::Error>> {
        let mut _server = NotificationServer::new().await;
        let mut server_recv = _server.run().await.unwrap();

        while let Some(event) = server_recv.recv().await {
            println!("{:?}", event);
        }

        future::pending::<()>().await;
        unreachable!()
    }
}

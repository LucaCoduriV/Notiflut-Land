#![allow(dead_code)]
use std::sync::Arc;

use crate::{
    db::{AppSettings, Database},
    notification_dbus::ImageSource,
    notification_dbus::{notification_server_core::NotificationServerCore, Notification},
};

use nanoid::nanoid;
use tracing::{info, debug, error, trace};

pub enum NotificationCenterCommand {
    Open,
    Close,
    Toggle,
}

pub struct NotificationServer {
    core: Option<Arc<NotificationServerCore>>,
    db: Arc<Database>,
}

impl NotificationServer {
    pub async fn new() -> Self {
        Self {
            core: None,
            db: Arc::new(Database::new().await),
        }
    }

    pub async fn run<F1, F2, F3>(
        &mut self,
        on_notification: F1,
        on_close: F2,
        on_state_change_notification_center: F3,
    ) -> anyhow::Result<()>
    where
        F1: Fn(Notification) + Send + Clone + 'static,
        F2: Fn(u32) + Send + Clone + 'static,
        F3: Fn(NotificationCenterCommand) + Send + Clone + 'static,
    {
        let on_state_change_notification_center_clone1 =
            on_state_change_notification_center.clone();
        let on_state_change_notification_center_clone2 =
            on_state_change_notification_center.clone();

        self.load_db(on_notification.clone());
        let db_clone1 = Arc::clone(&self.db);
        let db_clone2 = Arc::clone(&self.db);
        let db_clone3 = Arc::clone(&self.db);
        let db_clone4 = Arc::clone(&self.db);

        let id = match db_clone4.get_app_settings().await.unwrap_or(None) {
            Some(a) => a.id_count,
            None => 1,
        };

        let core = NotificationServerCore::run(
            id,
            move |n| {
                let n2 = n.clone();
                let db = db_clone1.clone();
                tokio::spawn(async move {
                    match db.put_notification(&n2).await {
                        Ok(_) => (),
                        Err(e) => error!("{}", e),
                    };
                    if let Some(ImageSource::Path(ref path)) = n2.app_image {
                        debug!("New image: {}", path);
                        Self::insert_file_cache(&n2.n_id.to_string(), path).await;
                    }
                });
                on_notification(n);
            },
            move |id| {
                let db = db_clone2.clone();
                tokio::spawn(async move {
                    match db.delete_notification(id.into()).await {
                        Ok(_) => (),
                        Err(e) => error!("{}", e),
                    };
                    Self::delete_file_cache(&id.to_string()).await;
                });
                on_close(id);
            },
            move || {
                on_state_change_notification_center(NotificationCenterCommand::Open);
            },
            move || {
                on_state_change_notification_center_clone1(NotificationCenterCommand::Close);
            },
            move || {
                on_state_change_notification_center_clone2(NotificationCenterCommand::Toggle);
            },
            move |new_id| {
                let db = db_clone3.clone();
                tokio::spawn(async move {
                    let mut app_settings = db
                        .get_app_settings()
                        .await
                        .unwrap_or(Some(AppSettings::default()))
                        .unwrap_or(AppSettings::default());

                    app_settings.id_count = new_id;

                    db.put_appsettings(app_settings).await.unwrap();
                });
            },
        )?;

        self.core = Some(core.into());
        info!("Listening for new notification");
        Ok(())
    }

    fn load_db<F1>(&self, on_notification: F1)
    where
        F1: Fn(Notification) + Send + Clone + 'static,
    {
        let db = self.db.clone();
        tokio::spawn(async move {
            let notifications = match db.get_notifications().await {
                Ok(notifications) => Some(notifications),
                Err(e) => {
                    error!("{}", e);
                    None
                }
            };

            if let Some(notifications) = notifications {
                for mut noti in notifications {
                    let on_notification = on_notification.clone();
                    tokio::spawn(async move {
                        if let Some(ImageSource::Path(old_path)) = noti.app_image {
                            tracing::debug!("New image: {}", old_path);
                            let path = Self::load_cache(&noti.n_id.to_string()).await;
                            noti.app_image = Some(ImageSource::Path(path));
                        }
                        on_notification(noti);
                    });
                }
            }
        });
    }

    async fn load_cache(key: &str) -> String {
        let id = nanoid!();
        let filepath = format!("/tmp/notiflu-{}", id);
        cacache::copy("/tmp/notiflut-cache", key, &filepath)
            .await
            .unwrap();
        filepath
    }

    async fn insert_file_cache(key: &str, file_path: &str) {
        let data = tokio::fs::read(file_path).await.unwrap();
        cacache::write("/tmp/notiflut-cache", key, &data)
            .await
            .unwrap();
    }

    async fn delete_file_cache(key: &str) {
        match cacache::remove("/tmp/notiflut-cache", key).await {
            Ok(_) => debug!("Notification {} deleted from cache", key),
            Err(_) => debug!("Couldn't file notification {}", key),
        };
    }

    pub fn close_notification(&self, notification_id: u32) {
        trace!("Closing notification {}", notification_id);
        let db = self.db.clone();
        tokio::spawn(async move {
            match db.delete_notification(notification_id.into()).await {
                Ok(_) => (),
                Err(e) => error!("{}", e),
            };
            Self::delete_file_cache(&notification_id.to_string()).await;
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
            cacache::clear("/tmp/notiflut-cache").await.unwrap();
        });
    }
    pub fn close_all_notification_from_app(&self, app_name: String) {
        trace!("Closing all notifications of {}", app_name);
        let db = self.db.clone();
        tokio::spawn(async move {
            match db.delete_notification_with_app_name(&app_name).await {
                Ok(_) => (),
                Err(e) => error!("{}", e),
            };
            // TODO delete cache files
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

use serde::{Deserialize, Serialize};
use surrealdb::{
    engine::local::{Db, File},
    sql::Thing,
    Surreal,
};
use tracing::debug;

use crate::notification_dbus::Notification;

static TABLE_NOTIFICATION: &'static str = "notification";
static TABLE_APP_SETTINGS: &'static str = "settings";

#[derive(Debug, Deserialize)]
struct Record {
    #[allow(dead_code)]
    id: Thing,
}

#[derive(Debug, Default, Clone, Deserialize, Serialize)]
pub struct AppSettings {
    pub id_count: u32,
}

#[derive(Clone)]
pub struct Database {
    db: Surreal<Db>,
}

impl Database {
    pub async fn new() -> Database {
        let xdg_dirs = xdg::BaseDirectories::with_prefix("notiflut").unwrap();
        let database_path = xdg_dirs
            .place_data_file("notifications.db")
            .expect("cannot create configuration directory");
        let db = Surreal::new::<File>(database_path).await.unwrap();
        let namespace = if cfg!(debug_assertions) {
            "debug"
        } else {
            "release"
        };
        db.use_ns(namespace).use_db("data").await.unwrap();
        Self { db }
    }
    pub async fn get_notifications(&self) -> anyhow::Result<Vec<Notification>> {
        let notifications: Vec<Notification> = self.db.select(TABLE_NOTIFICATION).await?;
        Ok(notifications)
    }

    pub async fn get_notifications_count(&self) -> anyhow::Result<Option<u64>> {
        let mut result = self
            .db
            .query("SELECT count() from type::table($table) GROUP BY count")
            .bind(("table", TABLE_NOTIFICATION))
            .await?;
        debug!("{:?}", result);
        let count: Option<u64> = result.take((0, "count"))?;
        Ok(count)
    }

    pub async fn put_notification(&self, notification: &Notification) -> anyhow::Result<()> {
        let _result: Option<Notification> = self
            .db
            .delete((TABLE_NOTIFICATION, notification.n_id as i64))
            .await?;
        let _result: Option<Notification> = self
            .db
            .create((TABLE_NOTIFICATION, notification.n_id as i64))
            .content(notification)
            .await?;
        Ok(())
    }

    pub async fn update_notification(&self, notification: &Notification) -> anyhow::Result<()> {
        let _result: Option<Notification> = self
            .db
            .update((TABLE_NOTIFICATION, notification.n_id as i64))
            .content(notification)
            .await?;
        Ok(())
    }

    pub async fn delete_notification(&self, notification_id: i64) -> anyhow::Result<()> {
        let _result: Option<Notification> = self
            .db
            .delete((TABLE_NOTIFICATION, notification_id))
            .await?;
        Ok(())
    }

    pub async fn delete_notifications(&self) -> anyhow::Result<()> {
        let _result: Vec<Notification> = self.db.delete(TABLE_NOTIFICATION).await?;
        Ok(())
    }

    pub async fn delete_notification_with_app_name(
        &self,
        app_name: &str,
    ) -> anyhow::Result<Vec<Notification>> {
        let mut result = self
            .db
            .query("DELETE type::table($table) WHERE app_name = $app_name RETURN BEFORE;")
            .bind(("table", TABLE_NOTIFICATION))
            .bind(("app_name", app_name))
            .await?;
        let deleted_notifications: Result<Vec<Notification>, _> = result.take(0);
        Ok(deleted_notifications?)
    }

    pub async fn get_app_settings(&self) -> anyhow::Result<Option<AppSettings>> {
        let settings: Vec<AppSettings> = self.db.select(TABLE_APP_SETTINGS).await?;
        let settings = settings.into_iter().nth(0);
        Ok(settings)
    }

    pub async fn put_appsettings(&self, settings: AppSettings) -> anyhow::Result<()> {
        const SETTINGS_ID: i64 = 0;
        let db_settings: Option<AppSettings> = self
            .db
            .select((TABLE_APP_SETTINGS, SETTINGS_ID))
            .await?
            .unwrap_or(None);

        let _result: Option<AppSettings> = if db_settings.is_some() {
            self.db
                .update((TABLE_APP_SETTINGS, SETTINGS_ID))
                .content(&settings)
                .await?
        } else {
            self.db
                .create((TABLE_APP_SETTINGS, SETTINGS_ID))
                .content(&settings)
                .await?
        };
        Ok(())
    }
}

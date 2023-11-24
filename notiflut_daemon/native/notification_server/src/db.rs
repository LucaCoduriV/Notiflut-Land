use serde::{Deserialize, Serialize};
use surrealdb::{
    engine::local::{Db, File},
    sql::Thing,
    Surreal,
};

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
        let db = Surreal::new::<File>("/tmp/db.db").await.unwrap();
        let namespace = if cfg!(debug_assertions) {
            "debug"
        } else {
            "release"
        };
        db.use_ns(namespace).use_db("data").await.unwrap();
        Self { db }
    }
    pub async fn get_notifications(&self) -> Vec<Notification> {
        let notifications: Result<Vec<Notification>, _> = self.db.select(TABLE_NOTIFICATION).await;
        let notifications = notifications.unwrap();
        notifications
    }

    pub async fn put_notification(&self, notification: &Notification) {
        let result: Result<Option<Notification>, _> = self
            .db
            .create((TABLE_NOTIFICATION, notification.n_id as i64))
            .content(notification)
            .await;

        let _result_casted: anyhow::Result<_> = result.map(|_| ()).map_err(|e| e.into());
    }

    pub async fn update_notification(&self, notification: &Notification) {
        let result: Result<Option<Notification>, _> = self
            .db
            .update((TABLE_NOTIFICATION, notification.n_id as i64))
            .content(notification)
            .await;
        let _result_casted: anyhow::Result<_> = result.map(|_| ()).map_err(|e| e.into());
    }

    pub async fn delete_notification(&self, notification_id: i64) {
        let result: Result<Option<Notification>, _> =
            self.db.delete((TABLE_NOTIFICATION, notification_id)).await;

        let _result_casted: anyhow::Result<_> = result.map(|_| ()).map_err(|e| e.into());
    }

    pub async fn delete_notifications(&self) {
        let result: Result<Vec<Notification>, _> = self.db.delete(TABLE_NOTIFICATION).await;

        let _result_casted: anyhow::Result<_> = result.map(|_| ()).map_err(|e| e.into());
    }

    pub async fn delete_notification_with_app_name(&self, app_name: &str) {
        let result = self
            .db
            .query("DELETE type::table($table) WHERE name = $app_name;")
            .bind(("table", TABLE_NOTIFICATION))
            .bind(("app_name", app_name))
            .await;

        let _result_casted: anyhow::Result<_> = result.map(|_| ()).map_err(|e| e.into());
    }

    pub async fn get_app_settings(&self) -> Option<AppSettings> {
        let settings: Result<Vec<AppSettings>, _> = self.db.select(TABLE_APP_SETTINGS).await;
        let settings: anyhow::Result<_> =
            settings.map(|v| v.into_iter().nth(0)).map_err(|e| e.into());
        settings.unwrap()
    }

    pub async fn set_appsettings(&self, settings: AppSettings) {
        const SETTINGS_ID: i64 = 0;
        let db_settings: Option<AppSettings> = self
            .db
            .select((TABLE_APP_SETTINGS, SETTINGS_ID))
            .await
            .unwrap();

        let result: Result<Option<AppSettings>, _> = if db_settings.is_some() {
            self.db
                .update((TABLE_APP_SETTINGS, SETTINGS_ID))
                .content(&settings)
                .await
        } else {
            self.db
                .create((TABLE_APP_SETTINGS, SETTINGS_ID))
                .content(&settings)
                .await
        };

        let _result_casted: anyhow::Result<_> = result.map(|_| ()).map_err(|e| e.into());
    }
}

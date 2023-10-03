use std::sync::mpsc::Receiver;
use surrealdb::engine::local::Db;
use surrealdb::engine::local::File;
use surrealdb::Surreal;

use once_cell::sync::OnceCell;

static DB: OnceCell<Surreal<Db>> = OnceCell::new();
static TABLE_NOTIFICATION: &'static str = "notification";
static TABLE_APP_SETTINGS: &'static str = "settings";

use super::*;
use serde::Deserialize;
use surrealdb::sql::Thing;

#[derive(Debug, Deserialize)]
struct Record {
    #[allow(dead_code)]
    id: Thing,
}

#[tokio::main]
pub(crate) async fn db_thread(called_function_rx: Receiver<SurrealdbMessages>) {
    if let None = DB.get() {
        let db = Surreal::new::<File>("/tmp/db.db").await.unwrap();
        let namespace = if cfg!(debug_assertions) {
            "debug"
        } else {
            "release"
        };
        db.use_ns(namespace).use_db("data").await.unwrap();
        DB.set(db).unwrap();
    }

    println!("DB started !");

    while let Ok(msg) = called_function_rx.recv() {
        match msg {
            SurrealdbMessages::GetNotifications(sender) => {
                let notifications: Result<Vec<Notification>, _> =
                    DB.get().unwrap().select(TABLE_NOTIFICATION).await;
                let notifications = notifications.unwrap();

                sender.send(notifications).unwrap();
            }
            SurrealdbMessages::AddNotification(sender, notification) => {
                let result: Result<Option<Notification>, _> = DB
                    .get()
                    .unwrap()
                    .create((TABLE_NOTIFICATION, notification.n_id as i64))
                    .content(notification)
                    .await;

                let result_casted = result.map(|_| ()).map_err(|e| e.into());

                sender.send(result_casted).unwrap();
            }
            SurrealdbMessages::DeleteNotification(sender, id) => {
                let result: Result<Option<Notification>, _> = DB
                    .get()
                    .unwrap()
                    .delete((TABLE_NOTIFICATION, id as i64))
                    .await;

                let result_casted = result.map(|_| ()).map_err(|e| e.into());

                sender.send(result_casted).unwrap();
            }
            SurrealdbMessages::DeleteNotificationAppName(sender, app_name) => {
                let result = DB
                    .get()
                    .unwrap()
                    .query("DELETE type::table($table) WHERE name = $app_name;")
                    .bind(("table", TABLE_NOTIFICATION))
                    .bind(("app_name", app_name))
                    .await;

                let result_casted = result.map(|_| ()).map_err(|e| e.into());
                sender.send(result_casted).unwrap();
            }
            SurrealdbMessages::DeleteNotifications(sender) => {
                let result: Result<Vec<Notification>, _> =
                    DB.get().unwrap().delete(TABLE_NOTIFICATION).await;

                let result_casted = result.map(|_| ()).map_err(|e| e.into());
                sender.send(result_casted).unwrap();
            }
            SurrealdbMessages::UpdatetNotification(sender, notification) => {
                let result: Result<Option<Notification>, _> = DB
                    .get()
                    .unwrap()
                    .update((TABLE_NOTIFICATION, notification.n_id as i64))
                    .content(notification)
                    .await;
                let result_casted = result.map(|_| ()).map_err(|e| e.into());
                sender.send(result_casted).unwrap();
            }
            SurrealdbMessages::GetAppSettings(sender) => {
                let settings: Result<Vec<AppSettings>, _> =
                    DB.get().unwrap().select(TABLE_APP_SETTINGS).await;
                let settings = settings.map(|v| v.into_iter().nth(0)).map_err(|e| e.into());

                sender.send(settings).unwrap();
            }
            SurrealdbMessages::SetAppSettings(sender, settings) => {
                const SETTINGS_ID: i64 = 0;
                let db_settings: Option<AppSettings> = DB
                    .get()
                    .unwrap()
                    .select((TABLE_APP_SETTINGS, SETTINGS_ID))
                    .await
                    .unwrap();

                let result: Result<Option<AppSettings>, _> = if db_settings.is_some() {
                    DB.get()
                        .unwrap()
                        .update((TABLE_APP_SETTINGS, SETTINGS_ID))
                        .content(&settings)
                        .await
                } else {
                    DB.get()
                        .unwrap()
                        .create((TABLE_APP_SETTINGS, SETTINGS_ID))
                        .content(&settings)
                        .await
                };

                let result_casted = result.map(|_| ()).map_err(|e| e.into());

                sender.send(result_casted).unwrap();
            }
        }
    }
    println!("DB ended !");
}

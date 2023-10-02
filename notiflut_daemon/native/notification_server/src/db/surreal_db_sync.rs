use std::sync::mpsc::Receiver;
use surrealdb::engine::local::Db;
use surrealdb::engine::local::Mem;
use surrealdb::Surreal;

use once_cell::sync::OnceCell;

static DB: OnceCell<Surreal<Db>> = OnceCell::new();
static TABLE_NOTIFICATION: &'static str = "notification";

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
    DB.set(Surreal::new::<Mem>(()).await.unwrap()).unwrap();

    while let Ok(msg) = called_function_rx.recv() {
        match msg {
            SurrealdbMessages::GetNotifications(sender) => {
                let notifications: Result<Vec<Notification>, _> =
                    DB.get().unwrap().select(TABLE_NOTIFICATION).await;
                let notifications = notifications.unwrap();

                sender.send(notifications).unwrap();
            }
            SurrealdbMessages::AddNotification(notification) => {
                let _created: Option<Notification> = DB
                    .get()
                    .unwrap()
                    .create((TABLE_NOTIFICATION, notification.n_id as i64))
                    .content(notification)
                    .await
                    .unwrap();
            }
            SurrealdbMessages::DeleteNotification(id) => {
                let _result: Option<Notification> = DB
                    .get()
                    .unwrap()
                    .delete((TABLE_NOTIFICATION, id as i64))
                    .await
                    .unwrap();
            }
            SurrealdbMessages::DeleteNotificationAppName(app_name) => {
                let _result = DB
                    .get()
                    .unwrap()
                    .query("DELETE type::table($table) WHERE name = $app_name;")
                    .bind(("table", TABLE_NOTIFICATION))
                    .bind(("app_name", app_name))
                    .await
                    .unwrap();
            }
            SurrealdbMessages::DeleteNotifications => {
                let _result: Vec<Notification> =
                    DB.get().unwrap().delete(TABLE_NOTIFICATION).await.unwrap();
            }
            SurrealdbMessages::UpdatetNotification(notification) => {
                let _result: Option<Notification> = DB
                    .get()
                    .unwrap()
                    .update((TABLE_NOTIFICATION, notification.n_id as i64))
                    .content(notification)
                    .await
                    .unwrap();
            }
        }
    }
}

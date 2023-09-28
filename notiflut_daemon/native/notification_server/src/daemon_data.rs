use crate::notification::Notification;
use surrealdb::engine::local::Db;
use tokio::runtime::Runtime;

static TABLE_NOTIFICATION: &'static str = "notification";

pub struct DaemonData {
    pub is_open: bool,
    db: surrealdb::Surreal<Db>,
}

impl DaemonData {
    pub fn new(db: surrealdb::Surreal<Db>) -> Self {
        DaemonData { is_open: false, db }
    }

    pub fn get_notifications_db(&self) -> anyhow::Result<Vec<Notification>> {
        let notifications: anyhow::Result<Vec<Notification>> =
            Runtime::new().unwrap().block_on(async {
                let notifications: Result<Vec<Notification>, _> =
                    self.db.select(TABLE_NOTIFICATION).await;
                println!("{:?}", notifications);
                let notifications = notifications?;
                Ok(notifications)
            });

        println!("{:?}", notifications);

        notifications
    }

    pub fn add_notification(&self, notification: Notification) -> anyhow::Result<()> {
        let result: anyhow::Result<()> = Runtime::new().unwrap().block_on(async {
            let _created: Option<()> = self
                .db
                .create((TABLE_NOTIFICATION, notification.id as i64))
                .content(notification)
                .await?;
            Ok(())
        });
        result
    }

    pub fn delete_notification(&self, id: u32) -> anyhow::Result<()> {
        let result: anyhow::Result<()> = Runtime::new().unwrap().block_on(async {
            let _result: Option<()> = self.db.delete((TABLE_NOTIFICATION, id as i64)).await?;
            Ok(())
        });

        result
    }

    pub fn delete_notifications_with_app_name(&self, app_name: &str) -> anyhow::Result<()> {
        let result: anyhow::Result<()> = Runtime::new().unwrap().block_on(async {
            let _result = self
                .db
                .query("DELETE type::table($table) WHERE name = $app_name;")
                .bind(("table", app_name))
                .bind(("app_name", app_name))
                .await?;
            Ok(())
        });

        result
    }

    pub fn delete_notifications(&self) -> anyhow::Result<()> {
        let result: anyhow::Result<()> = Runtime::new().unwrap().block_on(async {
            let _result: Vec<()> = self.db.delete(TABLE_NOTIFICATION).await?;
            Ok(())
        });

        result
    }

    pub fn update_notification(&self, notification: Notification) -> anyhow::Result<()> {
        let result: anyhow::Result<()> = Runtime::new().unwrap().block_on(async {
            let _result: Option<()> = self
                .db
                .update((TABLE_NOTIFICATION, notification.id as i64))
                .await?;
            Ok(())
        });

        result
    }
}

#[cfg(test)]
mod test {
    use surrealdb::{engine::local::File, Surreal};

    use super::*;

    #[tokio::test]
    async fn write_db() {
        let db = Surreal::new::<File>("/tmp/database.db").await.unwrap();
        db.use_ns("app").use_db("data").await.unwrap();

        let notification = Notification {
            id: 1,
            app_name: "test_app".to_string(),
            replaces_id: 0,
            summary: "summary".to_string(),
            body: "body".to_string(),
            actions: vec![],
            timeout: 100,
            created_at: chrono::Utc::now(),
            hints: crate::Hints {
                actions_icon: None,
                category: None,
                desktop_entry: None,
                resident: None,
                sound_file: None,
                sound_name: None,
                suppress_sound: None,
                transient: None,
                x: None,
                y: None,
                urgency: None,
            },
            app_icon: None,
            app_image: None,
        };

        let data = DaemonData::new(db);

        let result = std::thread::spawn(move || {
            let result = data.add_notification(notification);
            println!("{:?}", result);
            result
        });

        let result = result.join();

        result.unwrap();
    }
}

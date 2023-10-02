use crate::notification::Notification;
use surrealdb::engine::local::Db;
use tokio::runtime::Runtime;

static TABLE_NOTIFICATION: &'static str = "notification";

pub struct DaemonData<'a> {
    pub is_open: bool,
    db: &'a surrealdb::Surreal<Db>,
}

impl<'a> DaemonData<'a> {
    pub fn new(db: &'a surrealdb::Surreal<Db>) -> Self {
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
        println!("COUCOU2");
        let result: anyhow::Result<()> = Runtime::new().unwrap().block_on(async {
            println!("COUCOU3");
            let _created: Option<Notification> = self
                .db
                .create((TABLE_NOTIFICATION, notification.n_id as i64))
                .content(notification)
                .await?;
            println!("COUCOU4");
            Ok(())
        });
        println!("COUCOU5");
        result
    }

    pub fn delete_notification(&self, id: u32) -> anyhow::Result<()> {
        let result: anyhow::Result<()> = Runtime::new().unwrap().block_on(async {
            let _result: Option<Notification> =
                self.db.delete((TABLE_NOTIFICATION, id as i64)).await?;
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
            let _result: Vec<Notification> = self.db.delete(TABLE_NOTIFICATION).await?;
            Ok(())
        });

        result
    }

    pub fn update_notification(&self, notification: Notification) -> anyhow::Result<()> {
        let result: anyhow::Result<()> = Runtime::new().unwrap().block_on(async {
            let _result: Option<Notification> = self
                .db
                .update((TABLE_NOTIFICATION, notification.n_id as i64))
                .await?;
            Ok(())
        });

        result
    }
}

#[cfg(test)]
mod test {
    use serde::Deserialize;
    use surrealdb::{engine::local::Mem, sql::Thing, Surreal};

    #[derive(Debug, Deserialize)]
    struct Record {
        #[allow(dead_code)]
        id: Thing,
    }

    use super::*;

    #[tokio::test]
    async fn write_db() {
        let notification = Notification {
            n_id: 10,
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

        let result = std::thread::spawn(move || {
            Runtime::new().unwrap().block_on(async {
                let db = Surreal::new::<Mem>(()).await.unwrap();
                db.use_ns("app").use_db("data").await.unwrap();
                db
            })
        });

        let db = result.join().unwrap();

        let result = std::thread::spawn(move || {
            let data = DaemonData::new(&db);
            data.add_notification(notification).unwrap();
            data.get_notifications_db()
        });

        let result = result.join();

        println!("{:?}", result);

        // result.unwrap();
    }
}

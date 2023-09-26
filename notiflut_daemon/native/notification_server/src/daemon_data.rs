use crate::db::DB;
use crate::notification::Notification;
use tokio::runtime::Runtime;

static TABLE_NOTIFICATION: &'static str = "notification";

pub struct DaemonData {
    pub notifications: Vec<Notification>,
    pub is_open: bool,
}

impl DaemonData {
    pub fn new() -> Self {
        DaemonData {
            notifications: Vec::new(),
            is_open: false,
        }
    }

    pub fn get_notifications_db() -> anyhow::Result<Vec<Notification>> {
        let notifications: anyhow::Result<Vec<Notification>> =
            Runtime::new().unwrap().block_on(async {
                let notifications: Vec<Notification> = DB.select(TABLE_NOTIFICATION).await?;
                Ok(notifications)
            });

        notifications
    }

    pub fn get_notifications(&mut self) -> &mut Vec<Notification> {
        &mut self.notifications
    }

    pub fn add_notification(notification: Notification) -> anyhow::Result<()> {
        let result: anyhow::Result<()> = Runtime::new().unwrap().block_on(async {
            let _created: Option<()> = DB
                .create((TABLE_NOTIFICATION, notification.id as i64))
                .content(notification)
                .await?;
            Ok(())
        });
        result
    }

    pub fn delete_notification(id: u32) -> anyhow::Result<()> {
        let result: anyhow::Result<()> = Runtime::new().unwrap().block_on(async {
            let _result: Option<()> = DB.delete((TABLE_NOTIFICATION, id as i64)).await?;
            Ok(())
        });

        result
    }

    pub fn delete_notifications_with_app_name(app_name: &str) -> anyhow::Result<()> {
        let result: anyhow::Result<()> = Runtime::new().unwrap().block_on(async {
            let _result = DB
                .query("DELETE type::table($table) WHERE name = $app_name;")
                .bind(("table", app_name))
                .bind(("app_name", app_name))
                .await?;
            Ok(())
        });

        result
    }

    pub fn delete_notifications() -> anyhow::Result<()> {
        let result: anyhow::Result<()> = Runtime::new().unwrap().block_on(async {
            let _result: Vec<()> = DB.delete(TABLE_NOTIFICATION).await?;
            Ok(())
        });

        result
    }

    pub fn update_notification(notification: Notification) -> anyhow::Result<()> {
        let result: anyhow::Result<()> = Runtime::new().unwrap().block_on(async {
            let _result: Option<()> = DB
                .update((TABLE_NOTIFICATION, notification.id as i64))
                .await?;
            Ok(())
        });

        result
    }
}

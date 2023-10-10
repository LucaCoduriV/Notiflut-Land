use crate::{db::SurrealDbSync, notification::Notification};

static TABLE_NOTIFICATION: &'static str = "notification";

pub struct DaemonData {
    pub is_open: bool,
    db: SurrealDbSync,
}

impl DaemonData {
    pub fn new(db: SurrealDbSync) -> Self {
        DaemonData { is_open: false, db }
    }

    pub fn get_notifications_db(&self) -> Vec<Notification> {
        let notifications = self.db.get_notifications();
        notifications
    }

    pub fn add_notification(&self, notification: Notification) {
        self.db.add_notification(notification);
    }

    pub fn delete_notification(&self, id: u32) {
        self.db.delete_notification(id as i64);
    }

    pub fn delete_notifications_with_app_name(&self, app_name: &str) {
        self.db.delete_notification_with_app_name(app_name);
    }

    pub fn delete_notifications(&self) {
        self.db.delete_notifications();
    }

    pub fn update_notification(&self, notification: Notification) {
        self.db.update_notification(notification);
    }
}

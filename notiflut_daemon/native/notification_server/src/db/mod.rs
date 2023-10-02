mod surreal_db_sync;

use std::sync::mpsc::Sender;

use surreal_db_sync::*;

use crate::Notification;

pub(crate) enum SurrealdbMessages {
    GetNotifications(Sender<Vec<Notification>>),
    AddNotification(Notification),
    UpdatetNotification(Notification),
    DeleteNotification(i64),
    DeleteNotifications,
    DeleteNotificationAppName(String),
}

#[derive(Default, Clone)]
struct SurrealDbSync {
    sender: Option<Sender<SurrealdbMessages>>,
}

impl SurrealDbSync {
    pub fn new() -> SurrealDbSync {
        let (sen, rec) = std::sync::mpsc::channel::<SurrealdbMessages>();

        let _thread_handle = std::thread::spawn(move || db_thread(rec));

        Self { sender: Some(sen) }
    }
    pub fn get_notifications(&self) {
        let (sen, rec) = std::sync::mpsc::channel();
        self.sender
            .as_ref()
            .unwrap()
            .send(SurrealdbMessages::GetNotifications(sen))
            .unwrap();

        while let Ok(resp) = rec.recv() {}
    }

    pub fn add_notification(&self, notification: Notification) {
        self.sender
            .as_ref()
            .unwrap()
            .send(SurrealdbMessages::AddNotification(notification))
            .unwrap();
    }

    pub fn delete_notification(&self, notification_id: i64) {
        self.sender
            .as_ref()
            .unwrap()
            .send(SurrealdbMessages::DeleteNotification(notification_id))
            .unwrap();
    }

    pub fn delete_notifications(&self) {
        self.sender
            .as_ref()
            .unwrap()
            .send(SurrealdbMessages::DeleteNotifications)
            .unwrap();
    }

    pub fn delete_notification_with_app_name(&self, app_name: &str) {
        self.sender
            .as_ref()
            .unwrap()
            .send(SurrealdbMessages::DeleteNotificationAppName(
                app_name.to_string(),
            ))
            .unwrap();
    }
}

#[cfg(test)]
mod test {
    use crate::db::SurrealDbSync;

    #[test]
    fn db_test() {
        let db = SurrealDbSync::new();
        db.get_notifications();
    }
}

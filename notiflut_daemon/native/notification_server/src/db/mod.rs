mod surreal_db_sync;

use std::sync::mpsc::Sender;

use surreal_db_sync::*;

use crate::Notification;

pub(crate) enum SurrealdbMessages {
    GetNotifications(Sender<Vec<Notification>>),
    AddNotification(Sender<()>, Notification),
    UpdatetNotification(Sender<()>, Notification),
    DeleteNotification(Sender<()>, i64),
    DeleteNotifications(Sender<()>),
    DeleteNotificationAppName(Sender<()>, String),
}

#[derive(Default, Clone)]
pub struct SurrealDbSync {
    sender: Option<Sender<SurrealdbMessages>>,
}

impl SurrealDbSync {
    pub fn new() -> SurrealDbSync {
        let (sen, rec) = std::sync::mpsc::channel::<SurrealdbMessages>();

        let _thread_handle = std::thread::spawn(move || db_thread(rec));

        Self { sender: Some(sen) }
    }
    pub fn get_notifications(&self) -> Vec<Notification> {
        let (sen, rec) = std::sync::mpsc::channel();
        self.sender
            .as_ref()
            .unwrap()
            .send(SurrealdbMessages::GetNotifications(sen))
            .unwrap();

        rec.iter().next().unwrap()
    }

    pub fn add_notification(&self, notification: Notification) {
        let (sen, rec) = std::sync::mpsc::channel();
        self.sender
            .as_ref()
            .unwrap()
            .send(SurrealdbMessages::AddNotification(sen, notification))
            .unwrap();
        rec.iter().next().unwrap()
    }

    pub fn update_notification(&self, notification: Notification) {
        let (sen, rec) = std::sync::mpsc::channel();
        self.sender
            .as_ref()
            .unwrap()
            .send(SurrealdbMessages::UpdatetNotification(sen, notification))
            .unwrap();
        rec.iter().next().unwrap()
    }

    pub fn delete_notification(&self, notification_id: i64) {
        let (sen, rec) = std::sync::mpsc::channel();
        self.sender
            .as_ref()
            .unwrap()
            .send(SurrealdbMessages::DeleteNotification(sen, notification_id))
            .unwrap();
        rec.iter().next().unwrap()
    }

    pub fn delete_notifications(&self) {
        let (sen, rec) = std::sync::mpsc::channel();
        self.sender
            .as_ref()
            .unwrap()
            .send(SurrealdbMessages::DeleteNotifications(sen))
            .unwrap();
        rec.iter().next().unwrap()
    }

    pub fn delete_notification_with_app_name(&self, app_name: &str) {
        let (sen, rec) = std::sync::mpsc::channel();
        self.sender
            .as_ref()
            .unwrap()
            .send(SurrealdbMessages::DeleteNotificationAppName(
                sen,
                app_name.to_string(),
            ))
            .unwrap();
        rec.iter().next().unwrap()
    }
}

#[cfg(test)]
mod test {
    use crate::{db::SurrealDbSync, Notification};

    #[test]
    fn db_test() {
        let db = SurrealDbSync::new();
        db.add_notification(Notification {
            app_name: "lol".to_string(),
            ..Default::default()
        });
        let notifications = db.get_notifications();

        dbg!(notifications);
    }
}

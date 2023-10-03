mod surreal_db_sync;

use std::sync::mpsc::Sender;

use anyhow::Result;
use serde::{Deserialize, Serialize};
use surreal_db_sync::*;

use crate::Notification;

pub(crate) enum SurrealdbMessages {
    GetNotifications(Sender<Vec<Notification>>),
    AddNotification(Sender<Result<()>>, Notification),
    UpdatetNotification(Sender<Result<()>>, Notification),
    DeleteNotification(Sender<Result<()>>, i64),
    DeleteNotifications(Sender<Result<()>>),
    DeleteNotificationAppName(Sender<Result<()>>, String),
    GetAppSettings(Sender<Result<Option<AppSettings>>>),
    SetAppSettings(Sender<Result<()>>, AppSettings),
}

#[derive(Default, Clone)]
pub struct SurrealDbSync {
    sender: Option<Sender<SurrealdbMessages>>,
}

#[derive(Debug, Default, Clone, Deserialize, Serialize)]
pub struct AppSettings {
    pub id_count: u32,
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
        rec.iter().next().unwrap().unwrap()
    }

    pub fn update_notification(&self, notification: Notification) {
        let (sen, rec) = std::sync::mpsc::channel();
        self.sender
            .as_ref()
            .unwrap()
            .send(SurrealdbMessages::UpdatetNotification(sen, notification))
            .unwrap();
        rec.iter().next().unwrap().unwrap()
    }

    pub fn delete_notification(&self, notification_id: i64) {
        let (sen, rec) = std::sync::mpsc::channel();
        self.sender
            .as_ref()
            .unwrap()
            .send(SurrealdbMessages::DeleteNotification(sen, notification_id))
            .unwrap();
        rec.iter().next().unwrap().unwrap()
    }

    pub fn delete_notifications(&self) {
        let (sen, rec) = std::sync::mpsc::channel();
        self.sender
            .as_ref()
            .unwrap()
            .send(SurrealdbMessages::DeleteNotifications(sen))
            .unwrap();
        rec.iter().next().unwrap().unwrap()
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
        rec.iter().next().unwrap().unwrap()
    }

    pub fn get_app_settings(&self) -> Option<AppSettings> {
        let (sen, rec) = std::sync::mpsc::channel();
        self.sender
            .as_ref()
            .unwrap()
            .send(SurrealdbMessages::GetAppSettings(sen))
            .unwrap();

        rec.iter().next().unwrap().unwrap()
    }

    pub fn set_notification(&self, settings: AppSettings) {
        let (sen, rec) = std::sync::mpsc::channel();
        self.sender
            .as_ref()
            .unwrap()
            .send(SurrealdbMessages::SetAppSettings(sen, settings))
            .unwrap();
        rec.iter().next().unwrap().unwrap()
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

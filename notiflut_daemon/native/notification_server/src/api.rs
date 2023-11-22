use std::{
    cell::RefCell,
    sync::{Arc, Mutex},
};

use crate::{
    db::Database,
    notification_dbus::{notification_server::NotificationServerCore, Notification},
};

pub enum NotificationCenterCommand {
    Open,
    Close,
    Toggle,
}

pub struct NotificationServer {
    is_notification_center_open: Arc<Mutex<bool>>,
    core: Arc<NotificationServerCore>,
}

impl NotificationServer {
    pub fn run<F1, F2, F3>(
        on_notification: F1,
        on_close: F2,
        on_state_change_notification_center: F3,
    ) -> anyhow::Result<Self>
    where
        F1: Fn(Notification) + Send + Clone + 'static,
        F2: Fn(u32) + Send + Clone + 'static,
        F3: Fn(NotificationCenterCommand) + Send + Clone + 'static,
    {
        let on_state_change_notification_center_clone1 =
            on_state_change_notification_center.clone();
        let on_state_change_notification_center_clone2 =
            on_state_change_notification_center.clone();
        let core = NotificationServerCore::run(
            0,
            move |n| {
                on_notification(n);
            },
            move |id| {
                on_close(id);
            },
            move || {
                on_state_change_notification_center(NotificationCenterCommand::Open);
            },
            move || {
                on_state_change_notification_center_clone1(NotificationCenterCommand::Close);
            },
            move || {
                on_state_change_notification_center_clone2(NotificationCenterCommand::Toggle);
            },
        )?;

        let _ = Database::new();

        Ok(NotificationServer {
            is_notification_center_open: Arc::new(false.into()),
            core: core.into(),
        })
    }

    pub fn close_notification(notification_id: u32) {
        tokio::spawn(async move {
            Database::delete_notification(notification_id.into()).await;
        });
    }
    pub fn close_all_notifications() {
        tokio::spawn(async move {
            Database::delete_notifications().await;
        });
    }
    pub fn close_all_notification_from_app(app_name: String) {
        tokio::spawn(async move {
            Database::delete_notification_with_app_name(&app_name).await;
        });
    }
    pub fn invoke_action(&self, notification_id: u32, action: String) {
        let core = self.core.clone();
        tokio::spawn(async move {
            core.invoke_action(notification_id, action);
            Database::delete_notification(notification_id.into()).await;
        });
    }
    pub fn close_notification_center(&self) {
        *self.is_notification_center_open.lock().unwrap() = false;
    }

    pub fn toggle_notification_center(&self) {
        let mut lock = self.is_notification_center_open.lock().unwrap();
        *lock = !*lock;
    }

    pub fn open_notification_center(&self) {
        *self.is_notification_center_open.lock().unwrap() = true;
    }
}

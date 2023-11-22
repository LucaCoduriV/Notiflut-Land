use std::{
    cell::RefCell,
    sync::{Arc, Mutex},
};

use crate::{
    db::Database,
    notification_dbus::{notification_server::NotificationServerCore, Notification},
};

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
        F3: Fn(bool) + Send + Clone + 'static,
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
                on_state_change_notification_center(true);
            },
            move || {
                on_state_change_notification_center_clone1(false);
            },
            move || {
                on_state_change_notification_center_clone2(true);
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
}

use std::sync::Arc;

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
                let n2 = n.clone();
                tokio::spawn(async move {
                    Database::put_notification(&n2).await;
                });
                on_notification(n);
            },
            move |id| {
                tokio::spawn(async move {
                    Database::delete_notification(id.into()).await;
                });
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

        tokio::spawn(async {
            let _ = Database::new().await;
        });

        Ok(NotificationServer { core: core.into() })
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
}

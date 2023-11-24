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
    core: Option<Arc<NotificationServerCore>>,
    db: Arc<Database>,
}

impl NotificationServer {
    pub async fn new() -> Self {
        Self {
            core: None,
            db: Arc::new(Database::new().await),
        }
    }

    pub fn run<F1, F2, F3>(
        &mut self,
        on_notification: F1,
        on_close: F2,
        on_state_change_notification_center: F3,
    ) -> anyhow::Result<()>
    where
        F1: Fn(Notification) + Send + Clone + 'static,
        F2: Fn(u32) + Send + Clone + 'static,
        F3: Fn(NotificationCenterCommand) + Send + Clone + 'static,
    {
        let on_state_change_notification_center_clone1 =
            on_state_change_notification_center.clone();
        let on_state_change_notification_center_clone2 =
            on_state_change_notification_center.clone();
        let db_clone1 = Arc::clone(&self.db);
        let db_clone2 = Arc::clone(&self.db);
        let core = NotificationServerCore::run(
            0,
            move |n| {
                let n2 = n.clone();
                let db = db_clone1.clone();
                tokio::spawn(async move {
                    db.put_notification(&n2).await;
                });
                on_notification(n);
            },
            move |id| {
                let db = db_clone2.clone();
                tokio::spawn(async move {
                    db.delete_notification(id.into()).await;
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

        self.core = Some(core.into());
        Ok(())
    }

    pub fn close_notification(&self, notification_id: u32) {
        let db = self.db.clone();
        tokio::spawn(async move {
            db.delete_notification(notification_id.into()).await;
        });
    }
    pub fn close_all_notifications(&self) {
        let db = self.db.clone();
        tokio::spawn(async move {
            db.delete_notifications().await;
        });
    }
    pub fn close_all_notification_from_app(&self, app_name: String) {
        let db = self.db.clone();
        tokio::spawn(async move {
            db.delete_notification_with_app_name(&app_name).await;
        });
    }
    pub fn invoke_action(&self, notification_id: u32, action: String) {
        let core = self.core.clone();
        let db = self.db.clone();
        tokio::spawn(async move {
            core.unwrap().invoke_action(notification_id, action);
            db.delete_notification(notification_id.into()).await;
        });
    }
}

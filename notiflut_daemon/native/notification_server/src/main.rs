mod api;
mod db;
mod desktop_file_manager;
mod notification_dbus;

use futures::future;

use crate::{api::NotificationServer, notification_dbus::Notification};

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let (send, recv) = std::sync::mpsc::channel::<Notification>();
    let mut _server = NotificationServer::new().await;
    _server
        .run(
            move |n| {
                send.send(n).unwrap();
            },
            |id| println!("{}", id),
            |state| println!("STATE: {}", true),
        )
        .unwrap();

    for notification in recv {
        println!("{:?}", notification);
    }

    future::pending::<()>().await;
    unreachable!()
}

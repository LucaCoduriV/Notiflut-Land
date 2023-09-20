use bridge::api::RustSignal;
use bridge::{respond_to_dart, send_rust_signal};
use prost::Message;
use with_request::handle_request;

mod bridge;
mod messages;
mod utils;
mod with_request;

/// This `hub` crate is the entry point for the Rust logic.
/// Always use non-blocking async functions such as `tokio::fs::File::open`.
async fn main() {
    let mut request_receiver = bridge::get_request_receiver();
    let (sender, receiver) = std::sync::mpsc::channel();
    notification_server::setup();
    notification_server::start_daemon(sender).unwrap();

    let _app_event_stream = std::thread::spawn(move || {
        use messages::daemon_event::*;
        for event in receiver {
            let rust_signal = match event {
                notification_server::DaemonEvent::Update(notification, id) => {
                    let signal_message = SignalAppEvent {
                        r#type: signal_app_event::AppEventType::Update.into(),
                        notifications: notification.into_iter().map(|n| n.into()).collect(),
                        last_notification_id: id.map(|v| v as u64),
                    };

                    RustSignal {
                        resource: ID,
                        message: Some(signal_message.encode_to_vec()),
                        blob: None,
                    }
                }
                notification_server::DaemonEvent::ShowNotificationCenter => {
                    let signal_message = SignalAppEvent {
                        r#type: signal_app_event::AppEventType::ShowNotificationCenter.into(),
                        ..Default::default()
                    };
                    RustSignal {
                        resource: ID,
                        message: Some(signal_message.encode_to_vec()),
                        blob: None,
                    }
                }
                notification_server::DaemonEvent::HideNotificationCenter => {
                    let signal_message = SignalAppEvent {
                        r#type: signal_app_event::AppEventType::HideNotificationCenter.into(),
                        ..Default::default()
                    };
                    RustSignal {
                        resource: ID,
                        message: Some(signal_message.encode_to_vec()),
                        blob: None,
                    }
                }
            };

            send_rust_signal(rust_signal);
        }
    });

    // This is `tokio::sync::mpsc::Reciver` that receives the requests from Dart.
    while let Some(request_unique) = request_receiver.recv().await {
        // tokio::spawn(async {
        let response_unique = handle_request(request_unique).await;
        respond_to_dart(response_unique);
        // });
    }
}

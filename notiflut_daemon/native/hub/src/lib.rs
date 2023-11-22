use std::sync::Arc;

use bridge::RustSignal;
use bridge::{respond_to_dart, send_rust_signal};
use messages::app_event::ID;
use messages::daemon_event::{signal_app_event, SignalAppEvent};
use notification_server::NotificationCenterCommand;
use prost::Message;
use tokio_with_wasm::tokio;
use with_request::handle_request;

mod bridge;
mod messages;
mod utils;
mod with_request;

/// This `hub` crate is the entry point for the Rust logic.
/// Always use non-blocking async functions such as `tokio::fs::File::open`.
async fn main() {
    let mut request_receiver = bridge::get_request_receiver();
    let server = Arc::new(
        notification_server::NotificationServer::run(
            on_notification,
            on_notification_close,
            on_notification_center_state_change,
        )
        .unwrap(),
    );

    // This is `tokio::sync::mpsc::Reciver` that receives the requests from Dart.
    while let Some(request_unique) = request_receiver.recv().await {
        let clone = server.clone();
        tokio::spawn(async move {
            let response_unique = handle_request(request_unique, &clone);
            respond_to_dart(response_unique);
        });
    }
}
fn on_notification(n: notification_server::Notification) {
    let signal_message = SignalAppEvent {
        r#type: signal_app_event::AppEventType::NewNotification.into(),
        notification: Some(n.into()),
        notification_id: None,
    };

    let rust_signal = RustSignal {
        resource: ID,
        message: Some(signal_message.encode_to_vec()),
        blob: None,
    };
    send_rust_signal(rust_signal);
}

fn on_notification_close(n_id: u32) {
    let signal_message = SignalAppEvent {
        r#type: signal_app_event::AppEventType::CloseNotification.into(),
        notification: None,
        notification_id: Some(n_id.into()),
    };

    let rust_signal = RustSignal {
        resource: ID,
        message: Some(signal_message.encode_to_vec()),
        blob: None,
    };
    send_rust_signal(rust_signal);
}

fn on_notification_center_state_change(state: NotificationCenterCommand) {
    let event_type = match state {
        NotificationCenterCommand::Open => signal_app_event::AppEventType::ShowNotificationCenter,
        NotificationCenterCommand::Close => signal_app_event::AppEventType::HideNotificationCenter,
        NotificationCenterCommand::Toggle => {
            signal_app_event::AppEventType::ToggleNotificationCenter
        }
    };
    let signal_message = SignalAppEvent {
        r#type: event_type.into(),
        ..Default::default()
    };
    let rust_signal = RustSignal {
        resource: ID,
        message: Some(signal_message.encode_to_vec()),
        blob: None,
    };
    send_rust_signal(rust_signal);
}

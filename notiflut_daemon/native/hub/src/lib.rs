use std::sync::Arc;

use bridge::RustSignal;
use bridge::{respond_to_dart, send_rust_signal};
use messages::app_event::ID;
use messages::daemon_event::{signal_app_event, SignalAppEvent};
use notification_server::NotificationCenterCommand;
use prost::Message;
use tokio_with_wasm::tokio;
use tracing::Level;
use tracing_subscriber::EnvFilter;
use tracing_subscriber::FmtSubscriber;
use with_request::handle_request;

mod bridge;
mod messages;
mod utils;
mod with_request;

/// This `hub` crate is the entry point for the Rust logic.
/// Always use non-blocking async functions such as `tokio::fs::File::open`.
async fn main() {
    let subscriber = FmtSubscriber::builder()
        .with_max_level(Level::TRACE)
        .with_level(true)
        .with_file(true)
        .with_line_number(true)
        .with_env_filter(EnvFilter::new("hub=trace,notification_server=trace"))
        .pretty()
        .finish();

    tracing::subscriber::set_global_default(subscriber).expect("setting default subscriber failed");

    let mut request_receiver = bridge::get_request_receiver();
    let mut server = notification_server::NotificationServer::new().await;
    server
        .run(
            on_notification,
            on_notification_close,
            on_notification_center_state_change,
            on_style_change,
        )
        .await
        .unwrap();
    let server = Arc::new(server);

    // This is `tokio::sync::mpsc::Reciver` that receives the requests from Dart.
    while let Some(request_unique) = request_receiver.recv().await {
        let clone = server.clone();
        tokio::spawn(async move {
            let response_unique = handle_request(request_unique, &clone);
            respond_to_dart(response_unique);
        });
    }
}
fn on_notification(n: &notification_server::Notification) {
    let signal_message = SignalAppEvent {
        r#type: signal_app_event::AppEventType::NewNotification.into(),
        notification: Some(n.into()),
        notification_id: None,
        style: None,
    };

    let rust_signal = RustSignal {
        resource: ID,
        message: Some(signal_message.encode_to_vec()),
        blob: None,
    };
    send_rust_signal(rust_signal);
}

fn on_style_change(s: &notification_server::Style) {
    let signal_message = SignalAppEvent {
        r#type: signal_app_event::AppEventType::StyleUpdated.into(),
        notification: None,
        notification_id: None,
        style: Some(s.into()),
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
        style: None,
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

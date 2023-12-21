use std::sync::Arc;

use bridge::RustSignal;
use bridge::{respond_to_dart, send_rust_signal};
use messages::daemon_event::ID as DAEMON_EVENT_ID;
use messages::daemon_event::{signal_app_event, SignalAppEvent};
use messages::settings_event::settings_signal::Operation;
use messages::settings_event::SettingsSignal;
use messages::settings_event::ThemeVariante;
use messages::settings_event::ID as SETTINGS_EVENT_ID;
use messages::theme_event::Style;
use messages::theme_event::ID as THEME_EVENT_ID;
use notification_server::{NotificationCenterCommand, ThemeSettings};
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
    let mut recv = server.run().await.unwrap();
    let server = Arc::new(server);

    tokio::spawn(async move {
        while let Some(event) = recv.recv().await {
            match event {
                notification_server::NotificationServerEvent::ToggleNotificationCenter => {
                    on_notification_center_state_change(NotificationCenterCommand::Toggle)
                }
                notification_server::NotificationServerEvent::CloseNotificationCenter => {
                    on_notification_center_state_change(NotificationCenterCommand::Close)
                }
                notification_server::NotificationServerEvent::OpenNotificationCenter => {
                    on_notification_center_state_change(NotificationCenterCommand::Open)
                }
                notification_server::NotificationServerEvent::CloseNotification(id) => {
                    on_notification_close(id)
                }
                notification_server::NotificationServerEvent::NewNotification(n) => {
                    on_notification(&n)
                }
                notification_server::NotificationServerEvent::StyleUpdate(style) => {
                    on_style_change(&style)
                }
                notification_server::NotificationServerEvent::ThemeSelected(theme) => {
                    on_theme_selected(theme)
                }
            }
        }
    });

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
        data: Some(signal_app_event::Data::Notification(n.into())),
    };

    let rust_signal = RustSignal {
        resource: DAEMON_EVENT_ID,
        message: Some(signal_message.encode_to_vec()),
        blob: None,
    };
    send_rust_signal(rust_signal);
}

fn on_style_change(s: &notification_server::Style) {
    let signal_message: Style = s.into();
    let rust_signal = RustSignal {
        resource: THEME_EVENT_ID,
        message: Some(signal_message.encode_to_vec()),
        blob: None,
    };
    send_rust_signal(rust_signal);
}

fn on_notification_close(n_id: u32) {
    let signal_message = SignalAppEvent {
        r#type: signal_app_event::AppEventType::CloseNotification.into(),
        data: Some(signal_app_event::Data::NotificationId(n_id.into())),
    };

    let rust_signal = RustSignal {
        resource: DAEMON_EVENT_ID,
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
        resource: DAEMON_EVENT_ID,
        message: Some(signal_message.encode_to_vec()),
        blob: None,
    };
    send_rust_signal(rust_signal);
}

fn on_theme_selected(theme_settings: ThemeSettings) {
    let variante: ThemeVariante = theme_settings.into();
    let signal_message = SettingsSignal {
        operation: Some(Operation::Theme(variante.into())),
    };
    let rust_signal = RustSignal {
        resource: SETTINGS_EVENT_ID,
        message: Some(signal_message.encode_to_vec()),
        blob: None,
    };
    send_rust_signal(rust_signal);
}

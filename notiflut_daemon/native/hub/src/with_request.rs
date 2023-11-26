//! This module runs the corresponding function
//! when a `RustRequest` was received from Dart
//! and returns a `RustResponse`.

use notification_server::NotificationServer;
use prost::Message;

use crate::bridge::{RustRequestUnique, RustResponse, RustResponseUnique};
use crate::messages;
use crate::messages::app_event::AppEvent;

pub fn handle_request(
    request_unique: RustRequestUnique,
    server: &NotificationServer,
) -> RustResponseUnique {
    // Get the request data from Dart.
    let rust_request = request_unique.request;
    let interaction_id = request_unique.id;

    // Run the function that handles the Rust resource.
    let rust_resource = rust_request.resource;
    let rust_response = match rust_resource {
        messages::app_event::ID => {
            let message_bytes = rust_request.message.unwrap();
            if let Ok(event) = messages::app_event::AppEvent::decode(message_bytes.as_slice()) {
                let event: AppEvent = event.into();
                match event.r#type() {
                    messages::app_event::AppEventType::Close => {
                        server.close_notification(event.notification_id.unwrap());
                    }
                    messages::app_event::AppEventType::CloseAll => {
                        server.close_all_notifications();
                    }
                    messages::app_event::AppEventType::CloseAllApp => {
                        server.close_all_notification_from_app(event.data.unwrap());
                    }
                    messages::app_event::AppEventType::ActionInvoked => {
                        server.invoke_action(event.notification_id.unwrap(), event.data.unwrap());
                    }
                }
                RustResponse {
                    successful: true,
                    message: None,
                    blob: None,
                }
            } else {
                RustResponse {
                    successful: false,
                    message: None,
                    blob: None,
                }
            }
        }
        _ => RustResponse::default(),
    };

    // Return the response to Dart.
    RustResponseUnique {
        id: interaction_id,
        response: rust_response,
    }
}

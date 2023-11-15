//! This module runs the corresponding function
//! when a `RustRequest` was received from Dart
//! and returns a `RustResponse`.

use notification_server::AppEvent;
use prost::Message;

use crate::bridge::{RustRequestUnique, RustResponse, RustResponseUnique};
use crate::messages;

pub async fn handle_request(request_unique: RustRequestUnique) -> RustResponseUnique {
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
                notification_server::send_app_event(event).unwrap();
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

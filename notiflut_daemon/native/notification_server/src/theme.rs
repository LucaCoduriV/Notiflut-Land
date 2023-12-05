use serde::{Deserialize, Serialize};

#[derive(Deserialize, Serialize)]
struct Color(u32);

#[derive(Deserialize, Serialize)]
struct Radius(u32);

#[derive(Deserialize, Serialize)]
struct NotificationStyle {
    background_color: Color,
    border_radius: Radius,
    text_color: Color,
}

#[derive(Deserialize, Serialize)]
struct NotificationCenterStyle {
    background_color: Color,
}

#[derive(Deserialize, Serialize)]
struct PopupStyle {
    background_color: Color,
}

#[derive(Deserialize, Serialize)]
struct Theme {
    notification_center: NotificationCenterStyle,
    popup: PopupStyle,
    notification: NotificationStyle,
}

use notification_server::{
    Hints, ImageData, ImageSource, Notification, NotificationCenterStyle, NotificationStyle,
    PopupStyle, Style, Theme, ThemeSettings, Urgency,
};
use prost_types::Timestamp;
use std::convert::Into;

use crate::messages;

impl From<Notification> for messages::daemon_event::Notification {
    fn from(val: Notification) -> Self {
        let created_at = Timestamp {
            seconds: val.created_at.timestamp(),
            nanos: val.created_at.timestamp_subsec_nanos() as i32,
        };
        messages::daemon_event::Notification {
            id: val.n_id,
            app_name: val.app_name,
            replaces_id: val.replaces_id,
            summary: val.summary,
            body: val.body,
            actions: val.actions,
            timeout: val.timeout,
            created_at: Some(created_at),
            hints: Some(val.hints.into()),
            app_icon: val.app_icon.map(|a| a.into()),
            app_image: val.app_image.map(|a| a.into()),
        }
    }
}

impl From<&Notification> for messages::daemon_event::Notification {
    fn from(val: &Notification) -> Self {
        let created_at = Timestamp {
            seconds: val.created_at.timestamp(),
            nanos: val.created_at.timestamp_subsec_nanos() as i32,
        };
        messages::daemon_event::Notification {
            id: val.n_id,
            app_name: val.app_name.clone(),
            replaces_id: val.replaces_id,
            summary: val.summary.clone(),
            body: val.body.clone(),
            actions: val.actions.clone(),
            timeout: val.timeout,
            created_at: Some(created_at),
            hints: Some(val.hints.clone().into()),
            app_icon: val.app_icon.as_ref().map(|a| a.into()),
            app_image: val.app_image.as_ref().map(|a| a.into()),
        }
    }
}

impl From<Hints> for messages::daemon_event::Hints {
    fn from(val: Hints) -> Self {
        let urgency: Option<messages::daemon_event::hints::Urgency> = val.urgency.map(|u| u.into());
        messages::daemon_event::Hints {
            actions_icon: val.actions_icon,
            category: val.category,
            desktop_entry: val.desktop_entry,
            resident: val.resident,
            sound_file: val.sound_file,
            sound_name: val.sound_name,
            suppress_sound: val.suppress_sound,
            transient: val.transient,
            x: val.x,
            y: val.y,
            urgency: urgency.map(|u| u.into()),
        }
    }
}

impl From<&Hints> for messages::daemon_event::Hints {
    fn from(val: &Hints) -> Self {
        let urgency: Option<messages::daemon_event::hints::Urgency> =
            val.urgency.clone().map(|u| u.into());
        messages::daemon_event::Hints {
            actions_icon: val.actions_icon,
            category: val.category.clone(),
            desktop_entry: val.desktop_entry.clone(),
            resident: val.resident,
            sound_file: val.sound_file.clone(),
            sound_name: val.sound_name.clone(),
            suppress_sound: val.suppress_sound,
            transient: val.transient,
            x: val.x,
            y: val.y,
            urgency: urgency.map(|u| u.into()),
        }
    }
}

impl From<Urgency> for messages::daemon_event::hints::Urgency {
    fn from(val: Urgency) -> Self {
        match val {
            Urgency::Low => messages::daemon_event::hints::Urgency::Low,
            Urgency::Normal => messages::daemon_event::hints::Urgency::Normal,
            Urgency::Critical => messages::daemon_event::hints::Urgency::Critical,
        }
    }
}

impl From<ImageSource> for messages::daemon_event::ImageSource {
    fn from(val: ImageSource) -> Self {
        match val {
            ImageSource::Data(d) => messages::daemon_event::ImageSource {
                r#type: messages::daemon_event::image_source::ImageSourceType::Data.into(),
                image_data: Some(d.into()),
                path: None,
            },
            ImageSource::Path(p) => messages::daemon_event::ImageSource {
                r#type: messages::daemon_event::image_source::ImageSourceType::Path.into(),
                image_data: None,
                path: Some(p),
            },
        }
    }
}

impl From<&ImageSource> for messages::daemon_event::ImageSource {
    fn from(val: &ImageSource) -> Self {
        match val {
            ImageSource::Data(ref d) => Self {
                r#type: messages::daemon_event::image_source::ImageSourceType::Data.into(),
                image_data: Some(d.into()),
                path: None,
            },
            ImageSource::Path(p) => Self {
                r#type: messages::daemon_event::image_source::ImageSourceType::Path.into(),
                image_data: None,
                path: Some(p.clone()),
            },
        }
    }
}

impl From<ImageData> for messages::daemon_event::ImageData {
    fn from(val: ImageData) -> Self {
        Self {
            width: val.width,
            height: val.height,
            rowstride: val.rowstride,
            one_point_two_bit_alpha: val.one_point_two_bit_alpha,
            bits_per_sample: val.bits_per_sample,
            channels: val.channels,
            data: val.data.into_iter().map(|d| d.into()).collect(),
        }
    }
}

impl From<&ImageData> for messages::daemon_event::ImageData {
    fn from(val: &ImageData) -> Self {
        Self {
            width: val.width,
            height: val.height,
            rowstride: val.rowstride,
            one_point_two_bit_alpha: val.one_point_two_bit_alpha,
            bits_per_sample: val.bits_per_sample,
            channels: val.channels,
            data: val.data.iter().map(|d| *d as u32).collect(),
        }
    }
}

impl From<Style> for messages::theme_event::Style {
    fn from(val: Style) -> Self {
        Self {
            light: Some(val.light.into()),
            dark: Some(val.dark.into()),
        }
    }
}

impl From<&Style> for messages::theme_event::Style {
    fn from(val: &Style) -> Self {
        Self {
            light: Some(val.light.clone().into()),
            dark: Some(val.dark.clone().into()),
        }
    }
}

impl From<Theme> for messages::theme_event::Theme {
    fn from(val: Theme) -> Self {
        Self {
            notification_style: Some(val.notification.into()),
            notification_center_style: Some(val.notification_center.into()),
            popup_style: Some(val.popup.into()),
        }
    }
}

impl From<&Theme> for messages::theme_event::Theme {
    fn from(val: &Theme) -> Self {
        Self {
            notification_style: Some(val.notification.clone().into()),
            notification_center_style: Some(val.notification_center.clone().into()),
            popup_style: Some(val.popup.clone().into()),
        }
    }
}

impl From<NotificationStyle> for messages::theme_event::NotificationStyle {
    fn from(val: NotificationStyle) -> Self {
        Self {
            background_color: val.background_color.0 as i32,
            border_radius: val.border_radius.0 as i32,
        }
    }
}

impl From<&NotificationStyle> for messages::theme_event::NotificationStyle {
    fn from(val: &NotificationStyle) -> Self {
        Self {
            background_color: val.background_color.0 as i32,
            border_radius: val.border_radius.0 as i32,
        }
    }
}

impl From<NotificationCenterStyle> for messages::theme_event::NotificationCenterStyle {
    fn from(val: NotificationCenterStyle) -> Self {
        Self {
            background_color: val.background_color.0 as i32,
        }
    }
}

impl From<&NotificationCenterStyle> for messages::theme_event::NotificationCenterStyle {
    fn from(val: &NotificationCenterStyle) -> Self {
        Self {
            background_color: val.background_color.0 as i32,
        }
    }
}

impl From<PopupStyle> for messages::theme_event::PopupStyle {
    fn from(val: PopupStyle) -> Self {
        Self {
            background_color: val.background_color.0 as i32,
        }
    }
}

impl From<&PopupStyle> for messages::theme_event::PopupStyle {
    fn from(val: &PopupStyle) -> Self {
        Self {
            background_color: val.background_color.0 as i32,
        }
    }
}

impl From<ThemeSettings> for messages::settings_event::ThemeVariante {
    fn from(val: ThemeSettings) -> Self {
        match val {
            ThemeSettings::Light => messages::settings_event::ThemeVariante::Light,
            ThemeSettings::Dark => messages::settings_event::ThemeVariante::Dark,
        }
    }
}

impl From<&ThemeSettings> for messages::settings_event::ThemeVariante {
    fn from(val: &ThemeSettings) -> Self {
        match val {
            ThemeSettings::Light => messages::settings_event::ThemeVariante::Light,
            ThemeSettings::Dark => messages::settings_event::ThemeVariante::Dark,
        }
    }
}

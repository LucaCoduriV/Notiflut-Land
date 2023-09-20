use notification_server::AppEvent;
use notification_server::Hints;
use notification_server::ImageData;
use notification_server::ImageSource;
use notification_server::Notification;
use notification_server::Urgency;
use prost_types::Timestamp;
use std::convert::Into;

use crate::messages;

impl Into<messages::daemon_event::Notification> for Notification {
    fn into(self) -> messages::daemon_event::Notification {
        let created_at = Timestamp {
            seconds: self.created_at.timestamp(),
            nanos: self.created_at.timestamp_subsec_nanos() as i32,
        };
        messages::daemon_event::Notification {
            id: self.id,
            app_name: self.app_name,
            replaces_id: self.replaces_id,
            summary: self.summary,
            body: self.body,
            actions: self.actions,
            timeout: self.timeout,
            created_at: Some(created_at),
            hints: Some(self.hints.into()),
            app_icon: self.app_icon.map(|a| a.into()),
            app_image: self.app_image.map(|a| a.into()),
        }
    }
}

impl Into<messages::daemon_event::Hints> for Hints {
    fn into(self) -> messages::daemon_event::Hints {
        let urgency: Option<messages::daemon_event::hints::Urgency> =
            self.urgency.map(|u| u.into());
        messages::daemon_event::Hints {
            actions_icon: self.actions_icon,
            category: self.category,
            desktop_entry: self.desktop_entry,
            resident: self.resident,
            sound_file: self.sound_file,
            sound_name: self.sound_name,
            suppress_sound: self.suppress_sound,
            transient: self.transient,
            x: self.x,
            y: self.y,
            urgency: urgency.map(|u| u.into()),
        }
    }
}

impl Into<messages::daemon_event::hints::Urgency> for Urgency {
    fn into(self) -> messages::daemon_event::hints::Urgency {
        match self {
            Urgency::Low => messages::daemon_event::hints::Urgency::Low,
            Urgency::Normal => messages::daemon_event::hints::Urgency::Normal,
            Urgency::Critical => messages::daemon_event::hints::Urgency::Critical,
        }
    }
}

impl Into<messages::daemon_event::ImageSource> for ImageSource {
    fn into(self) -> messages::daemon_event::ImageSource {
        match self {
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

impl Into<messages::daemon_event::ImageData> for ImageData {
    fn into(self) -> messages::daemon_event::ImageData {
        messages::daemon_event::ImageData {
            width: self.width,
            height: self.height,
            rowstride: self.rowstride,
            one_point_two_bit_alpha: self.one_point_two_bit_alpha,
            bits_per_sample: self.bits_per_sample,
            channels: self.channels,
            data: self.data.into_iter().map(|d| d.into()).collect(),
        }
    }
}

impl Into<AppEvent> for messages::app_event::AppEvent {
    fn into(self) -> AppEvent {
        match self.r#type() {
            messages::app_event::AppEventType::Close => AppEvent::Close(self.notification_id()),
            messages::app_event::AppEventType::CloseAll => AppEvent::CloseAll,
            messages::app_event::AppEventType::CloseAllApp => {
                AppEvent::CloseAllApp(self.data().to_owned())
            }
            messages::app_event::AppEventType::CloseNotification => AppEvent::CloseNotification,
            messages::app_event::AppEventType::ActionInvoked => {
                AppEvent::ActionInvoked(self.notification_id(), self.data().to_owned())
            }
        }
    }
}

use serde::{Deserialize, Serialize};

use crate::Urgency;

#[derive(Default, Deserialize, Serialize)]
pub struct Configuration {
    pub do_not_disturb: bool,
    pub emitters_settings: Vec<NotificationEmitterSettings>,
}

#[derive(Deserialize, Serialize)]
pub enum UrgencyLevel {
    Low,
    Normal,
    Critical,
}

impl From<UrgencyLevel> for Urgency {
    fn from(val: UrgencyLevel) -> Self {
        match val {
            UrgencyLevel::Low => Urgency::Low,
            UrgencyLevel::Normal => Urgency::Normal,
            UrgencyLevel::Critical => Urgency::Critical,
        }
    }
}

impl From<&UrgencyLevel> for Urgency {
    fn from(val: &UrgencyLevel) -> Self {
        match val {
            UrgencyLevel::Low => Urgency::Low,
            UrgencyLevel::Normal => Urgency::Normal,
            UrgencyLevel::Critical => Urgency::Critical,
        }
    }
}

#[derive(Deserialize, Serialize)]
pub struct NotificationEmitterSettings {
    pub name: String,
    pub ignore: bool,
    pub urgency_low_as: UrgencyLevel,
    pub urgency_normal_as: UrgencyLevel,
    pub urgency_critical_as: UrgencyLevel,
}

impl Default for NotificationEmitterSettings {
    fn default() -> Self {
        Self {
            name: Default::default(),
            ignore: false,
            urgency_low_as: UrgencyLevel::Low,
            urgency_normal_as: UrgencyLevel::Normal,
            urgency_critical_as: UrgencyLevel::Critical,
        }
    }
}

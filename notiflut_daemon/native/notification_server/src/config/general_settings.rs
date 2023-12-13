use serde::{Deserialize, Serialize};

use crate::Urgency;

use super::HasFileName;

#[derive(Default, Deserialize, Serialize)]
pub struct Settings {
    pub do_not_disturb: bool,
    pub emitters_settings: Vec<NotificationEmitterSettings>,
}

impl Settings {
    pub fn find_notification_emitter_settings<'a>(
        &'a self,
        name: &str,
    ) -> Option<&'a NotificationEmitterSettings> {
        self.emitters_settings
            .iter()
            .find(|&emit_cfg| emit_cfg.name == name)
    }
}

impl HasFileName for Settings {
    fn file_name() -> &'static str {
        if cfg!(test) {
            "config_test.toml"
        } else {
            "config.toml"
        }
    }
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

#[cfg(test)]
mod test {
    use std::fs;

    use crate::config::{ConfigIO, HasFileName};

    use super::{NotificationEmitterSettings, Settings};

    #[test]
    fn test_write_config() -> anyhow::Result<()> {
        let cfg = Settings {
            do_not_disturb: false,
            emitters_settings: vec![NotificationEmitterSettings {
                name: "test".to_string(),
                ignore: true,
                urgency_low_as: super::UrgencyLevel::Low,
                urgency_normal_as: super::UrgencyLevel::Normal,
                urgency_critical_as: super::UrgencyLevel::Critical,
            }],
        };
        cfg.write_file()?;

        let xdg_dirs = xdg::BaseDirectories::with_prefix("notiflut").unwrap();
        let config_path = xdg_dirs.place_config_file(Settings::file_name())?;

        assert!(config_path.exists());

        fs::remove_file(config_path)?;

        Ok(())
    }
}

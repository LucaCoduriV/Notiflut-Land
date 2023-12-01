mod models;

use std::fs;

pub use models::{Configuration, NotificationEmitterSettings, UrgencyLevel};

/// reads the config file from xdg dir if it exists or returns the default configuration
pub fn read_config_file() -> anyhow::Result<Configuration> {
    let xdg_dirs = xdg::BaseDirectories::with_prefix("notiflut").unwrap();
    let config_path = xdg_dirs.place_config_file("config.toml")?;

    let file_content = fs::read_to_string(config_path)?;
    let config: Configuration = toml::from_str(&file_content)?;
    Ok(config)
}

/// Writes the config to the config file using the xdg dir.
pub fn write_config_file(config: &Configuration) -> anyhow::Result<()> {
    #![allow(dead_code)]
    let xdg_dirs = xdg::BaseDirectories::with_prefix("notiflut").unwrap();
    let config_path = xdg_dirs.place_config_file("config.toml")?;
    let config_str = toml::to_string(config)?;
    if let Some(path) = config_path.parent() {
        fs::create_dir_all(path)?;
    }
    fs::write(config_path, config_str).map_err(Into::into)
}

pub fn find_notification_emitter_settings<'a>(
    config: &'a Configuration,
    name: &str,
) -> Option<&'a NotificationEmitterSettings> {
    config
        .emitters_settings
        .iter()
        .find(|&emit_cfg| emit_cfg.name == name)
}

#[cfg(test)]
mod test {
    use super::{write_config_file, NotificationEmitterSettings};

    #[test]
    fn test_write_config() -> anyhow::Result<()> {
        write_config_file(&super::Configuration {
            do_not_disturb: false,
            emitters_settings: vec![NotificationEmitterSettings {
                name: "test".to_string(),
                ignore: true,
                urgency_low_as: super::UrgencyLevel::Low,
                urgency_normal_as: super::UrgencyLevel::Normal,
                urgency_critical_as: super::UrgencyLevel::Critical,
            }],
        })?;
        Ok(())
    }
}

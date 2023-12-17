use serde::{Deserialize, Serialize};

use super::HasFileName;

#[derive(Deserialize, Serialize, Default, Debug, Clone)]
pub struct Color(pub u32);

#[derive(Deserialize, Serialize, Default, Debug, Clone)]
pub struct Radius(pub u32);

#[derive(Deserialize, Serialize, Debug, Clone)]
pub struct NotificationStyle {
    pub background_color: Color,
    pub border_radius: Radius,
    pub text_color: Color,
}

impl Default for NotificationStyle {
    fn default() -> Self {
        Self {
            background_color: Color(0xBBE0E0E0),
            border_radius: Radius(20),
            text_color: Color(0xFFFFFFFF),
        }
    }
}

#[derive(Deserialize, Serialize, Default, Debug, Clone)]
pub struct NotificationCenterStyle {
    pub background_color: Color,
}

#[derive(Deserialize, Serialize, Default, Debug, Clone)]
pub struct PopupStyle {
    pub background_color: Color,
}

#[derive(Deserialize, Serialize, Default, Debug, Clone)]
pub struct Theme {
    pub notification_center: NotificationCenterStyle,
    pub popup: PopupStyle,
    pub notification: NotificationStyle,
}

#[derive(Deserialize, Serialize, Default, Debug, Clone)]
pub struct Style {
    pub light: Theme,
    pub dark: Theme,
}

impl HasFileName for Style {
    fn file_name() -> &'static str {
        if cfg!(test) {
            "style_test.toml"
        } else {
            "style.toml"
        }
    }
}

#[cfg(test)]
mod test {
    use std::fs;

    use crate::config::{ConfigIO, HasFileName};

    use super::Style;

    #[test]
    fn test_write_style() -> anyhow::Result<()> {
        let cfg = Style::default();
        cfg.write_file()?;

        let xdg_dirs = xdg::BaseDirectories::with_prefix("notiflut").unwrap();
        let config_path = xdg_dirs.place_config_file(Style::file_name())?;

        assert!(config_path.exists());

        fs::remove_file(config_path)?;

        Ok(())
    }
}

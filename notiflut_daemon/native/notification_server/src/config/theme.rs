use serde::{Deserialize, Serialize};

use super::HasFileName;

#[derive(Deserialize, Serialize, Default)]
struct Color(u32);

#[derive(Deserialize, Serialize, Default)]
struct Radius(u32);

#[derive(Deserialize, Serialize, Default)]
struct NotificationStyle {
    background_color: Color,
    border_radius: Radius,
    text_color: Color,
}

#[derive(Deserialize, Serialize, Default)]
struct NotificationCenterStyle {
    background_color: Color,
}

#[derive(Deserialize, Serialize, Default)]
struct PopupStyle {
    background_color: Color,
}

#[derive(Deserialize, Serialize, Default)]
struct Theme {
    notification_center: NotificationCenterStyle,
    popup: PopupStyle,
    notification: NotificationStyle,
}

#[derive(Deserialize, Serialize, Default)]
struct Style {
    light: Theme,
    dark: Theme,
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

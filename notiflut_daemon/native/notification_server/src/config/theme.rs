use serde::{Deserialize, Serialize};

use super::HasFileName;

trait ThemeLight {
    fn light() -> Self;
}

trait ThemeDark {
    fn dark() -> Self;
}

#[derive(Deserialize, Serialize, Debug, Clone)]
pub struct Color(pub u32);

#[derive(Deserialize, Serialize, Debug, Clone)]
pub struct Radius(pub u32);

#[derive(Debug, Clone)]
pub struct NotificationStyle {
    pub background_color: Color,
    pub border_radius: Radius,
    pub body_text_color: Color,
    pub title_text_color: Color,
    pub subtitle_text_color: Color,
    pub button_text_color: Color,
}

#[derive(Deserialize, Serialize, Debug, Clone)]
pub struct NotificationStyleInner {
    pub background_color: Option<Color>,
    pub border_radius: Option<Radius>,
    pub body_text_color: Option<Color>,
    pub title_text_color: Option<Color>,
    pub subtitle_text_color: Option<Color>,
    pub button_text_color: Option<Color>,
}

#[derive(Debug, Clone)]
pub struct NotificationCenterStyle {
    pub background_color: Color,
}

#[derive(Deserialize, Serialize, Debug, Clone)]
pub struct NotificationCenterStyleInner {
    pub background_color: Option<Color>,
}

impl ThemeLight for NotificationCenterStyle {
    fn light() -> Self {
        Self {
            background_color: Color(0x00FFFFFF),
        }
    }
}

impl ThemeDark for NotificationCenterStyle {
    fn dark() -> Self {
        Self {
            background_color: Color(0x00FFFFFF),
        }
    }
}

#[derive(Debug, Clone)]
pub struct PopupStyle {
    pub background_color: Color,
}

#[derive(Deserialize, Serialize, Debug, Clone)]
pub struct PopupStyleInner {
    pub background_color: Option<Color>,
}

impl ThemeLight for PopupStyle {
    fn light() -> Self {
        Self {
            background_color: Color(0x00FFFFFF),
        }
    }
}

impl ThemeDark for PopupStyle {
    fn dark() -> Self {
        Self {
            background_color: Color(0x00FFFFFF),
        }
    }
}

#[derive(Debug, Clone)]
pub struct Theme {
    pub notification_center: NotificationCenterStyle,
    pub popup: PopupStyle,
    pub notification: NotificationStyle,
}

#[derive(Deserialize, Serialize, Debug, Clone)]
pub struct ThemeInner {
    pub notification_center: Option<NotificationCenterStyleInner>,
    pub popup: Option<PopupStyleInner>,
    pub notification: Option<NotificationStyleInner>,
}

#[derive(Debug, Clone)]
pub struct Style {
    pub light: Theme,
    pub dark: Theme,
}

impl From<StyleInner> for Style {
    fn from(value: StyleInner) -> Self {
        Self {
            light: Theme {
                notification_center: NotificationCenterStyle {
                    background_color: value
                        .light
                        .as_ref()
                        .and_then(|v| v.notification_center.as_ref())
                        .and_then(|v| v.background_color.clone())
                        .unwrap_or(Color(0x00FFFFFF)),
                },
                popup: PopupStyle {
                    background_color: value
                        .light
                        .as_ref()
                        .and_then(|v| v.popup.as_ref())
                        .and_then(|v| v.background_color.clone())
                        .unwrap_or(Color(0x00FFFFFF)),
                },
                notification: NotificationStyle {
                    background_color: value
                        .light
                        .as_ref()
                        .and_then(|v| v.notification.as_ref())
                        .and_then(|v| v.background_color.clone())
                        .unwrap_or(Color(0xBBE0E0E0)),
                    border_radius: value
                        .light
                        .as_ref()
                        .and_then(|v| v.notification.as_ref())
                        .and_then(|v| v.border_radius.clone())
                        .unwrap_or(Radius(20)),
                    body_text_color: value
                        .light
                        .as_ref()
                        .and_then(|v| v.notification.as_ref())
                        .and_then(|v| v.body_text_color.clone())
                        .unwrap_or(Color(0xFFFFFFFF)),
                    title_text_color: value
                        .light
                        .as_ref()
                        .and_then(|v| v.notification.as_ref())
                        .and_then(|v| v.title_text_color.clone())
                        .unwrap_or(Color(0xFFFFFFFF)),
                    subtitle_text_color: value
                        .light
                        .as_ref()
                        .and_then(|v| v.notification.as_ref())
                        .and_then(|v| v.subtitle_text_color.clone())
                        .unwrap_or(Color(0xFFFFFFFF)),
                    button_text_color: value
                        .light
                        .as_ref()
                        .and_then(|v| v.notification.as_ref())
                        .and_then(|v| v.button_text_color.clone())
                        .unwrap_or(Color(0xFFFFFFFF)),
                },
            },
            dark: Theme {
                notification_center: NotificationCenterStyle {
                    background_color: value
                        .light
                        .as_ref()
                        .and_then(|v| v.notification_center.as_ref())
                        .and_then(|v| v.background_color.clone())
                        .unwrap_or(Color(0x00FFFFFF)),
                },
                popup: PopupStyle {
                    background_color: value
                        .light
                        .as_ref()
                        .and_then(|v| v.popup.as_ref())
                        .and_then(|v| v.background_color.clone())
                        .unwrap_or(Color(0x00FFFFFF)),
                },
                notification: NotificationStyle {
                    background_color: value
                        .light
                        .as_ref()
                        .and_then(|v| v.notification.as_ref())
                        .and_then(|v| v.background_color.clone())
                        .unwrap_or(Color(0xBBE0E0E0)),
                    border_radius: value
                        .light
                        .as_ref()
                        .and_then(|v| v.notification.as_ref())
                        .and_then(|v| v.border_radius.clone())
                        .unwrap_or(Radius(20)),
                    body_text_color: value
                        .light
                        .as_ref()
                        .and_then(|v| v.notification.as_ref())
                        .and_then(|v| v.body_text_color.clone())
                        .unwrap_or(Color(0xFFFFFFFF)),
                    title_text_color: value
                        .light
                        .as_ref()
                        .and_then(|v| v.notification.as_ref())
                        .and_then(|v| v.title_text_color.clone())
                        .unwrap_or(Color(0xFFFFFFFF)),
                    subtitle_text_color: value
                        .light
                        .as_ref()
                        .and_then(|v| v.notification.as_ref())
                        .and_then(|v| v.subtitle_text_color.clone())
                        .unwrap_or(Color(0xFFFFFFFF)),
                    button_text_color: value
                        .light
                        .as_ref()
                        .and_then(|v| v.notification.as_ref())
                        .and_then(|v| v.button_text_color.clone())
                        .unwrap_or(Color(0xFFFFFFFF)),
                },
            },
        }
    }
}

#[derive(Deserialize, Serialize, Default, Debug, Clone)]
pub struct StyleInner {
    pub light: Option<ThemeInner>,
    pub dark: Option<ThemeInner>,
}

impl HasFileName for StyleInner {
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

    use super::StyleInner;

    #[test]
    fn test_write_style() -> anyhow::Result<()> {
        let cfg = StyleInner::default();
        cfg.write_file()?;

        let xdg_dirs = xdg::BaseDirectories::with_prefix("notiflut").unwrap();
        let config_path = xdg_dirs.place_config_file(StyleInner::file_name())?;

        assert!(config_path.exists());

        fs::remove_file(config_path)?;

        Ok(())
    }
}

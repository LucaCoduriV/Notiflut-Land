mod general_settings;
mod theme;

use serde::{de::DeserializeOwned, Serialize};
use std::{fs, path::PathBuf};

pub use general_settings::{NotificationEmitterSettings, Settings, ThemeSettings, UrgencyLevel};
pub use theme::{
    Color, NotificationCenterStyle, NotificationStyle, PopupStyle, Radius, Style, Theme,
};

trait HasFileName {
    fn file_name() -> &'static str;
}
pub trait ConfigIO {
    fn from_file() -> Self;
    fn write_file(&self) -> anyhow::Result<()>;
    fn read_file(&mut self) -> anyhow::Result<()>;
}

impl<T> ConfigIO for T
where
    T: HasFileName + Serialize + DeserializeOwned + Default,
{
    fn write_file(&self) -> anyhow::Result<()> {
        let filename = Self::file_name();
        let config_path = get_path(filename)?;
        let config_str = toml::to_string(self)?;
        if let Some(path) = config_path.parent() {
            fs::create_dir_all(path)?;
        }
        fs::write(config_path, config_str).map_err(Into::into)
    }

    fn read_file(&mut self) -> anyhow::Result<()> {
        let config: T = read_config_impl(Self::file_name())?;
        let _ = std::mem::replace(self, config);
        Ok(())
    }

    fn from_file() -> Self {
        let config: anyhow::Result<T> = read_config_impl(Self::file_name());

        match config {
            Ok(cfg) => cfg,
            Err(_) => {
                let cfg = Self::default();
                cfg.write_file().unwrap();
                cfg
            }
        }
    }
}

fn get_path(filename: &str) -> anyhow::Result<PathBuf> {
    let xdg_dirs = xdg::BaseDirectories::with_prefix("notiflut").unwrap();
    xdg_dirs.place_config_file(filename).map_err(|e| e.into())
}

fn read_config_impl<T>(filename: &str) -> anyhow::Result<T>
where
    T: DeserializeOwned,
{
    let config_path = get_path(filename)?;

    let file_content = fs::read_to_string(config_path)?;
    let config: T = toml::from_str(&file_content)?;
    // let _ = std::mem::replace(self, config);
    Ok(config)
}

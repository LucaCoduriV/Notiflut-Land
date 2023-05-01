use std::collections::VecDeque;

use dbus::arg::cast;
use dbus::arg::prop_cast;
use dbus::arg::PropMap;
use dbus::arg::RefArg;

#[derive(Debug, Clone)]
pub struct Notification {
    pub id: u32,
    pub app_name: String,
    pub replaces_id: u32,
    pub icon: String,
    pub summary: String,
    pub body: String,
    pub actions: Vec<String>,
    pub timeout: i32,
    pub time_since_display: u32,
    pub hints: Hints,
}

#[derive(Debug, Clone)]
pub struct Hints {
    pub actions_icon: Option<bool>,
    pub category: Option<String>,
    pub desktop_entry: Option<String>,
    pub image_data: Option<ImageData>,
    pub image_path: Option<String>,
    pub resident: Option<bool>,
    pub sound_file: Option<String>,
    pub sound_name: Option<String>,
    pub suppress_sound: Option<bool>,
    pub transient: Option<bool>,
    pub x: Option<i32>,
    pub y: Option<i32>,
    pub urgency: Option<Urgency>,
}

impl From<&PropMap> for Hints {
    fn from(map: &PropMap) -> Self {
        let actions_icon = prop_cast::<bool>(&map, "action-icons").copied();
        let category = prop_cast::<String>(&map, "category").cloned();
        let desktop_entry = prop_cast::<String>(&map, "desktop-entry").cloned();
        let image_path = prop_cast::<String>(&map, "image-path").cloned();
        let resident = prop_cast::<bool>(&map, "resident").copied();
        let sound_file = prop_cast::<String>(&map, "sound-file").cloned();
        let sound_name = prop_cast::<String>(&map, "sound-name").cloned();
        let suppress_sound = prop_cast::<bool>(&map, "suppress-sound").copied();
        let transient = prop_cast::<bool>(&map, "transient").copied();
        let pos_x = prop_cast::<i32>(&map, "x").copied();
        let pos_y = prop_cast::<i32>(&map, "y").copied();
        let urgency = match prop_cast::<u8>(&map, "urgency").copied() {
            Some(v) => Urgency::try_from(v).ok(),
            None => None,
        };
        let image_data = match prop_cast::<VecDeque<Box<dyn RefArg>>>(&map, "image-data") {
            Some(v) => ImageData::try_from(v).ok(),
            None => None,
        };
        Hints {
            actions_icon,
            category,
            desktop_entry,
            image_data,
            image_path,
            resident,
            sound_file,
            sound_name,
            suppress_sound,
            transient,
            x: pos_x,
            y: pos_y,
            urgency,
        }
    }
}
#[derive(Debug, Clone)]
pub enum Urgency {
    Low,
    Normal,
    Critical,
}

impl TryFrom<u8> for Urgency {
    type Error = ();

    fn try_from(value: u8) -> Result<Self, Self::Error> {
        match value {
            0 => Ok(Urgency::Low),
            1 => Ok(Urgency::Normal),
            2 => Ok(Urgency::Critical),
            _ => Err(()),
        }
    }
}

#[derive(Debug, Clone)]
pub struct ImageData {
    pub width: i32,
    pub height: i32,
    pub rowstride: i32,
    pub one_point_two_bit_alpha: bool,
    pub bits_per_sample: i32,
    pub channels: i32,
    pub data: Vec<u8>,
}

impl TryFrom<&VecDeque<Box<dyn RefArg>>> for ImageData {
    type Error = Box<dyn std::error::Error>;

    fn try_from(img: &VecDeque<Box<dyn RefArg>>) -> Result<Self, Self::Error> {
        let width = *cast::<i32>(&img[0]).ok_or("couldn't cast image's width")?;
        let height = *cast::<i32>(&img[1]).ok_or("couldn't cast image's height")?;
        let rowstride = *cast::<i32>(&img[2]).ok_or("couldn't cast image's rowstride")?;
        let one_point_two_bit_alpha =
            *cast::<bool>(&img[3]).ok_or("couldn't cast image's one_point_two_bit_alpha")?;
        let bits_per_sample =
            *cast::<i32>(&img[4]).ok_or("couldn't cast image's bits_per_sample")?;
        let channels = *cast::<i32>(&img[5]).ok_or("couldn't cast image's channels")?;
        let data = cast::<Vec<u8>>(&img[6])
            .ok_or("couldn't cast image's data")?
            .clone();

        Ok(ImageData {
            width,
            height,
            rowstride,
            one_point_two_bit_alpha,
            bits_per_sample,
            channels,
            data,
        })
    }
}

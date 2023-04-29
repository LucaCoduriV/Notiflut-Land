use std::collections::VecDeque;

use dbus::arg::prop_cast;
use dbus::arg::cast;
use dbus::arg::PropMap;
use dbus::arg::RefArg;

#[derive(Debug)]
pub struct Notification{
    pub app_name:String,
    pub id:u32,
    pub icon:String,
    pub summary:String,
    pub body:String,
    pub actions:Vec<String>,
    pub timeout:i32,
    pub hints:Hints,
}

#[derive(Debug)]
pub struct Hints{
    pub actions_icon: Option<bool>,
    pub category: Option<String>,
    pub desktop_entry: Option<String>,
    pub image_data: Option<Image>,
    pub image_path: Option<String>,
    pub resident: Option<bool>,
    pub sound_file: Option<String>,
    pub sound_name: Option<String>,
    pub suppress_sound: Option<bool>,
    pub transient: Option<bool>,
    pub position:(Option<i32>,Option<i32>),
    pub urgency:Option<u8>,
}

impl From<&PropMap> for Hints {
    fn from(map: &PropMap) -> Self {
        let actions_icon = match prop_cast::<bool>(&map, "action-icons"){
            Some(v) => Some(*v),
            None => None,
        };
        let category = match prop_cast::<String>(&map, "category"){
            Some(v) => Some(v.clone()),
            None => None,
        };
        let desktop_entry = match prop_cast::<String>(&map, "desktop-entry"){
            Some(v) => Some(v.clone()),
            None => None,
        };
        let image_path = match prop_cast::<String>(&map, "image-path"){
            Some(v) => Some(v.clone()),
            None => None,
        };
        let resident = match prop_cast::<bool>(&map, "resident"){
            Some(v) => Some(*v),
            None => None,
        };
        let sound_file = match prop_cast::<String>(&map, "sound-file"){
            Some(v) => Some(v.clone()),
            None => None,
        };
        let sound_name = match prop_cast::<String>(&map, "sound-name"){
            Some(v) => Some(v.clone()),
            None => None,
        };
        let suppress_sound = match prop_cast::<bool>(&map, "suppress-sound"){
            Some(v) => Some(*v),
            None => None,
        };
        let transient = match prop_cast::<bool>(&map, "transient"){
            Some(v) => Some(*v),
            None => None,
        };
        let pos_x = match prop_cast::<i32>(&map, "x"){
            Some(v) => Some(*v),
            None => None,
        };
        let pos_y = match prop_cast::<i32>(&map, "y"){
            Some(v) => Some(*v),
            None => None,
        };
        let urgency = prop_cast::<u8>(&map, "urgency").copied();
        let image_data = match prop_cast::<VecDeque<Box<dyn RefArg>>>(&map, "image-data"){
            Some(v) => Image::try_from(v).ok(),
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
            position: (pos_x, pos_y),
            urgency,
        }
    }
}

#[derive(Debug)]
pub struct Image {
    pub width: i32,
    pub height: i32,
    pub rowstride: i32,
    pub one_point_two_bit_alpha: bool,
    pub bits_per_sample: i32,
    pub channels: i32,
    pub data: Vec<u8>,
}

impl TryFrom<&VecDeque<Box<dyn RefArg>>> for Image {
    type Error = Box<dyn std::error::Error>;

    fn try_from(img: &VecDeque<Box<dyn RefArg>>) -> Result<Self, Self::Error> {
        println!("{img:?}");
        let width = *cast::<i32>(&img[0]).ok_or("couldn't cast image's width")?;
        let height = *cast::<i32>(&img[1]).ok_or("couldn't cast image's height")?;
        let rowstride = *cast::<i32>(&img[2]).ok_or("couldn't cast image's rowstride")?;
        let one_point_two_bit_alpha = *cast::<bool>(&img[3]).ok_or("couldn't cast image's one_point_two_bit_alpha")?;
        let bits_per_sample = *cast::<i32>(&img[4]).ok_or("couldn't cast image's bits_per_sample")?;
        let channels = *cast::<i32>(&img[5]).ok_or("couldn't cast image's channels")?;
        let data = cast::<Vec<u8>>(&img[6]).ok_or("couldn't cast image's data")?.clone();

        Ok(Image{
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

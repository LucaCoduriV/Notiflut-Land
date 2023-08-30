use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize, Debug)]
pub struct Status<'a> {
    pub text: &'a str,
    pub alt: &'a str,
    pub tooltip: bool,
    pub class: &'a str,
    pub percentage: u32,
}

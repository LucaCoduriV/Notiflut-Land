use crate::notification::Notification;

pub struct DaemonData {
    pub notifications: Vec<Notification>,
    pub is_open: bool,
}

impl DaemonData {
    pub fn new() -> Self {
        DaemonData {
            notifications: Vec::new(),
            is_open: false,
        }
    }
}

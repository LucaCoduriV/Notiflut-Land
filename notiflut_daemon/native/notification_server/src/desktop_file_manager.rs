use std::collections::HashMap;

use freedesktop_desktop_entry::{default_paths, DesktopEntry, Iter};
use std::fs;

#[derive(Debug)]
pub struct DesktopFileManager {
    data: HashMap<String, DesktopFile>,
}

impl DesktopFileManager {
    pub fn new() -> Self {
        let mut data = HashMap::new();

        Iter::new(default_paths()).for_each(|path_buf| {
            let path = path_buf.as_path().clone();
            if let Ok(bytes) = fs::read_to_string(&path) {
                if let Ok(entry) = DesktopEntry::decode(&path, &bytes) {
                    let filename = path
                        .file_name()
                        .unwrap()
                        .to_os_string()
                        .into_string()
                        .unwrap();
                    data.insert(
                        filename,
                        DesktopFile {
                            icon: entry.icon().map(|s| s.to_string()),
                        },
                    );
                }
            }
        });
        Self { data }
    }

    pub fn get(&self, name: &str) -> Option<DesktopFile> {
        self.data.get(name).cloned()
    }

    pub fn find(&self, name: &str) -> Option<DesktopFile> {
        for (key, val) in self.data.iter() {
            if key.contains(name) {
                return Some(val.clone());
            }
        }
        None
    }
}

#[derive(Debug, Clone)]
pub struct DesktopFile {
    pub icon: Option<String>,
}

#[cfg(test)]
mod test {
    use super::*;

    #[test]
    fn test() {
        let d = DesktopFileManager::new();
        let entry = d.get("google-chrome.desktop");
        // println!("{entry:?}");
        // println!("{d:?}");
    }
}

mod api;
mod bridge_generated;
mod dbus;
mod dbus_definition;
mod deamon;
mod desktop_file_manager;
mod notification;

#[cfg(test)]
mod test {
    use crate::desktop_file_manager::DesktopFileManager;

    #[test]
    fn test() {
        let d = DesktopFileManager::new();
        let entry = d.get("google-chrome.desktop");
        println!("{entry:?}");
        println!("{d:?}");
    }
}

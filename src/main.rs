use std::{time::Duration, sync::{Arc, Mutex}};

mod dbus;

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let stop_server = Arc::new(Mutex::new(false));
    let stop_server_copy = Arc::clone(&stop_server);
    ctrlc::set_handler(move || {
        println!("received Ctrl+C!");
        let mut stop_server = stop_server_copy.lock().unwrap();
        *stop_server = true;
    })
    .expect("Error setting Ctrl-C handler");

    let (sdr, _recv) = std::sync::mpsc::channel();
    let mut dbus_server = dbus::DbusServer::init()?;

    dbus_server.register_notification_handler(sdr)?;
    while !*stop_server.lock().unwrap() {
       dbus_server.wait_and_process(Duration::from_secs(1))?;
    }
    Ok(())
}

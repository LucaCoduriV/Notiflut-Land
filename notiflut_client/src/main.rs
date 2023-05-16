mod dbus_client;
fn main() {
    println!("Hello, world!");
    let client = dbus_client::DbusClient::init().unwrap();
    client.open_nc().unwrap();
    // client.close_nc().unwrap();
}

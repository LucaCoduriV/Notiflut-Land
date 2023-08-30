use clap::Parser;
use cli::Commands;

mod cli;
mod dbus_client;
mod dto;

fn main() -> anyhow::Result<()> {
    let cli = cli::Cli::parse();
    let dbus_client = dbus_client::DbusClient::init()?;

    let status = dto::Status {
        text: "text",
        alt: "notification",
        tooltip: false,
        class: "class",
        percentage: 10,
    };

    let result = match &cli.command {
        Commands::Show => dbus_client.show_nc()?,
        Commands::Hide => dbus_client.hide_nc()?,
        Commands::Toggle => dbus_client.toggle_nc()?,
        Commands::Status => serde_json::to_string(&status)?,
    };

    println!("{}", result);

    Ok(())
}

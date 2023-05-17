use clap::Parser;
use cli::Commands;

mod cli;
mod dbus_client;

fn main() -> anyhow::Result<()> {
    let cli = cli::Cli::parse();
    let dbus_client = dbus_client::DbusClient::init()?;

    let result = match &cli.command {
        Commands::Show => dbus_client.show_nc()?,
        Commands::Hide => dbus_client.hide_nc()?,
    };

    println!("{}", result);

    Ok(())
}

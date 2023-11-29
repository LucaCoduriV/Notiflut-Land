use clap::Parser;
use cli::Commands;

mod cli;
mod dbus_client;
mod dto;

fn main() -> anyhow::Result<()> {
    let cli = cli::Cli::parse();
    let dbus_client = dbus_client::DbusClient::init()?;

    let result = match &cli.command {
        Commands::Show => dbus_client.show_nc()?,
        Commands::Hide => dbus_client.hide_nc()?,
        Commands::Toggle => dbus_client.toggle_nc()?,
        Commands::Status => {
            let notification_count = dbus_client.get_notification_count()?;
            let alt = match notification_count {
                n if n < 10 => n.to_string(),
                _ => "more".to_string(),
            };
            let percentage = notification_count.saturating_mul(10).clamp(0, 100) as u32;

            let status = dto::Status {
                text: &notification_count.to_string(),
                alt: &alt,
                tooltip: false,
                class: if notification_count > 0 { "active" } else { "" },
                percentage,
            };
            serde_json::to_string(&status)?
        }
        Commands::Count => dbus_client.get_notification_count()?.to_string(),
    };

    println!("{}", result);

    Ok(())
}

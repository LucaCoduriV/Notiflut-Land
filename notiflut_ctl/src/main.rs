use std::{path::Path, sync::mpsc::channel};

use clap::Parser;
use cli::Commands;
use notify::{RecursiveMode, Watcher};

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
        Commands::Reload { watch: true } => {
            let (sndr, recv) = channel::<()>();
            let mut watcher = notify::recommended_watcher(move |res| match res {
                Ok(_event) => {
                    sndr.send(()).unwrap();
                }
                Err(e) => println!("watch error: {:?}", e),
            })?;
            watcher.watch(
                Path::new("/home/luca/.config/notiflut"),
                RecursiveMode::Recursive,
            )?;
            for _ in recv.iter() {
                println!("{}", dbus_client.reload().unwrap());
            }

            "Watch end".to_string()
        }
        Commands::Reload { watch: false } => dbus_client.reload()?.to_string(),
    };

    println!("{}", result);

    Ok(())
}

use clap::{Parser, Subcommand};

#[derive(Parser)]
#[command(author, version, about, long_about = None)]
#[command(propagate_version = true)]
pub struct Cli {
    #[command(subcommand)]
    pub command: Commands,
}

#[derive(Subcommand)]
pub enum Commands {
    /// Shows the notification center
    Show,
    /// Hides the notification center
    Hide,
    /// Toggle the notification center
    Toggle,
    /// Get notifications status
    Status,
    /// get notifications count
    Count,
    /// reload configs
    Reload,
}

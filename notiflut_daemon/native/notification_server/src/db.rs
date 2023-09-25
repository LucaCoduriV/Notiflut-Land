use once_cell::sync::Lazy;
use surrealdb::{
    engine::local::{Db, File},
    Surreal,
};

static DB: Lazy<Surreal<Db>> = Lazy::new(Surreal::init);

pub async fn init_db() -> anyhow::Result<()> {
    // Connect to the database
    DB.connect::<File>("./database.db").await?;
    // Select a namespace + database
    DB.use_ns("app").use_db("data").await?;

    Ok(())
}

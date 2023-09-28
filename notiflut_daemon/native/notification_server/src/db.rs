use once_cell::sync::Lazy;
use surrealdb::{
    engine::local::{Db, File, Mem},
    Surreal,
};
use tokio::runtime::Runtime;

// pub static DB: Lazy<Surreal<Db>> = Lazy::new(Surreal::init);

// pub fn init_db() -> anyhow::Result<()> {
//     let result = std::thread::spawn(|| {
//         Runtime::new().unwrap().block_on(async {
//             // Connect to the database
//             DB.connect::<File>("/tmp/database.db").await.unwrap();
//             // Select a namespace + database
//             DB.use_ns("app").use_db("data").await.unwrap();
//         });
//     });
//
//     result.join().unwrap();
//
//     Ok(())
// }

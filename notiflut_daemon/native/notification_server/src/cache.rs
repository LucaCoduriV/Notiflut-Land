use const_format::formatcp;
use nanoid::nanoid;
use tracing::{debug, error};

const CACHE_PATH_PREFIX: &'static str = "/tmp/notiflut-";
const CACHE_PATH: &'static str = formatcp!("{}cache", CACHE_PATH_PREFIX);

pub async fn delete_file_cache(key: &str) {
    match cacache::remove(CACHE_PATH, key).await {
        Ok(_) => debug!("Notification {} deleted from cache", key),
        Err(_) => error!("Couldn't file notification {}", key),
    };
}

pub async fn load_cache(key: &str) -> String {
    let id = nanoid!();
    let filepath = format!("{}{}", CACHE_PATH_PREFIX, id);
    cacache::copy(CACHE_PATH, key, &filepath).await.unwrap();
    filepath
}

pub async fn insert_file_cache(key: &str, file_path: &str) {
    let data = tokio::fs::read(file_path).await.unwrap();
    cacache::write(CACHE_PATH, key, &data).await.unwrap();
}

pub async fn clear_cache() {
    cacache::clear(CACHE_PATH).await.unwrap();
}

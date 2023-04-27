use flutter_rust_bridge::StreamSink;
use once_cell::sync::OnceCell;

static SINK: OnceCell<StreamSink<i32>> = OnceCell::new();

pub fn main() {
    println!("Hello from native!");
}


pub fn create_sink(s: StreamSink<i32>) {
    SINK.set(s).ok();
}

pub fn generate_number() {
    if let Some(sink) = SINK.get() {
        for i in 0..10 {
            sink.add(i);
            std::thread::sleep(std::time::Duration::from_secs(1))
        }
    }
}

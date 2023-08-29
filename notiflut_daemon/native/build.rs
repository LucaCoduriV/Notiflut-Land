use lib_flutter_rust_bridge_codegen::*;
use std::error::Error;

const DART_OUTPUT: &str = "../lib/native/bridge_generated.dart";
const DART_DECL_OUTPUT: &str = "lib/native/bridge_definitions.dart";
const RUST_INPUT: &str = "src/api.rs";
const RUST_OUTPUT: &str = "src/bridge_generated/mod.rs";

fn main() -> Result<(), Box<dyn Error>> {
    // Only rerun when the API file changes.
    println!("cargo:rerun-if-changed={}", RUST_INPUT);
    let configs = config_parse(RawOpts {
        skip_add_mod_to_lib: true,
        rust_input: vec![RUST_INPUT.to_string()],
        rust_output: Some(vec![RUST_OUTPUT.to_string()]),
        dart_output: vec![DART_OUTPUT.to_string()],
        dart_decl_output: None,
        wasm: false,

        c_output: None,
        ..Default::default()
    });
    if let Ok(symbols) = get_symbols_if_no_duplicates(&configs) {
        for config in &configs {
            frb_codegen(config, &symbols).unwrap();
        }
    }
    Ok(())
}

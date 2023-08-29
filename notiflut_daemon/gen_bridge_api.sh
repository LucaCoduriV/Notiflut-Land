export CPATH="$(clang -v 2>&1 | grep "Selected GCC installation" | rev | cut -d' ' -f1 | rev)/include"
flutter_rust_bridge_codegen \
    --skip-add-mod-to-lib \
    -d lib/native/bridge_generated.dart \
    -r native/src/api.rs \
    --rust-output native/src/bridge_generated/mod.rs \

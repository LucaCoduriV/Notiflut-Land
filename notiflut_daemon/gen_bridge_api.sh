export CPATH="$(clang -v 2>&1 | grep "Selected GCC installation" | rev | cut -d' ' -f1 | rev)/include"
flutter_rust_bridge_codegen --rust-input native/src/api.rs --dart-output lib/src/native/bridge_generated.dart --dart-decl-output lib/src/native/bridge_definitions.dart

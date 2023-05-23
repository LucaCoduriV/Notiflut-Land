# Notiflut-Land [Work in progress]
## Notification Center for wayland

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

-   [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
-   [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

export CPATH="$(clang -v 2>&1 | grep "Selected GCC installation" | rev | cut -d' ' -f1 | rev)/include"

## Generate bridge code
`flutter_rust_bridge_codegen --rust-input native/src/api.rs --dart-output lib/src/native/bridge_generated.dart --dart-decl-output lib/src/native/bridge_definitions.dart`

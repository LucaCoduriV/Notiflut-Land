# Notiflut-Land [Work in progress]

This project is a notification center designed specifically for Wayland, implemented using Rust and Flutter. The notification center provides a seamless and intuitive user interface for managing and interacting with notifications on Wayland-based systems.


## Screenshots

⚠️ It's not the final look !
![App Screenshot](/images/notification_center.png)
![App Screenshot](/images/notification_popup.png)


## Features (Checked if done)

### Freedesktop specifications:

- [x] actions: The server will provide the specified actions to the user. Even if this cap is missing, actions may still be specified by the client, however the server is free to ignore them.

- [x] body: Supports body text. Some implementations may only show the summary (for instance, onscreen displays, marquee/scrollers)
- [x] body-hyperlinks:	The server supports hyperlinks in the notifications.
- [ ] body-images: The server supports images in the notifications.
- [x] body-markup: Supports markup in the body text. If marked up text is sent to a server that does not give this cap, the markup will show through as regular text so must be stripped clientside.
- [x] icon-static: Supports display of exactly 1 frame of any given image array. This value is mutually exclusive with "icon-multi", it is a protocol error for the server to specify both.
- [ ] persistence: The server supports persistence of notifications. Notifications will be retained until they are acknowledged or removed by the user or recalled by the sender. The presence of this capability allows clients to depend on the server to ensure a notification is seen and eliminate the need for the client to display a reminding function (such as a status icon) of its own.

### More
- [x] notification group
- [ ] support for waybar
- [ ] Widgets
- [ ] Media player controller
- [ ] custom styling
- [ ] Filter notifications

## Installation
### Generate bridge code
`flutter_rust_bridge_codegen --rust-input native/src/api.rs --dart-output lib/src/native/bridge_generated.dart --dart-decl-output lib/src/native/bridge_definitions.dart`
export CPATH="$(clang -v 2>&1 | grep "Selected GCC installation" | rev | cut -d' ' -f1 | rev)/include"
    
## how to use

bla bla bla


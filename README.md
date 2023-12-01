![Notiflut-Land logo](/images/notiflut-logo.png)
# Notiflut-Land [Work in progress]

This project is a notification center designed specifically for Wayland, implemented using Rust and Flutter. The notification center provides a seamless and intuitive user interface for managing and interacting with notifications on Wayland-based systems.


## Screenshots

⚠️ It's not the final look !
![Notification center sreenshot](/images/NotificationCenterExample.png)
![Notification popup screenshot](/images/notification_popup.png)


## Features (Checked if done)

### Freedesktop specifications:

- [x] actions: The server will provide the specified actions to the user. Even if this cap is missing, actions may still be specified by the client, however the server is free to ignore them.

- [x] body: Supports body text. Some implementations may only show the summary (for instance, onscreen displays, marquee/scrollers)
- [x] body-hyperlinks:	The server supports hyperlinks in the notifications.
- [x] body-images: The server supports images in the notifications.
- [x] body-markup: Supports markup in the body text. If marked up text is sent to a server that does not give this cap, the markup will show through as regular text so must be stripped clientside.
- [x] icon-static: Supports display of exactly 1 frame of any given image array. This value is mutually exclusive with "icon-multi", it is a protocol error for the server to specify both.
- [x] persistence: The server supports persistence of notifications. Notifications will be retained until they are acknowledged or removed by the user or recalled by the sender. The presence of this capability allows clients to depend on the server to ensure a notification is seen and eliminate the need for the client to display a reminding function (such as a status icon) of its own.

### More
- [x] notification group
- [x] Filter notifications
- [x] support for waybar
- [x] Media player controller
- [ ] Widgets (Maybe a bad idea)
- [ ] custom styling

## requirement
- Flutter v. > 3.0 [Download](https://docs.flutter.dev/get-started/install)
- Rust [Download](https://rustup.rs/)
- Rust in Flutter
- gtk-layer-shell

## Build daemon
First go to the right folder: `cd ./notiflut_daemon`

Then you need to generates code from protobuf with this command:
`dart run rust_in_flutter message`

This project also uses well known types for dates.
`protoc --dart_out=./lib/messages google/protobuf/timestamp.proto`

If you have any trouble running these commands look first for help here: https://docs.cunarist.com/rust-in-flutter/

Now you should be able to compile the code with: `flutter build linux --release`

Certainly! Here's an improved version of your installation guide with clearer instructions and additional details:

## Installation Guide

1. **Navigate to the Build Scripts Directory:**
   ```bash
   cd ./build_scripts
   ```

2. **Install Dependencies:**
   If the `makepkg -si` command fails due to missing dependencies, manually download and install them. You can usually find dependency information in the project documentation or README file.

3. **Build and Install Package:**
   If you have resolved the dependencies, run the following command to build and install the package:
   ```bash
   makepkg -si
   ```

   If you needed to install dependencies manually, use the following command instead:
   ```bash
   makepkg -di
   ```

   This will build the package and install it along with its dependencies.
## how to use

Once notiflut is running, use notiflut_ctl to control it.
For help menu use `notiflut_ctl -h`

## configuration
The configuration file is typically located in the default XDG configuration directory. In most cases, it should be: `$HOME/.config/notiflut/conf.toml`

### Configuration File Example
```toml
do_not_disturb = false

[[emitters_settings]]
name = "spotify"
ignore = true
urgency_low_as = "Critical"
urgency_normal_as = "Normal"
urgency_critical_as = "Low"
```
### Do Not Disturb Mode
- do_not_disturb: Set this to true to enable "Do Not Disturb" mode and suppress notifications temporarily.
### Emitter Settings
- **name**: Assign a unique name to each emitter for identification purposes.
- **ignore**: Toggle the ignore flag to true if you want to ignore notifications from a specific emitter.
- **Urgency Level Mapping (Low, Normal, Critical)**: Low -> do not persist in center, Normal -> persist in center, Critical -> persist in center + popup need user action to close.
   - urgency_low_as: Customize the behavior of low urgency notifications. In this example, it's set to "Critical," allowing you to elevate the importance of low urgency notifications.
   - urgency_normal_as: Map normal urgency notifications to a custom urgency (same as urgency low).
   - urgency_critical_as: Map critical urgency notifications to a custom urgency (same as urgency low).

## Waybar
Here is an example of a custom module that can be used with Waybar.
```json
    "custom/notification": {
      "tooltip": false,
      "format": "{icon}",
      "format-icons": {
        "0": "",
        "1": "<span foreground='red'><sup>1</sup></span>",
        "2": "<span foreground='red'><sup>2</sup></span>",
        "3": "<span foreground='red'><sup>3</sup></span>",
        "4": "<span foreground='red'><sup>4</sup></span>",
        "5": "<span foreground='red'><sup>5</sup></span>",
        "6": "<span foreground='red'><sup>6</sup></span>",
        "7": "<span foreground='red'><sup>7</sup></span>",
        "8": "<span foreground='red'><sup>8</sup></span>",
        "9": "<span foreground='red'><sup>9</sup></span>",
        "more": "<span foreground='red'><sup>9+</sup></span>"
      },
      "return-type": "json",
      "exec-if": "which notiflut_ctl",
      "exec": "notiflut_ctl status",
      "on-click": "notiflut_ctl toggle",
      "interval": 5,
      "escape": true
    }
```

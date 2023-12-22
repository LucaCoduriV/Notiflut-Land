import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:rinf/rinf.dart';
import 'package:notiflut/messages/daemon_event.pb.dart' as daemon_event;
import 'package:notiflut/messages/theme_event.pb.dart' as theme_event;
import 'package:notiflut/messages/settings_event.pb.dart' as settings_event;
import 'package:watch_it/watch_it.dart';
import 'package:wayland_multi_window/wayland_multi_window.dart';

import '../messages/daemon_event.pb.dart';
import 'mainwindow_service.dart';
import 'theme_service.dart';

class RustEventListener {
  final StreamController<RustSignal> _notificationsStream = StreamController();
  Stream<RustSignal> get notificationsStream => _notificationsStream.stream;

  RustEventListener(Stream<RustSignal> stream) {
    stream.listen(_handleEvents);
  }

  _handleEvents(RustSignal event) async {
    switch (event.resource) {
      case daemon_event.ID:
        _notificationsStream.add(event);
        break;
      case theme_event.ID:
        _handleThemeEvents(event);
        break;
      case settings_event.ID:
        _handleSettingsEvents(event);
        break;

      default:
        return;
    }
  }

  _handleThemeEvents(RustSignal event) async {
    final style =
        await compute(theme_event.Style.fromBuffer, event.message!.toList());

    final themeService = di<ThemeService>();
    final data =
        PopupSignal(style: daemon_event.Data(data: style.writeToBuffer()));
    themeService.style = style;
    WaylandMultiWindow.invokeMethod(
      1, // 1 is the id of the popup subwindow
      MainWindowEvents.newNotification.toString(),
      data.writeToBuffer(),
    );
    print("STYLE UPDATED");
  }

  _handleSettingsEvents(RustSignal event) async {
    final settingsEvent = await compute(
        settings_event.SettingsSignal.fromBuffer, event.message!.toList());
    final operation = settingsEvent.whichOperation();
    switch (operation) {
      case settings_event.SettingsSignal_Operation.theme:
        final themeService = di<ThemeService>();
        final theme = switch (settingsEvent.theme) {
          settings_event.ThemeVariante.Light => ThemeType.light,
          settings_event.ThemeVariante.Dark => ThemeType.dark,
          _ => null,
        };
        if (theme != null) {
          themeService.type = theme;
        } else {
          print("Error theme variante not existing");
        }

      case settings_event.SettingsSignal_Operation.notSet:
        break;
    }
  }
}

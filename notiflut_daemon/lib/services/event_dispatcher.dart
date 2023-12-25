import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:rinf/rinf.dart';
import 'package:notiflut/messages/daemon_event.pb.dart' as daemon_event;
import 'package:notiflut/messages/theme_event.pb.dart' as theme_event;
import 'package:notiflut/messages/settings_event.pb.dart' as settings_event;
import 'package:watch_it/watch_it.dart';
import 'package:wayland_multi_window/wayland_multi_window.dart';

import '../messages/daemon_event.pb.dart';
import 'theme_service.dart';

class StreamAdapter {
  final int eventId;
  final List<int> data;

  StreamAdapter({required this.eventId, required this.data});

  StreamAdapter.fromRustSignal(RustSignal signal)
      : eventId = signal.resource,
        data = signal.message as List<int>;
}

class EventDispatcher {
  final int? propagateToWindowId;
  final StreamController<SignalAppEvent> _notificationsStream =
      StreamController();
  Stream<SignalAppEvent> get notificationsStream => _notificationsStream.stream;

  final StreamController<theme_event.Style> _styleUpdateStream =
      StreamController();
  Stream<theme_event.Style> get styleUpdateStream => _styleUpdateStream.stream;

  final StreamController<ThemeType> _themeChangedStream = StreamController();
  Stream<ThemeType> get themeChangedStram => _themeChangedStream.stream;

  EventDispatcher(Stream<StreamAdapter> stream, {this.propagateToWindowId}) {
    stream.listen(_handleEvents);
  }

  _handleEvents(StreamAdapter event) async {
    if (propagateToWindowId != null) {
      WaylandMultiWindow.invokeMethod(
        propagateToWindowId!, // 1 is the id of the popup subwindow
        event.eventId.toString(),
        event.data,
      );
    }

    switch (event.eventId) {
      case daemon_event.ID:
        final appEvent =
            await compute(SignalAppEvent.fromBuffer, event.data.toList());
        _notificationsStream.add(appEvent);
        break;
      case theme_event.ID:
        final style =
            await compute(theme_event.Style.fromBuffer, event.data.toList());
        _styleUpdateStream.add(style);
        break;
      case settings_event.ID:
        _handleSettingsEvents(event);
        break;

      default:
        return;
    }
  }

  _handleSettingsEvents(StreamAdapter event) async {
    final settingsEvent = await compute(
        settings_event.SettingsSignal.fromBuffer, event.data.toList());

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
          _themeChangedStream.add(theme);
          themeService.type = theme;
        } else {
          print("Error theme variante not existing");
        }

      case settings_event.SettingsSignal_Operation.notSet:
        break;
    }
  }
}

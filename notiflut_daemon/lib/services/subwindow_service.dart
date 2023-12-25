import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:notiflut/services/event_dispatcher.dart';
import 'package:watch_it/watch_it.dart';
import 'package:wayland_multi_window/wayland_multi_window.dart';

import 'package:notiflut/messages/daemon_event.pb.dart' as daemon_event
    show Notification;

import '../messages/daemon_event.pb.dart';
import '../messages/google/protobuf/timestamp.pb.dart';

enum SubWindowEvents {
  invokeAction,
  notificationClosed;

  factory SubWindowEvents.fromString(String value) {
    return SubWindowEvents.values.firstWhere((e) => e.toString() == value,
        orElse: () => throw Exception("Not an element of SubWindowEvents"));
  }
}

class SubWindowService extends ChangeNotifier {
  List<(daemon_event.Notification, Timer?)> popups = [];
  bool isHidden = true;
  final int windowId;
  final LayerShellController layerController;

  SubWindowService(this.windowId)
      : layerController = LayerShellController.fromWindowId(windowId);

  void init() {
    // WaylandMultiWindow.setMethodHandler(_handleMainWindowEvents);
    di<EventDispatcher>().notificationsStream.listen(_handleEvents);
    print("init");
  }

  @override
  void dispose() {
    // WaylandMultiWindow.setMethodHandler(null);
    super.dispose();
  }

  Future<dynamic> _handleEvents(SignalAppEvent appEvent) async {
    switch (appEvent.type) {
      case SignalAppEvent_AppEventType.CloseNotification:
        break;
      case SignalAppEvent_AppEventType.HideNotificationCenter:
        break;
      case SignalAppEvent_AppEventType.PopupNotification:
        final notification = appEvent.notification;
        print("new popup");

        if (popups.isEmpty) {
          layerController.show();
        }

        final timer = switch (notification.timeout) {
          -1 => schedulePopupCleanUp(notification.id, notification.createdAt),
          0 => null,
          _ => schedulePopupCleanUp(
              notification.id,
              notification.createdAt,
              duration: Duration(milliseconds: notification.timeout),
            ),
        };

        popups.removeWhere((e) => e.$1.id == notification.id);
        popups.insert(0, (notification, timer));
        popups = List.from(popups);

        popups.sort((a, b) =>
            b.$1.createdAt.toDateTime().compareTo(a.$1.createdAt.toDateTime()));

        notifyListeners();
        break;
      case SignalAppEvent_AppEventType.ShowNotificationCenter:
        break;
      case SignalAppEvent_AppEventType.ToggleNotificationCenter:
        break;
      case SignalAppEvent_AppEventType.NewNotification:
        break;
    }
  }

  Future<void> invokeAction(int id, String action) async {
    WaylandMultiWindow.invokeMethod(
      0,
      SubWindowEvents.invokeAction.toString(),
      jsonEncode({"id": id, "action": action}),
    );
  }

  Future<void> sendCloseEvent(int id) async {
    WaylandMultiWindow.invokeMethod(
      0,
      SubWindowEvents.notificationClosed.toString(),
      jsonEncode({"id": id}),
    );
  }

  Timer schedulePopupCleanUp(
    int id,
    Timestamp date, {
    Duration duration = const Duration(seconds: 4),
  }) {
    return Timer(duration, () {
      closePopupWithDate(id, date);

      if (popups.isEmpty) {
        // TODO Understand why [PopupsList] does not resize automatically.
        if (isHidden) {
          layerController.hide();
          print("POPUP CLEAN UP HIDE WINDOW");
        }
      }
    });
  }

  void updateTimer(int id, Timer timer) {
    final index = popups.indexWhere((tuple) => tuple.$1.id == id);
    if (index != -1) {
      final tuple = popups[index];
      popups[index] = (tuple.$1, timer);
    }
  }

  void closePopupWithDate(int id, Timestamp date) {
    popups = List.from(
        popups..removeWhere(((n) => n.$1.id == id && n.$1.createdAt == date)));
    notifyListeners();

    if (popups.isEmpty) {
      layerController.hide();
    }
  }

  void closePopup(int id) {
    popups = List.from(popups..removeWhere(((n) => n.$1.id == id)));
    notifyListeners();

    if (popups.isEmpty) {
      layerController.hide();
    }
  }

  void cancelClosePopupTimer(int id) {
    final timer = popups.firstWhere((tuple) => tuple.$1.id == id).$2;
    timer?.cancel();
  }

  Future<void> setLayerSize(Size size) async {
    if (size.height <= 0 || size.width <= 0) {
      return;
    }
    await layerController.setLayerSize(size);
  }
}

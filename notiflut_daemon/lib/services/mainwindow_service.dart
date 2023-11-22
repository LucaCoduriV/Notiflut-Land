import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notiflutland/messages/daemon_event.pb.dart';
import 'package:notiflutland/messages/daemon_event.pb.dart' as daemon_event
    show Notification;
import 'package:notiflutland/messages/app_event.pb.dart' as app_event;
import 'package:notiflutland/services/subwindow_service.dart';
import 'package:window_manager/window_manager.dart';
import 'package:rinf/rinf.dart';
import 'package:wayland_multi_window/wayland_multi_window.dart';

enum MainWindowEvents {
  newNotification;

  factory MainWindowEvents.fromString(String value) {
    return MainWindowEvents.values.firstWhere((e) => e.toString() == value,
        orElse: () => throw Exception("Not an element of MainWindowEvents"));
  }
}

class MainWindowService extends ChangeNotifier {
  List<daemon_event.Notification> notifications = [];
  bool isHidden = true;

  MainWindowService() {
    rustBroadcaster.stream.listen(_handleEvents);
  }

  void init() {
    WaylandMultiWindow.setMethodHandler(_handleSubWindowEvents);
  }

  @override
  void dispose() {
    WaylandMultiWindow.setMethodHandler(null);
    super.dispose();
  }

  Future<dynamic> _handleSubWindowEvents(
    MethodCall call,
    int fromWindowId,
  ) async {
    final event = SubWindowEvents.fromString(call.method);
    final args = jsonDecode(call.arguments) as Map<String, dynamic>;

    switch (event) {
      case SubWindowEvents.invokeAction:
        invokeAction(args["id"] as int, args["action"] as String);
        break;
      case SubWindowEvents.notificationClosed:
        final notificationId = args["id"];
        closeNotification(notificationId);
    }
  }

  _handleEvents(RustSignal event) async {
    if (event.resource != app_event.ID) {
      return;
    }

    final appEvent =
        await compute(SignalAppEvent.fromBuffer, event.message!.toList());
    switch (appEvent.type) {
      case SignalAppEvent_AppEventType.ToggleNotificationCenter:
        isHidden = !isHidden;
        if (isHidden) {
          Future.delayed(const Duration(milliseconds: 300), () {
            hideWindow();
          });
        } else {
          showWindow();
        }
        break;
      case SignalAppEvent_AppEventType.HideNotificationCenter:
        isHidden = true;
        hideWindow();
        notifyListeners();
        break;
      case SignalAppEvent_AppEventType.ShowNotificationCenter:
        isHidden = false;
        notifyListeners();
        Future.delayed(const Duration(milliseconds: 300), () {
          showWindow();
        });
        break;
      case SignalAppEvent_AppEventType.NewNotification:
        final notification = appEvent.notification;

        if (isHidden) {
          WaylandMultiWindow.invokeMethod(
            1, // 1 is the id of the popup subwindow
            MainWindowEvents.newNotification.toString(),
            notification.writeToBuffer(),
          );
        }

        if (notification.id != 0) {
          notifications.removeWhere(
              (element) => element.id == notification.id);
        }

        notifications.add(notification);
        notifications.sort((a, b) =>
            b.createdAt.toDateTime().compareTo(a.createdAt.toDateTime()));

        notifyListeners();
        break;
      case SignalAppEvent_AppEventType.CloseNotification:
        notifications.removeWhere(
            (element) => element.id == appEvent.notificationId.toInt());
        break;
    }
  }

  Future<void> invokeAction(int id, String action) async {
    final event = app_event.AppEvent(
      type: app_event.AppEventType.ActionInvoked,
      data: action,
      notificationId: id,
    );
    final request = RustRequest(
      resource: app_event.ID,
      operation: RustOperation.Create,
      message: event.writeToBuffer(),
    );
    final response = await requestToRust(request);
    if (response.successful) {
      print("Action invoked with success");
    } else {
      print("Action invoked with error");
    }
  }

  void closeNotification(int id) {
    notifications = List.from(notifications..removeWhere(((n) => n.id == id)));
    notifyListeners();
  }

  Future<void> setWindowSize(Size size) async {
    if (size.height <= 0 || size.width <= 0) {
      return;
    }
    await windowManager.setLayerSize(size);
  }

  Future<void> hideWindow() async {
    await windowManager.hide();
  }

  Future<void> showWindow() async {
    await windowManager.show();
  }
}

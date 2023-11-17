import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notiflutland/messages/daemon_event.pb.dart';
import 'package:notiflutland/messages/daemon_event.pb.dart' as daemon_event
    show ID, Notification;
import 'package:notiflutland/messages/app_event.pb.dart' as app_event;
import 'package:notiflutland/window_utils.dart';
import 'package:rinf/rinf.dart';
import 'package:wayland_multi_window/wayland_multi_window.dart';

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
      MethodCall call, int fromWindowId) async {
    if (call.method == "invokeAction") {
      final args = jsonDecode(call.arguments) as Map<String, dynamic>;
      invokeAction(args["id"] as int, args["action"] as String);
    }
  }

  _handleEvents(RustSignal event) {
    if (event.resource != daemon_event.ID) {
      return;
    }

    final appEvent = SignalAppEvent.fromBuffer(event.message!.toList());
    switch (appEvent.type) {
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
      case SignalAppEvent_AppEventType.Update:
        notifications = appEvent.notifications;
        final hasNewNotification = appEvent.hasLastNotificationId();
        final id = appEvent.lastNotificationId.toInt();

        if (isHidden && hasNewNotification) {
          final notification =
              notifications.firstWhere((element) => element.id == id);

          WaylandMultiWindow.invokeMethod(
              1, "newNotification", notification.writeToBuffer());
        }

        notifications.sort((a, b) =>
            b.createdAt.toDateTime().compareTo(a.createdAt.toDateTime()));

        notifyListeners();
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
}

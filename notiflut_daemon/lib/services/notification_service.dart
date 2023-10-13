import 'dart:async';

import 'package:flutter/material.dart';
import 'package:notiflutland/messages/daemon_event.pb.dart';
import 'package:notiflutland/messages/daemon_event.pb.dart' as daemon_event
    show ID, Notification;
import 'package:notiflutland/messages/app_event.pb.dart' as app_event;
import 'package:notiflutland/messages/google/protobuf/timestamp.pb.dart';
import 'package:notiflutland/window_utils.dart';
import 'package:rust_in_flutter/rust_in_flutter.dart';

class NotificationService extends ChangeNotifier {
  List<daemon_event.Notification> notifications = [];
  List<(daemon_event.Notification, Timer)> popups = [];
  bool isHidden = true;

  NotificationService() {
    rustBroadcaster.stream.listen(_handleEvents);
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
        setWindowPosTopRight();
        notifyListeners();
        break;
      case SignalAppEvent_AppEventType.ShowNotificationCenter:
        isHidden = false;
        setWindowFullscreen();
        notifyListeners();
        Future.delayed(const Duration(milliseconds: 300), () {
          showWindow();
        });
        break;
      case SignalAppEvent_AppEventType.Update:
        notifications = appEvent.notifications;
        final hasNewNotification = appEvent.hasLastNotificationId();
        final id = appEvent.lastNotificationId.toInt();

        if (popups.isEmpty) {
          showWindow();
          print("SHOW WINDOW");
        }
        if (isHidden && hasNewNotification) {
          final notification =
              notifications.firstWhere((element) => element.id == id);
          if (notification.replacesId != 0) {
            closePopup(id);
          }
          final timer = schedulePopupCleanUp(id, notification.createdAt);
          popups.insert(0, (notification, timer));
          popups = List.from(popups);
        }

        notifications.sort((a, b) =>
            b.createdAt.toDateTime().compareTo(a.createdAt.toDateTime()));
        popups.sort((a, b) =>
            b.$1.createdAt.toDateTime().compareTo(a.$1.createdAt.toDateTime()));

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

  void closePopupWithDate(int id, Timestamp date) {
    popups = List.from(
        popups..removeWhere(((n) => n.$1.id == id && n.$1.createdAt == date)));
    notifyListeners();
  }

  void closePopup(int id) {
    popups = List.from(popups..removeWhere(((n) => n.$1.id == id)));
    notifyListeners();
  }

  void cancelClosePopup(int id) {
    final timer = popups.firstWhere((tuple) => tuple.$1.id == id).$2;
    timer.cancel();
  }

  void closeNotification(int id) {
    notifications = List.from(notifications..removeWhere(((n) => n.id == id)));
    notifyListeners();
  }

  void updateTimer(int id, Timer timer){
    final index = popups.indexWhere((tuple) => tuple.$1.id == id);
    final tuple = popups[index];
    popups[index] = (tuple.$1, timer);
  }

  Timer schedulePopupCleanUp(int id, Timestamp date) {
    return Timer(const Duration(seconds: 5), () {
      closePopupWithDate(id, date);

      if (popups.isEmpty) {
        // TODO Understand why [PopupsList] does not resize automatically.
        if (isHidden) {
          hideWindow();
          print("POPUP CLEAN UP HIDE WINDOW");
          setWindowSize(const Size(500, 2));
        }
      }
    });
  }
}

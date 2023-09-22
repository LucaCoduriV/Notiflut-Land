import 'package:flutter/material.dart';
import 'package:notiflutland/messages/daemon_event.pb.dart';
import 'package:notiflutland/messages/daemon_event.pb.dart' as daemon_event
    show ID, Notification;
import 'package:notiflutland/window_utils.dart';
import 'package:rust_in_flutter/rust_in_flutter.dart';

class NotificationService extends ChangeNotifier {
  List<daemon_event.Notification> notifications = [];
  List<daemon_event.Notification> popups = [];
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
        setWindowPosTopRight();
        hideWindow();
        notifyListeners();
        break;
      case SignalAppEvent_AppEventType.ShowNotificationCenter:
        isHidden = false;
        showWindow();
        setWindowFullscreen();
        notifyListeners();
        break;
      case SignalAppEvent_AppEventType.Update:
        notifications = appEvent.notifications;
        final index = appEvent.lastNotificationId.toInt();
        final notification = notifications[index];
        schedulePopupCleanUp();

        if (popups.isEmpty) {
          showWindow();
          print("SHOW WINDOW");
        }
        popups = List.from(popups..add(notification));
        notifyListeners();
        break;
    }
  }

  Future<void> schedulePopupCleanUp() async {
    await Future.delayed(const Duration(seconds: 5));
    popups = List.from(popups..removeLast());
    notifyListeners();

    if (popups.isEmpty) {
      // TODO Understand why [PopupsList] does not resize automatically.
      if (isHidden) {
        hideWindow();
        print("POPUP CLEAN UP HIDE WINDOW");
        setWindowSize(const Size(500, 2));
      }
    }
  }
}

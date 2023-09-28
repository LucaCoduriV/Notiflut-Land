import 'package:flutter/material.dart';
import 'package:notiflutland/messages/daemon_event.pb.dart';
import 'package:notiflutland/messages/daemon_event.pb.dart' as daemon_event
    show ID, Notification;
import 'package:notiflutland/messages/app_event.pb.dart' as app_Event;
import 'package:notiflutland/window_utils.dart';
import 'package:rust_in_flutter/rust_in_flutter.dart';

class NotificationService extends ChangeNotifier {
  List<daemon_event.Notification> notifications = [];
  List<(int, daemon_event.Notification)> popups = [];
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
        // popups = [];
        setWindowFullscreen();
        notifyListeners();
        Future.delayed(const Duration(milliseconds: 300), () {
          showWindow();
        });
        break;
      case SignalAppEvent_AppEventType.Update:
        notifications = appEvent.notifications;
        final id = appEvent.lastNotificationId.toInt();
        final notification = notifications.firstWhere((element) => element.id == id);
        final popupId = DateTime.now().millisecondsSinceEpoch;
        schedulePopupCleanUp(popupId);

        if (popups.isEmpty) {
          showWindow();
          print("SHOW WINDOW");
        }
        if (isHidden) {
          popups.insert(0, (popupId, notification));
          popups = List.from(popups);
        }
        notifyListeners();
        break;
    }
  }

  Future<void> invokeAction(String action) async {
    final event = app_Event.AppEvent(
      type: app_Event.AppEventType.ActionInvoked,
      data: action,
    );
    final request = RustRequest(
      resource: app_Event.ID,
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

  Future<void> schedulePopupCleanUp(int id) async {
    await Future.delayed(const Duration(seconds: 5));
    popups = List.from(popups..removeWhere(((n) => n.$1 == id)));
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

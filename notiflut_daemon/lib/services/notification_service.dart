import 'package:flutter/material.dart';
import 'package:notiflutland/messages/daemon_event.pb.dart';
import 'package:notiflutland/messages/daemon_event.pb.dart' as daemon_event
    show ID, Notification;
import 'package:notiflutland/window_utils.dart';
import 'package:rust_in_flutter/rust_in_flutter.dart';

class NotificationService extends ChangeNotifier{
  List<daemon_event.Notification> notifications = [];
  List<daemon_event.Notification> popups = [];
  bool isHidden = true;

  NotificationService() {
    rustBroadcaster.stream.listen(_handleEvents);
  }

  _handleEvents(RustSignal event){
      if (event.resource != daemon_event.ID) {
        return;
      }

      final appEvent = SignalAppEvent.fromBuffer(event.message!.toList());
      switch (appEvent.type) {
        case SignalAppEvent_AppEventType.HideNotificationCenter:
          isHidden = true;
          setWindowPosTopRight();
          break;
        case SignalAppEvent_AppEventType.ShowNotificationCenter:
          isHidden = false;
          setWindowFullscreen();
          break;
        case SignalAppEvent_AppEventType.Update:
          notifications = appEvent.notifications;
          final index = appEvent.lastNotificationId.toInt();
          popups.add(notifications[index]);
          break;
      }
      notifyListeners();

  }
}

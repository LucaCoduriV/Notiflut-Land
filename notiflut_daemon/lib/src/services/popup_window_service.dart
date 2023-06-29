import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../dto/notification_popup_data.dart';
import '../window_manager.dart';

class PopupWindowService extends ChangeNotifier {
  final List<NotificationPopupData> _notifications = [];
  NotificationCenterState ncState = NotificationCenterState.close;
  final LayerShellController layerController;

  /// I use this to be sure that the window was resized before showing it.
  final timeToWaitBeforeShow = 500;

  List<NotificationPopupData> get notifications => _notifications;

  PopupWindowService({required this.layerController});

  void init() {
    DesktopMultiWindow.setMethodHandler(_handleMethodCallback);
  }

  Future<dynamic> _handleMethodCallback(
    MethodCall call,
    int fromWindowId,
  ) async {
    final action = PopupWindowAction.fromString(call.method);
    switch (action) {
      case PopupWindowAction.showPopup:
        if (ncState == NotificationCenterState.open) {
          return;
        }
        final args = NotificationPopupData.fromJson(call.arguments);
        _notifications.add(args);
        // The delayed is used to hide the notification automatically after it was
        // shown.
        Future.delayed(Duration(seconds: 5, milliseconds: timeToWaitBeforeShow),
            () {
          _notifications
              .retainWhere((element) => element.summary != args.summary);
          if (_notifications.isEmpty) {
            layerController.hide();
          }
          notifyListeners();
        });
        notifyListeners();
        await Future.delayed(Duration(milliseconds: timeToWaitBeforeShow));
        layerController.show();
        break;
      case PopupWindowAction.ncStateChanged:
        ncState = NotificationCenterState.fromString(call.arguments as String);
        print(ncState);
        break;
      default:
        break;
    }
  }
}

enum NotificationCenterState {
  open,
  close;

  factory NotificationCenterState.fromString(String value) {
    return NotificationCenterState.values
        .firstWhere((element) => element.toString() == value);
  }
}

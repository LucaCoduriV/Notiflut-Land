import 'dart:async';
import 'dart:developer';

import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/material.dart';

import '../dto/image_data.dart';
import '../dto/notification_popup_data.dart';
import '../native.dart' as nati;
import '../native/bridge_definitions.dart' as nati;
import '../window_manager.dart';
import 'popup_window_service.dart';

class NotificationCenterService extends ChangeNotifier {
  List<nati.Notification> _notifications = [];
  late StreamSubscription<nati.DaemonAction> notificationStreamSub;
  bool _isHidden = false;

  List<nati.Notification> get notifications => _notifications;

  void init() {
    final notificationStream = nati.api.startDaemon();
    notificationStreamSub = notificationStream.listen(_notificationHandler);
  }

  void deinit() {
    notificationStreamSub.cancel();
  }

  void _showWindow(){
        print("show window");
        final layerController = LayerShellController.main();
        _isHidden = false;
        PopUpWindowManager().ncStateUpdate(NotificationCenterState.open);
        layerController.show();
  }

  void _hideWindow(){
        print("hide window");
        final layerController = LayerShellController.main();
        _isHidden = true;
        PopUpWindowManager().ncStateUpdate(NotificationCenterState.close);
        layerController.hide();
  }

  void _notificationHandler(nati.DaemonAction action) {
    switch (action) {
      case nati.DaemonAction_ShowNc():
        _showWindow();
      case nati.DaemonAction_CloseNc():
        _hideWindow();
      case nati.DaemonAction_ToggleNc():
        if(_isHidden){
          _showWindow();
        }else {
          _hideWindow();
        }
      case nati.DaemonAction_Update(
          field0: final notificationsNew,
          field1: final index
        ):
        _notifications = notificationsNew;

        // Send notification to popup manager
        if (index != null) {
          final notification = _notifications[index];

          ImageData? imageData = switch (notification.appImage) {
            nati.ImageSource_Data(
              field0: nati.ImageData(
                :final data,
                :final width,
                :final height,
                :final onePointTwoBitAlpha,
                :final rowstride
              )
            ) =>
              ImageData(
                data: data,
                width: width,
                height: height,
                alpha: onePointTwoBitAlpha,
                rowstride: rowstride,
              ),
            nati.ImageSource_Path(field0: final path) => ImageData(path: path),
            null => null,
          };

          ImageData? iconData = switch (notification.appIcon) {
            nati.ImageSource_Data(
              field0: nati.ImageData(
                :final data,
                :final width,
                :final height,
                :final onePointTwoBitAlpha,
                :final rowstride
              )
            ) =>
              ImageData(
                data: data,
                width: width,
                height: height,
                alpha: onePointTwoBitAlpha,
                rowstride: rowstride,
              ),
            nati.ImageSource_Path(field0: final path) => ImageData(path: path),
            null => null,
          };

          try {
            final args = NotificationPopupData(
              id: notification.id,
              summary: notification.summary,
              appName: notification.appName,
              body: notification.body,
              timeout: 5,
              icon: iconData,
              image: imageData,
              actions: notification.actions,
            );
            PopUpWindowManager().showPopUp(args.toJson());
          } catch (e) {
            log("error while parsing notification: $e");
          }
        }
      default:
    }
    notifyListeners();
  }
}

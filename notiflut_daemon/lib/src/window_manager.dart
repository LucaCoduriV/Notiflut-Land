import 'dart:async';
import 'dart:convert';

import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/services.dart';
import './native.dart' as nati;
import './native/bridge_definitions.dart' as nati;
import 'services/popup_window_service.dart';

class PopUpWindowManager {
  late LayerShellController window;

  static final PopUpWindowManager _singleton = PopUpWindowManager._internal();

  PopUpWindowManager._internal();

  factory PopUpWindowManager() {
    return _singleton;
  }

  Future<void> init() async {
    DesktopMultiWindow.setMethodHandler(_handleMethodCallback);

    window = await DesktopMultiWindow.createLayerShell(jsonEncode({}));
    window
      ..setAnchor(LayerEdge.right, true)
      ..setAnchor(LayerEdge.top, true)
      ..setLayer(LayerSurface.top)
      ..setTitle('notification-popup')
      ..setLayerSize(const Size(0.0, 0.0));
  }

  Future<void> showPopUp(dynamic message) async {
    DesktopMultiWindow.invokeMethod(
      window.windowId,
      PopupWindowAction.showPopup.toString(),
      message,
    );
  }
  
  Future<void> ncStateUpdate(NotificationCenterState state) async {
    DesktopMultiWindow.invokeMethod(
      window.windowId,
      PopupWindowAction.ncStateChanged.toString(),
      state.toString(),
    );
  }

  Future<dynamic> invokemethod(
    int windowId,
    String method, [
    dynamic args,
  ]) async {
    DesktopMultiWindow.invokeMethod(windowId, method, args);
  }

  Future<dynamic> _handleMethodCallback(
    MethodCall call,
    int fromWindowId,
  ) async {
    final action = PopupWindowAction.fromString(call.method);
    switch (action) {
      case PopupWindowAction.notificationAction:
        await nati.api.sendDaemonAction(
            action: nati.DaemonAction.flutterActionInvoked(
                call.arguments["id"], call.arguments["action"]));
        break;
      case PopupWindowAction.closeNotification:
        await nati.api.sendDaemonAction(
            action: nati.DaemonAction.flutterClose(call.arguments));
        break;
      default:
        {}
    }
  }
}

enum PopupWindowAction {
  showPopup,
  ncStateChanged,
  closeNotification,
  notificationAction;

  factory PopupWindowAction.fromString(String value) {
    return PopupWindowAction.values
        .firstWhere((element) => element.toString() == value);
  }
}

class WindowMessage {
  int fromWindowId;
  String event;
  WindowMessage(this.fromWindowId, this.event);
}

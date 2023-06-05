import 'dart:async';
import 'dart:convert';

import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/services.dart';

class PopUpWindowManager {
  late LayerShellController window;

  static final PopUpWindowManager _singleton =
      PopUpWindowManager._internal();

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
    DesktopMultiWindow.invokeMethod(window.windowId, "Show", message);
  }

  Future<dynamic> invokemethod(int windowId, String method,
      [dynamic args]) async {
    DesktopMultiWindow.invokeMethod(windowId, method, args);
  }

  Future<dynamic> _handleMethodCallback(
    MethodCall call,
    int fromWindowId,
  ) async {
    switch (call.method) {
      case "hided":
        break;
      default:
        {}
    }
  }
}

class WindowMessage {
  int fromWindowId;
  String event;
  WindowMessage(this.fromWindowId, this.event);
}

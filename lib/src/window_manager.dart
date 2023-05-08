import 'dart:async';
import 'dart:convert';

import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/services.dart';

class _PopUpWindowStatus {
  bool isAvailable = true;
  int popUpWindowId;
  _PopUpWindowStatus(this.popUpWindowId);
}

class PopUpWindowManager {
  int nbWindow;

  static final PopUpWindowManager _singleton =
      PopUpWindowManager._internal(nbWindow: 3);

  final List<_PopUpWindowStatus> _status = [];

  PopUpWindowManager._internal({required this.nbWindow});

  factory PopUpWindowManager() {
    return _singleton;
  }

  Future<void> init() async {
    DesktopMultiWindow.setMethodHandler(_handleMethodCallback);
    for (int i = 0; i < nbWindow; i++) {
      final window = await DesktopMultiWindow.createWindow(jsonEncode({}));
      window
        ..setFrame(const Offset(100, 0) & const Size(500, 80))
        ..setTitle('notification-$i');
      final status = _PopUpWindowStatus(window.windowId);
      _status.add(status);
    }
  }

  Future<WindowController> get firstAvailableWindow async {
    int? windowId;
    while (true) {
      try {
        final popupStatus = _status.firstWhere((element) => element.isAvailable);
        popupStatus.isAvailable = false;
        windowId = popupStatus.popUpWindowId;
        break;
      } catch (e) {
        await Future.delayed(const Duration(seconds: 1));
      }
    }
    WindowController controller = WindowController.fromWindowId(windowId);

    return controller;
  }

  Future<void> showPopUp(dynamic message) async {
    final windowController = await firstAvailableWindow;

    DesktopMultiWindow.invokeMethod(windowController.windowId, "Show", message);
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
        _status
            .firstWhere((element) => element.popUpWindowId == fromWindowId)
            .isAvailable = true;
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

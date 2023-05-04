import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/services.dart';

class _PopUpWindowStatus {
  bool isAvailable = true;
  int popUpWindowId;
  _PopUpWindowStatus(this.popUpWindowId);
}

class PopUpWindowManager {
  static final PopUpWindowManager _singleton =
      PopUpWindowManager._internal(nbWindow: 3);
  int nbWindow;

  final List<_PopUpWindowStatus> status = [];

  PopUpWindowManager._internal({required this.nbWindow});

  factory PopUpWindowManager() {
    return _singleton;
  }

  Future<void> init() async {
    DesktopMultiWindow.setMethodHandler(_handleMethodCallback);
    for (int i = 0; i < nbWindow; i++) {
      final window = await DesktopMultiWindow.createWindow(jsonEncode({
        'args1': 'Sub window',
        'args2': 100,
        'args3': true,
        'business': 'business_test',
      }));
      window
        ..setFrame(const Offset(100, 0) & const Size(500, 150))
        ..center()
        ..setTitle('test_flutter_russt')
        ..show();
      final status = _PopUpWindowStatus(window.windowId);
      this.status.add(status);
    }
  }

  Future<WindowController> get firstAvailableWindow async {
    int? windowId;
    while (true) {
      try {
        final popupStatus = status.firstWhere((element) => element.isAvailable);
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

  Future<dynamic> invokemethod(int windowId, String method,
      [dynamic args]) async {
    DesktopMultiWindow.invokeMethod(windowId, method, args);
  }

  Future<dynamic> _handleMethodCallback(
    MethodCall call,
    int fromWindowId,
  ) async {
    switch (call.method) {
      case "ping":
        {
          log("pong !");
        }
        break;
      case "closed":
        {
          status
              .firstWhere((element) => element.popUpWindowId == fromWindowId)
              .isAvailable = true;
        }
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

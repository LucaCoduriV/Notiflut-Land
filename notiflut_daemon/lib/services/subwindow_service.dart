import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wayland_multi_window/wayland_multi_window.dart';

import 'package:notiflutland/messages/daemon_event.pb.dart' as daemon_event
    show Notification;

import '../messages/google/protobuf/timestamp.pb.dart';

class SubWindowService extends ChangeNotifier {
  List<(daemon_event.Notification, Timer)> popups = [];
  bool isHidden = true;
  final int windowId;
  final LayerShellController layerController;

  SubWindowService(this.windowId)
      : layerController = LayerShellController.fromWindowId(windowId);

  void init() {
    WaylandMultiWindow.setMethodHandler(_handleEvents);
  }

  @override
  void dispose() {
    WaylandMultiWindow.setMethodHandler(null);
    super.dispose();
  }

  Future<dynamic> _handleEvents(MethodCall call, int fromWindowId) async {
    final data = call.arguments as List<int>;
    final notification = daemon_event.Notification.fromBuffer(data);

    print("NEW Notification !");

    if (popups.isEmpty) {
      layerController.show();
      print("SHOW WINDOW");
    }

    final timer = schedulePopupCleanUp(notification.id, notification.createdAt);
    popups.insert(0, (notification, timer));
    popups = List.from(popups);

    popups.sort((a, b) =>
        b.$1.createdAt.toDateTime().compareTo(a.$1.createdAt.toDateTime()));

    notifyListeners();
  }

  Future<void> invokeAction(int id, String action) async {
    WaylandMultiWindow.invokeMethod(
      0,
      "invokeAction",
      jsonEncode({"id": id, "action": action}),
    );
  }

  Timer schedulePopupCleanUp(int id, Timestamp date) {
    return Timer(const Duration(seconds: 5), () {
      closePopupWithDate(id, date);

      if (popups.isEmpty) {
        // TODO Understand why [PopupsList] does not resize automatically.
        if (isHidden) {
          layerController.hide();
          print("POPUP CLEAN UP HIDE WINDOW");
        }
      }
    });
  }

  void updateTimer(int id, Timer timer) {
    final index = popups.indexWhere((tuple) => tuple.$1.id == id);
    final tuple = popups[index];
    popups[index] = (tuple.$1, timer);
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

  Future<void> setWindowSize(Size size) async {
    if (size.height <= 0 || size.width <= 0) {
      return;
    }
    await layerController.setLayerSize(size);
  }
}

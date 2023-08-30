import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'services/notification_center_service.dart';
import 'services/popup_window_service.dart';
import './widgets/notification_center.dart';
import './widgets/popup_window.dart';
import './window_manager.dart';
import './native.dart' as ffi;

import 'package:window_manager/window_manager.dart';
import 'package:desktop_multi_window/desktop_multi_window.dart';

void main(List<String> args) async {
  log("App Starting...");
  WidgetsFlutterBinding.ensureInitialized();

  if (args.isNotEmpty && args.first == 'multi_window') {
    mainPopup(args);
  } else {
    mainNotificationCenter();
  }
}

void mainPopup(List<String> args) async {
  final windowId = int.parse(args[1]);
  final windowController = LayerShellController.fromWindowId(windowId);
  final argument =
      args[2].isEmpty ? const {} : jsonDecode(args[2]) as Map<String, dynamic>;

  final popupWindowService =
      PopupWindowService(layerController: windowController);
  popupWindowService.init();
  GetIt.I.registerSingleton(popupWindowService);

  runApp(PopupWindow(
    layerController: windowController,
    args: argument,
  ));
}

void mainNotificationCenter() async {
  await windowManager.ensureInitialized();
  WindowOptions windowOptions = const WindowOptions(
    size: Size(500, 600),
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
    alwaysOnTop: true,
    center: false,
  );
  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.focus();
    await windowManager.setPosition(const Offset(100, 100));
    await windowManager.hide();
  });
  await ffi.api.setup();

  final notificationCenterService = NotificationCenterService();
  notificationCenterService.init();
  GetIt.I.registerSingleton(notificationCenterService);

  final popUpWindowsManager = PopUpWindowManager();
  await popUpWindowsManager.init();
  runApp(const NotificationCenter());
}

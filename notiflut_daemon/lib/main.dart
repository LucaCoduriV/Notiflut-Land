import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:notiflut_land/src/services/notification_center_service.dart';
import './src/widgets/notification_center.dart';
import './src/widgets/popup_window.dart';
import './src/window_manager.dart';
import './src/native.dart' as nati;
// import './src/native/bridge_definitions.dart' as nati;

import 'package:window_manager/window_manager.dart';
import 'package:desktop_multi_window/desktop_multi_window.dart';

void main(List<String> args) async {
  log("App Starting...");
  WidgetsFlutterBinding.ensureInitialized();

  final notificationCenterService = NotificationCenterService();
  notificationCenterService.init();
  GetIt.I.registerSingleton(notificationCenterService);

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
  await nati.api.setup();
  final popUpWindowsManager = PopUpWindowManager();
  await popUpWindowsManager.init();
  runApp(NotificationCenter());
}

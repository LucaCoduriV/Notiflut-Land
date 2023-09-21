import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

const SMALL_WINDOW_SIZE = Size(500, 200);

Future<void> initWindowConfig() async {
  WindowOptions windowOptions = const WindowOptions(
    size: Size(800, 600),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
    windowButtonVisibility: false,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
    await windowManager.setLayer(LayerSurface.background);
    await smallResizeWindow();
  });
}

Future<void> smallResizeWindow() async {
    await windowManager.setAnchor(LayerEdge.top, true);
    await windowManager.setAnchor(LayerEdge.right, true);
    await windowManager.setAnchor(LayerEdge.left, false);
    await windowManager.setAnchor(LayerEdge.bottom, false);
    await windowManager.setLayerSize(SMALL_WINDOW_SIZE);
}

Future<void> fullscreenResizeWindow() async {
    await windowManager.setAnchor(LayerEdge.top, true);
    await windowManager.setAnchor(LayerEdge.right, true);
    await windowManager.setAnchor(LayerEdge.left, true);
    await windowManager.setAnchor(LayerEdge.bottom, true);
}

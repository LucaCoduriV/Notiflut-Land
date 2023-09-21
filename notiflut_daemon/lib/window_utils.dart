import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

const SMALL_WINDOW_SIZE = Size(500, 1);

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
    await setWindowPosTopRight();
  });
}

Future<void> setWindowPosTopRight() async {
    await windowManager.setAnchor(LayerEdge.top, true);
    await windowManager.setAnchor(LayerEdge.right, true);
    await windowManager.setAnchor(LayerEdge.left, false);
    await windowManager.setAnchor(LayerEdge.bottom, false);
    await windowManager.setLayerSize(SMALL_WINDOW_SIZE);
}

Future<void> setWindowSize(Size size) async {
    await windowManager.setLayerSize(size);
}

Future<void> setWindowFullscreen() async {
    await windowManager.setAnchor(LayerEdge.top, true);
    await windowManager.setAnchor(LayerEdge.right, true);
    await windowManager.setAnchor(LayerEdge.left, true);
    await windowManager.setAnchor(LayerEdge.bottom, true);
    // Random size to be sure the window is rendered
    await windowManager.setLayerSize(const Size(2,2));
}

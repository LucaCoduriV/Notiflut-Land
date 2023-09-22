import 'dart:ui';

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
    await setWindowPosTopRight();
  });
}

Future<void> setWindowPosTopRight() async {
    await windowManager.setAnchor(LayerEdge.top, true);
    await windowManager.setAnchor(LayerEdge.right, true);
    await windowManager.setAnchor(LayerEdge.left, false);
    await windowManager.setAnchor(LayerEdge.bottom, false);
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
    await windowManager.setLayerSize(const Size(1000,500));
}


Future<void> hideWindow() async {
// I Don't know why but hidding the layer with the hide methods makes the app sometimes crash
// So for now I resize the layer to 500 by 2 pixels so we can't see it.
  await windowManager.setLayerSize(const Size(500,2));
  await windowManager.setLayer(LayerSurface.background);
}

Future<void> showWindow() async {
// Same as above
  await windowManager.setLayer(LayerSurface.top);
}

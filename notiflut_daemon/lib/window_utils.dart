import 'dart:async';

import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

const _smallWindowSize = Size(500, 200);
bool _top = true;
bool _bottom = true;
bool _left = true;
bool _right = true;

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
    await windowManager.setMinimumSize(_smallWindowSize);
    await windowManager.show();
    await windowManager.focus();
    await windowManager.setLayer(LayerSurface.top);
    await setWindowPosTopRight();
  });
}

Future<void> setWindowPosTopRight() async {
  _top = true;
  _bottom = false;
  _right = true;
  _left = false;
}

Future<void> setWindowSize(Size size) async {
  if (size.height <= 0 || size.width <= 0) {
    return;
  }
  await windowManager.setLayerSize(size);
}

Future<void> setWindowFullscreen() async {
  _top = true;
  _bottom = true;
  _right = true;
  _left = true;
  // Random size to be sure the window is rendered
  await windowManager.setLayerSize(const Size(1000, 500));
}

Future<void> hideWindow() async {
  await Future.wait([
    windowManager.setAnchor(LayerEdge.top, _top),
    windowManager.setAnchor(LayerEdge.right, _right),
    windowManager.setAnchor(LayerEdge.left, _left),
    windowManager.setAnchor(LayerEdge.bottom, _bottom),
  ]);
  await windowManager.hide();
}

Future<void> showWindow() async {
  await Future.wait([
    windowManager.setAnchor(LayerEdge.top, _top),
    windowManager.setAnchor(LayerEdge.right, _right),
    windowManager.setAnchor(LayerEdge.left, _left),
    windowManager.setAnchor(LayerEdge.bottom, _bottom),
  ]);
  await windowManager.show();
}

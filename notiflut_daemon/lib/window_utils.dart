import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wayland_multi_window/wayland_multi_window.dart' as w;
import 'package:window_manager/window_manager.dart';

const _smallWindowSize = Size(500, 200);

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
    await windowManager.setLayer(LayerSurface.top);
    await windowManager.setAnchor(LayerEdge.top, true);
    await windowManager.setAnchor(LayerEdge.right, true);
    await windowManager.setAnchor(LayerEdge.left, true);
    await windowManager.setAnchor(LayerEdge.bottom, true);
  });
}

Future<w.LayerShellController> initPopupsLayer() async{
    final window = await w.WaylandMultiWindow.createLayerShell("");
    window
      ..setTitle('Notification popup')
      ..setLayer(w.LayerSurface.top)
      ..setAnchor(w.LayerEdge.top, true)
      ..setAnchor(w.LayerEdge.right, true)
      ..setAnchor(w.LayerEdge.left, false)
      ..setAnchor(w.LayerEdge.bottom, false)
      ..setLayerSize(_smallWindowSize)
      ..show();

      return window;
}

Future<void> setWindowSize(Size size) async {
  if (size.height <= 0 || size.width <= 0) {
    return;
  }
  await windowManager.setLayerSize(size);
}

Future<void> hideWindow() async {
  await windowManager.hide();
}

Future<void> showWindow() async {
  await windowManager.show();
}

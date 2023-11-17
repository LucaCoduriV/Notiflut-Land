import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wayland_multi_window/wayland_multi_window.dart' as w;
import 'package:window_manager/window_manager.dart';

const _smallWindowSize = Size(500, 200);

Future<void> setupMainWindow() async {
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

Future<w.LayerShellController> setupSubWindow() async{
    final window = await w.WaylandMultiWindow.createLayerShell("");
    window
      ..setTitle('Notification popup')
      ..setLayer(w.LayerSurface.top)
      ..setAnchor(w.LayerEdge.top, true)
      ..setAnchor(w.LayerEdge.right, true)
      ..setAnchor(w.LayerEdge.left, false)
      ..setAnchor(w.LayerEdge.bottom, false)
      ..setLayerSize(_smallWindowSize)
      ..hide();

      return window;
}


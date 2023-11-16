import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:notiflutland/services/notification_service.dart';
import 'package:notiflutland/widgets/notification_center.dart';
import 'package:notiflutland/widgets/popups_list.dart';
import 'package:notiflutland/window_utils.dart';
import 'package:rinf/rinf.dart';
import 'package:wayland_multi_window/wayland_multi_window.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  if (args.firstOrNull != 'multi_window') {
    await Rinf.ensureInitialized();
    initWindowConfig();
    GetIt.I.registerSingleton(NotificationService());
  }else{
    // final windowId = int.parse(args[1]);
    // final window = LayerShellController.fromWindowId(windowId);
    // window.show();
  }

  if (args.firstOrNull == 'multi_window') {
    runApp(const MaterialApp(home: Text("coucou")));
  } else {
    final window = await WaylandMultiWindow.createLayerShell(jsonEncode({
      'args1': 'Sub window',
      'args2': 100,
      'args3': true,
      'bussiness': 'bussiness_test',
    }));
    window
      ..setTitle('Another window')
      ..setLayer(LayerSurface.overlay)
      ..setAnchor(LayerEdge.top, true)
      ..setAnchor(LayerEdge.right, true)
      ..setAnchor(LayerEdge.left, true)
      ..setAnchor(LayerEdge.bottom, true)
      ..setLayerSize(Size(1,1))
      ..show();
    runApp(MyApp());
  }
}

class MyApp extends StatelessWidget with GetItMixin {
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    bool isNotiCenterHidden = watchOnly((NotificationService s) => s.isHidden);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notiflut-Land',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        backgroundColor: isNotiCenterHidden
            ? Colors.transparent
            : Colors.black.withOpacity(0.1),
        body: isNotiCenterHidden ? PopupsList() : NotificationCenter(),
      ),
    );
  }
}

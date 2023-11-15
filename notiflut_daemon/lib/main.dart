import 'dart:convert';

import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:notiflutland/services/notification_service.dart';
import 'package:notiflutland/widgets/notification_center.dart';
import 'package:notiflutland/widgets/popups_list.dart';
import 'package:notiflutland/window_utils.dart';
import 'package:rinf/rinf.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  if (args.firstOrNull != 'multi_window') {
    await Rinf.ensureInitialized();
    initWindowConfig();
    GetIt.I.registerSingleton(NotificationService());
  }

  if (args.firstOrNull == 'multi_window') {
    runApp(const MaterialApp(home: Text("coucou")));
  } else {
    final window = await DesktopMultiWindow.createWindow(jsonEncode({
      'args1': 'Sub window',
      'args2': 100,
      'args3': true,
      'bussiness': 'bussiness_test',
    }));
    window
      ..setFrame(const Offset(0, 0) & const Size(1280, 720))
      ..center()
      ..setTitle('Another window')
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

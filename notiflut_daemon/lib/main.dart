import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:notiflutland/services/notification_service.dart';
import 'package:notiflutland/widgets/notification_center.dart';
import 'package:notiflutland/widgets/popups_list.dart';
import 'package:notiflutland/window_utils.dart';
import 'package:rust_in_flutter/rust_in_flutter.dart';

void main(List<String> args) async {
  await RustInFlutter.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  initWindowConfig();

  GetIt.I.registerSingleton(NotificationService());

  runApp(MyApp());
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

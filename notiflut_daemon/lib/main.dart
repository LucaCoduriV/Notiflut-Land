import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:notiflutland/services/notification_service.dart';
import 'package:notiflutland/widgets/notification_list.dart';
import 'package:notiflutland/window_utils.dart';
import 'package:rust_in_flutter/rust_in_flutter.dart';

void main(List<String> args) async {
  await RustInFlutter.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  initWindowConfig();

  GetIt.I.registerSingleton(NotificationService());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    debugShowCheckedModeBanner: false,
      title: 'Notiflut-Land',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        backgroundColor: Colors.white,
        body: NotificationList(),
        ),
    );
  }
}

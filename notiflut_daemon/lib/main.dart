import 'package:flutter/material.dart';
import 'package:notiflutland/services/mainwindow_service.dart';
import 'package:notiflutland/services/mediaplayer_service.dart';
import 'package:notiflutland/services/subwindow_service.dart';
import 'package:notiflutland/widgets/notification_center.dart';
import 'package:notiflutland/widgets/popups_list.dart';
import 'package:notiflutland/window_utils.dart';
import 'package:rinf/rinf.dart';
import 'package:watch_it/watch_it.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  final isMainWindow = args.firstOrNull != 'multi_window';

  if (isMainWindow) {
    await Rinf.ensureInitialized();
    setupMainWindow();
    di.registerSingleton(MainWindowService());
    di.registerSingleton(MediaPlayerService());
    await setupSubWindow();
    runApp(const MainWindow());
  } else {
    final windowId = int.parse(args[1]);
    di.registerSingleton(SubWindowService(windowId));
    runApp(const SubWindow());
  }
}

class MainWindow extends StatefulWidget {
  const MainWindow({super.key});

  @override
  State<MainWindow> createState() => _MainWindowState();
}

class _MainWindowState extends State<MainWindow> {
  @override
  void initState() {
    di.get<MainWindowService>().init();
    super.initState();
  }

  @override
  void dispose() {
    di.get<MainWindowService>().dispose();
    super.dispose();
  }

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
        backgroundColor: Colors.black.withOpacity(0.1),
        body: NotificationCenter(),
      ),
    );
  }
}

class SubWindow extends StatefulWidget {
  const SubWindow({super.key});

  @override
  State<SubWindow> createState() => _SubWindowState();
}

class _SubWindowState extends State<SubWindow> {
  @override
  void initState() {
    di.get<SubWindowService>().init();
    super.initState();
  }

  @override
  dispose() {
    di.get<SubWindowService>().dispose();
    super.dispose();
  }

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
        backgroundColor: Colors.transparent,
        body: PopupsList(),
      ),
    );
  }
}

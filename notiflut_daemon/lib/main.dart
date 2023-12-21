import 'package:flutter/material.dart';
import 'package:notiflut/services/mainwindow_service.dart';
import 'package:notiflut/services/mediaplayer_service.dart';
import 'package:notiflut/services/rust_event_listener.dart';
import 'package:notiflut/services/subwindow_service.dart';
import 'package:notiflut/widgets/notification_center.dart';
import 'package:notiflut/widgets/popups_list.dart';
import 'package:notiflut/window_utils.dart';
import 'package:rinf/rinf.dart';
import 'package:watch_it/watch_it.dart';

import 'services/theme_service.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  final isMainWindow = args.firstOrNull != 'multi_window';

  if (isMainWindow) {
    await Rinf.ensureInitialized();
    setupMainWindow();
    di.registerSingleton(MediaPlayerService()).init();
    di.registerSingleton(ThemeService());
    di.registerSingleton(RustEventListener(rustBroadcaster.stream));
    di.registerSingleton(MainWindowService());
    await setupSubWindow();
    runApp(const MainWindow());
  } else {
    final windowId = int.parse(args[1]);
    di.registerSingleton(ThemeService());
    //di.registerSingleton(RustEventListener(rustBroadcaster.stream));
    di.registerSingleton(SubWindowService(windowId));
    runApp(const SubWindow());
  }
}

class MainWindow extends StatefulWidget with WatchItStatefulWidgetMixin {
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
    final theme = watchIt<ThemeService>().theme;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notiflut-Land',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        backgroundColor: theme != null
            ? Color(theme.notificationCenterStyle.backgroundColor)
            : Colors.black.withOpacity(0.1),
        body: NotificationCenter(),
      ),
    );
  }
}

class SubWindow extends StatefulWidget with WatchItStatefulWidgetMixin {
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
    final theme = watchIt<ThemeService>().theme;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notiflut-Land',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        backgroundColor: theme != null
            ? Color(theme.popupStyle.backgroundColor)
            : Colors.transparent,
        body: PopupsList(),
      ),
    );
  }
}

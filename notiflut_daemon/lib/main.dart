import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:notiflutland/services/notification_service.dart';
import 'package:notiflutland/services/subwindow_service.dart';
import 'package:notiflutland/widgets/notification_center.dart';
import 'package:notiflutland/widgets/popups_list.dart';
import 'package:notiflutland/window_utils.dart';
import 'package:rinf/rinf.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  final isMainWindow = args.firstOrNull != 'multi_window';

  if (isMainWindow) {
    await Rinf.ensureInitialized();
    initWindowConfig();
    GetIt.I.registerSingleton(MainWindowService());
    await initPopupsLayer();
    runApp(MainWindow());
  } else {
    final windowId = int.parse(args[1]);
    GetIt.I.registerSingleton(SubWindowService(windowId));
    runApp(const SubWindow());
  }
}

class MainWindow extends StatelessWidget with GetItMixin {
  MainWindow({super.key});

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
    GetIt.I.get<SubWindowService>().init();
    super.initState();
  }

  @override
  dispose() {
    GetIt.I.get<SubWindowService>().dispose();
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

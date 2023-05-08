import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:test_flutter_russt/src/popup.dart';
import 'package:test_flutter_russt/src/window_manager.dart';
import './src/native.dart' as nati;
// import './src/native/bridge_definitions.dart' as nati;

import 'package:image/image.dart' as img;
import 'package:window_manager/window_manager.dart';
import 'package:desktop_multi_window/desktop_multi_window.dart';

Image createImage(
    int width, int height, Uint8List bytes, int channels, int rowStride) {
  final image = img.Image.fromBytes(
      width: width,
      height: height,
      bytes: bytes.buffer,
      numChannels: channels,
      rowStride: rowStride,
      order: img.ChannelOrder.rgb);
  final png = img.encodePng(image);
  return Image.memory(
    png,
    height: 100,
    width: 100,
  );
}

late final Stream<nati.DeamonAction> notificationStream;

void main(List<String> args) async {
  log("App Starting...");
  WidgetsFlutterBinding.ensureInitialized();

  if (args.isNotEmpty && args.first == 'multi_window') {
    final windowId = int.parse(args[1]);
    final windowController = WindowController.fromWindowId(windowId);
    final argument = args[2].isEmpty
        ? const {}
        : jsonDecode(args[2]) as Map<String, dynamic>;
    runApp(ExampleSubWindow(
      windowController: windowController,
      args: argument,
    ));
  } else {
    await windowManager.ensureInitialized();
    WindowOptions windowOptions = const WindowOptions(
      size: Size(500, 600),
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.hidden,
      alwaysOnTop: true,
      center: false,
    );
    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
      await windowManager.setPosition(const Offset(100, 100));
    });
    await nati.api.setup();
    notificationStream = nati.api.startDeamon();
    final popUpWindowsManager = PopUpWindowManager();
    await popUpWindowsManager.init();
    runApp(const NotificationCenter());
  }
}

WindowController? testWindowManager;

class NotificationCenter extends StatelessWidget {
  const NotificationCenter({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    windowManager.setPosition(const Offset(500, 300));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notification Center',
      theme: ThemeData(
        colorScheme: const ColorScheme.light(background: Colors.transparent),
      ),
      home: Scaffold(
        floatingActionButton: FloatingActionButton(onPressed: () async {
          PopUpWindowManager().showPopUp("hello");
        }),
        backgroundColor: const Color.fromARGB(150, 255, 255, 255),
        body: Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(
              width: 1,
              color: Colors.white,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(10),
          height: double.infinity,
          width: double.infinity,
          child: const NotificationList(),
        ),
      ),
    );
  }
}

class NotificationList extends StatefulWidget {
  const NotificationList({super.key});

  @override
  State<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  List<nati.Notification> notifications = [];

  @override
  void initState() {
    super.initState();
    notificationStream.listen((event) {
      event.whenOrNull(
        update: (notificationsNew) {
          notifications = notificationsNew;
          final imageData = notifications.last.hints.imageData;
          try {
            final args = MethodsArgument(
              positionx: 100.0,
              positiony: 100.0,
              height: 200.0,
              width: 200.0,
              summary: notifications.last.summary,
              appName: notifications.last.appName,
              body: notifications.last.body,
              iconData: imageData?.data,
              iconAlpha: imageData?.onePointTwoBitAlpha,
              iconRowstride: imageData?.rowstride,
              iconHeight: imageData?.height,
              iconWidth: imageData?.width,
              timeout: 5,
            );
            PopUpWindowManager().showPopUp(args.toJson());
          } catch (e) {}
        },
      );
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        final imageData = notification.hints.imageData;
        return NotificationTile(
          notification.id,
          notification.appName,
          notification.summary,
          onTileTap: () async {
            await nati.api.sendDeamonAction(
                action: nati.DeamonAction.clientActionInvoked(
                    notification.id, "default"));
          },
          closeAction: () async {
            await nati.api.sendDeamonAction(
                action: nati.DeamonAction.clientClose(notification.id));
            setState(() {});
          },
          actions: buildFromActionList(notification.id, notification.actions),
          imageProvider: (imageData != null)
              ? createImage(imageData.width, imageData.height, imageData.data,
                      imageData.channels, imageData.rowstride)
                  .image
              : null,
        );
      },
    );
  }
}

class NotificationAction {
  final Function() action;
  final String label;
  const NotificationAction(this.label, this.action);
}

List<NotificationAction> buildFromActionList(int id, List<String> actions) {
  List<NotificationAction> result = [];
  for (int i = 0; i < actions.length; i += 2) {
    result.add(NotificationAction(actions[i + 1], () async {
      await nati.api.sendDeamonAction(
          action: nati.DeamonAction.clientActionInvoked(id, actions[i]));
    }));
  }
  return result;
}

class NotificationTile extends StatelessWidget {
  final int id;
  final String title;
  final String subtitle;
  final ImageProvider? imageProvider;
  final Function()? onTileTap;
  final Function()? closeAction;
  final List<NotificationAction>? actions;
  const NotificationTile(this.id, this.title, this.subtitle,
      {super.key,
      this.imageProvider,
      this.closeAction,
      this.onTileTap,
      this.actions});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final buttons = actions
        ?.map((v) => ElevatedButton(onPressed: v.action, child: Text(v.label)))
        .toList();
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          ListTile(
            title: Text(title),
            onTap: onTileTap,
            subtitle: Text(subtitle),
            leading: CircleAvatar(
              backgroundImage: imageProvider,
            ),
            trailing: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: closeAction,
              child: const Icon(Icons.close),
            ),
          ),
          Row(
            children: buttons ?? [],
          ),
        ],
      ),
    );
  }
}

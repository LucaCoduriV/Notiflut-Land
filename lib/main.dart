import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:test_flutter_russt/src/native/bridge_definitions.dart';
import './src/native.dart' as nati;
// import './src/native/bridge_definitions.dart' as nati;

import 'package:image/image.dart' as img;
import 'package:window_manager/window_manager.dart';

Image createImage(int width, int height, Uint8List bytes, int channels, int rowStride){
  final image =  img.Image.fromBytes(
      width: width,
      height: height,
      bytes: bytes.buffer,
      numChannels: channels,
      rowStride: rowStride,
      order: img.ChannelOrder.rgb
      );
  final png = img.encodePng(image); 
  return Image.memory(png, height: 100, width: 100, );
}

late final Stream<nati.DeamonAction> notificationStream;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  WindowOptions windowOptions = const WindowOptions(
      size: Size(500, 600),
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.hidden,
      alwaysOnTop: true,
      );
  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
    await windowManager.setPosition(const Offset(0, 0));
  });

  await nati.api.setup();
  notificationStream = nati.api.startDeamon();

  runApp(const NotificationCenter());
}

class NotificationCenter extends StatelessWidget {
  const NotificationCenter({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    debugShowCheckedModeBanner: false,
        title: 'Notification Center',
        theme: ThemeData(
          colorScheme: const ColorScheme.light(background: Colors.transparent),
          ),
        home: Scaffold(
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
        },
      );
      setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
    itemCount: notifications.length,
    itemBuilder: (context, index){
        final notification = notifications[index];
        final imageData = notification.hints.imageData;
        return NotificationTile(
            notification.id,
            notification.appName,
            notification.summary,
            onTileTap: ()async {
              await nati.api.sendDeamonAction(action: nati.DeamonAction.clientActionInvoked(notification.id, "default"));
              },
            closeAction: () async {
              await nati.api.sendDeamonAction(action: nati.DeamonAction.clientClose(notification.id));
              setState(() {});
            },
            actions: buildFromActionList(notification.id, notification.actions),
            imageProvider: (imageData != null) ? createImage(
              imageData.width,
              imageData.height,
              imageData.data,
              imageData.channels,
              imageData.rowstride
              ).image : null,
            );
      },
    ); 
  }
}

class NotificationAction{
  final Function() action;
  final String label;
    const NotificationAction(this.label, this.action);
  }

  
List<NotificationAction> buildFromActionList(int id, List<String> actions){
  List<NotificationAction> result = [];
  for (int i = 0; i < actions.length; i += 2){
    result.add(NotificationAction(
          actions[i + 1],
          () async {
          await nati.api.sendDeamonAction(action: nati.DeamonAction.clientActionInvoked(id, actions[i]));
          }
          ));
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
  const NotificationTile(this.id, this.title, this.subtitle, {super.key, this.imageProvider, this.closeAction, this.onTileTap, this.actions});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final buttons = actions?.map((v)=> ElevatedButton(onPressed: v.action, child: Text(v.label))).toList();
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
              onTap:  closeAction,
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

import 'dart:typed_data';

import 'package:flutter/material.dart';
import './src/native.dart' as nati;
import './src/native/bridge_definitions.dart' as nati;

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
          backgroundColor: Color.fromARGB(150, 255, 255, 255),
          body: Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(
                width: 1,
                color: Colors.white,
                ),
              borderRadius: BorderRadius.circular(20),
              ),
            padding: EdgeInsets.all(10),
            height: double.infinity,
            width: double.infinity,
            child: NotificationList(title: "coucou"),
            ),
          ),
        );
  }
}

class NotificationList extends StatefulWidget {
  const NotificationList({super.key, required this.title});

  final String title;

  @override
  State<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  List<nati.Notification> notifications = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    notificationStream.listen((event) {
        event.whenOrNull(
            show: (notification) => notifications.add(notification),
            close: (id) {
              notifications.removeWhere((element) => element.id == id);
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
        final imageData = notification.hints.imageData!;
        return NotificationTile(
            notification.appName,
            notification.summary,
            imageProvider: createImage(
              imageData.width,
              imageData.height,
              imageData.data,
              imageData.channels,
              imageData.rowstride
              ).image,
            );
      },
    ); 
  }
}


class NotificationTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final ImageProvider? imageProvider;
  const NotificationTile(String title, String subtitle, {super.key, this.imageProvider}):
  subtitle = subtitle, title = title;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        leading: CircleAvatar(
          backgroundImage: imageProvider,
          ),
        trailing: InkWell(
          borderRadius: BorderRadius.circular(20),
          child: Icon(Icons.close),
          onTap: (){},
        ),
      ),
    );
  }
}

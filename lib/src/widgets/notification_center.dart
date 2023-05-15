import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import '../native.dart' as nati;
import '../utils.dart';
import '../window_manager.dart';
import 'notification.dart';
import 'popup_window.dart';

class NotificationCenter extends StatelessWidget {
  final Stream<nati.DeamonAction> notificationStream;
  const NotificationCenter(this.notificationStream, {super.key});

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
        // floatingActionButton: FloatingActionButton(onPressed: () async {
        //   PopUpWindowManager().showPopUp("hello");
        // }),
        backgroundColor: Colors.transparent,
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
          child: NotificationList(notificationStream),
        ),
      ),
    );
  }
}

class NotificationList extends StatefulWidget {
  final Stream<nati.DeamonAction> notificationStream;
  const NotificationList(this.notificationStream, {super.key});

  @override
  State<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  List<nati.Notification> notifications = [];

  @override
  void initState() {
    super.initState();
    widget.notificationStream.listen((event) {
      event.whenOrNull(
        update: (notificationsNew) {
          notifications = notificationsNew;
          final imageData = notifications.last.hints.imageData;
          try {
            final args = NotificationPopupData(
              positionx: 100.0,
              positiony: 100.0,
              height: 150.0,
              width: 500.0,
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

import 'dart:async';
import 'dart:collection';
import 'dart:developer';
import 'dart:io';

import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import '../native.dart' as nati;
import '../native/bridge_definitions.dart' as nati;
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
        body: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // all the remaning left space hides the Notification center
            Expanded(
              child: GestureDetector(
                onTap: () {
                  LayerShellController.main().hide();
                },
              ),
            ),
            Container(
              width: 500,
              decoration: const BoxDecoration(
                  color: Color(0xAA000000),
                  border: Border(
                    left: BorderSide(
                      width: 1,
                      color: Colors.white,
                    ),
                  )),
              padding: const EdgeInsets.all(10),
              height: double.infinity,
              child: NotificationList(notificationStream),
            ),
          ],
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
  Timer? timer;

  Map<String, String> actions(int id) {
    final Map<String, String> map = HashMap();
    for (int i = 0; i < notifications[id].actions.length; i += 2) {
      final actions = notifications[id].actions;
      map[actions[i]] = actions[i + 1];
    }

    return map;
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      setState(() {});
    });

    widget.notificationStream.listen((event) {
      event.whenOrNull(
        showNc: () {
          print("show window");
          final layerController = LayerShellController.fromWindowId(0);
          layerController.show();
        },
        closeNc: () {
          print("hide window");
          final layerController = LayerShellController.fromWindowId(0);
          layerController.hide();
        },
        update: (notificationsNew) {
          notifications = notificationsNew;

          // Send notification to popup manager
          final imageData = notifications.last.hints.imageData;
          final iconData = notifications.last.hints.iconData;
          try {
            final args = NotificationPopupData(
              id: notifications.last.id,
              summary: notifications.last.summary,
              appName: notifications.last.appName,
              body: notifications.last.body,
              iconData: imageData?.data ?? iconData?.data,
              iconAlpha: imageData?.onePointTwoBitAlpha ??
                  iconData?.onePointTwoBitAlpha,
              iconRowstride: imageData?.rowstride ?? iconData?.rowstride,
              iconHeight: imageData?.height ?? iconData?.height,
              iconWidth: imageData?.width ?? iconData?.width,
              timeout: 5,
              iconPath: notifications.last.hints.imagePath ??
                  (notifications.last.icon.isNotEmpty
                      ? notifications.last.icon
                      : null),
            );
            PopUpWindowManager().showPopUp(args.toJson());
          } catch (e) {
            log("error while parsing notification: $e");
          }
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
        final imageData =
            notification.hints.imageData ?? notification.hints.iconData;
        final path = notification.hints.imagePath ?? notification.icon;

        ImageProvider<Object>? imageProvider;
        if (imageData != null) {
          imageProvider = createImageIiibiiay(imageData.width, imageData.height,
                  imageData.data, imageData.channels, imageData.rowstride)
              .image;
        } else if (path.isNotEmpty) {
          imageProvider = Image.file(File(path)).image;
        }
        return NotificationTile(
          notification.id,
          notification.appName,
          notification.summary,
          createdAt: notification.createdAt,
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
          actions: buildFromActionList(notification.id, actions(index)),
          imageProvider: imageProvider,
        );
      },
    );
  }
}

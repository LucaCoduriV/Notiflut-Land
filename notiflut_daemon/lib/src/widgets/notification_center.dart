import 'dart:async';
import 'dart:collection';
import 'dart:developer';
import 'dart:io';

import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:notiflut_land/src/widgets/category.dart';
import 'package:window_manager/window_manager.dart';

import '../native.dart' as nati;
import '../native/bridge_definitions.dart' as nati;
import '../utils.dart';
import '../window_manager.dart';
import 'notification.dart';
import 'popup_window.dart';

class NotificationCenter extends StatelessWidget {
  final Stream<nati.DaemonAction> notificationStream;
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
        backgroundColor: Colors.transparent,
        body: Bar(notificationStream: notificationStream),
      ),
    );
  }
}

class Bar extends StatelessWidget {
  const Bar({
    super.key,
    required this.notificationStream,
  });

  final Stream<nati.DaemonAction> notificationStream;

  @override
  Widget build(BuildContext context) {
    return Row(
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
        Card(
          color: Colors.transparent,
          child: SizedBox(
            width: 500,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  OutlinedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50), // NEW
                    ),
                    child: const Text("Close all"),
                    onPressed: () {
                      print("Notifications closed");

                      nati.api.sendDaemonAction(
                        action: const nati.DaemonAction.flutterCloseAll(),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: NotificationList(notificationStream),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class NotificationList extends StatefulWidget {
  final Stream<nati.DaemonAction> notificationStream;
  const NotificationList(this.notificationStream, {super.key});

  @override
  State<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  List<nati.Notification> notifications = [];
  Timer? timer;
  StreamSubscription<nati.DaemonAction>? notificationStreamSub;

  Map<String, String> actions(nati.Notification notification) {
    final Map<String, String> map = HashMap();
    for (int i = 0; i < notification.actions.length; i += 2) {
      final actions = notification.actions;
      map[actions[i]] = actions[i + 1];
    }

    return map;
  }

  @override
  void dispose() {
    timer?.cancel();
    notificationStreamSub?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      setState(() {});
    });

    notificationStreamSub = widget.notificationStream.listen((event) {
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
        update: (notificationsNew, index) {
          notifications = notificationsNew;

          // Send notification to popup manager
          if (index != null) {
            final notification = notifications[index];

            ImageData? imageData;
            notification.appImage?.when(data: (d) {
              imageData = ImageData(
                data: d.data,
                width: d.width,
                height: d.height,
                alpha: d.onePointTwoBitAlpha,
                rowstride: d.rowstride,
              );
            }, path: (p) {
              imageData = ImageData(path: p);
            });

            ImageData? iconData;
            notification.appIcon?.when(data: (d) {
              iconData = ImageData(
                data: d.data,
                width: d.width,
                height: d.height,
                alpha: d.onePointTwoBitAlpha,
                rowstride: d.rowstride,
              );
            }, path: (p) {
              iconData = ImageData(path: p);
            });

            try {
              final args = NotificationPopupData(
                id: notification.id,
                summary: notification.summary,
                appName: notification.appName,
                body: notification.body,
                timeout: 5,
                icon: iconData,
                image: imageData,
              );
              PopUpWindowManager().showPopUp(args.toJson());
            } catch (e) {
              log("error while parsing notification: $e");
            }
          }
        },
      );
      setState(() {});
    });
  }

  NotificationTile buildNotificationTile(
    BuildContext context,
    nati.Notification notification,
  ) {
    ImageData? imageData;
    notification.appImage?.when(data: (d) {
      imageData = ImageData(
        data: d.data,
        width: d.width,
        height: d.height,
        alpha: d.onePointTwoBitAlpha,
        rowstride: d.rowstride,
      );
    }, path: (p) {
      imageData = ImageData(path: p);
    });

    ImageData? iconData;
    notification.appIcon?.when(data: (d) {
      iconData = ImageData(
        data: d.data,
        width: d.width,
        height: d.height,
        alpha: d.onePointTwoBitAlpha,
        rowstride: d.rowstride,
      );
    }, path: (p) {
      iconData = ImageData(path: p);
    });

    ImageProvider<Object>? imageProvider;
    if (imageData?.data != null) {
      imageProvider = createImageIiibiiay(
        imageData!.width!,
        imageData!.height!,
        imageData!.data!,
        3,
        imageData!.rowstride!,
      ).image;
    } else if (imageData?.path != null && imageData!.path!.isNotEmpty) {
      imageProvider = Image.file(File(imageData!.path!)).image;
    }

    ImageProvider<Object>? iconProvider;
    if (iconData?.data != null) {
      iconProvider = createImageIiibiiay(
        iconData!.width!,
        iconData!.height!,
        iconData!.data!,
        3,
        iconData!.rowstride!,
      ).image;
    } else if (iconData?.path != null && iconData!.path!.isNotEmpty) {
      iconProvider = Image.file(File(iconData!.path!)).image;
    }
    return NotificationTile(
      notification.id,
      notification.appName,
      notification.summary,
      notification.body,
      createdAt: notification.createdAt,
      onTileTap: () async {
        await nati.api.sendDaemonAction(
            action: nati.DaemonAction.flutterActionInvoked(
                notification.id, "default"));
      },
      closeAction: () async {
        await nati.api.sendDaemonAction(
            action: nati.DaemonAction.flutterClose(notification.id));
      },
      actions: buildFromActionList(notification.id, actions(notification)),
      imageProvider: imageProvider,
      iconProvider: iconProvider,
    );
  }

  @override
  Widget build(BuildContext context) {
    final notificationByCategory =
        notifications.fold(<String, List<nati.Notification>>{}, (map, element) {
      map.putIfAbsent(element.appName, () => []);
      map[element.appName]!.add(element);
      return map;
    });
    final keys = notificationByCategory.keys;
    final categoryWidgets = keys.map((e) {
      final notifications = notificationByCategory[e]!;

      final notificationTiles = notifications.map((e) {
        final tile = buildNotificationTile(context, e);
        return tile;
      }).toList();

      return NotificationCategory(
        key: Key(e),
        appName: e,
        children: notificationTiles,
      );
    }).toList();

    return ListView.separated(
      itemCount: categoryWidgets.length,
      separatorBuilder: (BuildContext context, int index) =>
          const SizedBox(height: 10),
      itemBuilder: (BuildContext context, int index) {
        return categoryWidgets[index];
      },
    );
  }
}

import 'dart:async';
import 'dart:io';

import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:notiflut_land/src/services/notification_center_service.dart';
import 'package:notiflut_land/src/widgets/category.dart';
import 'package:window_manager/window_manager.dart';

import '../dto/image_data.dart';
import '../native.dart' as nati;
import '../native/bridge_definitions.dart' as nati;
import '../services/popup_window_service.dart';
import '../utils.dart';
import '../window_manager.dart';
import 'notification.dart';

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
      home: const Scaffold(
        backgroundColor: Colors.transparent,
        body: Bar(),
      ),
    );
  }
}

class Bar extends StatelessWidget {
  const Bar({
    super.key,
  });

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
              PopUpWindowManager().ncStateUpdate(NotificationCenterState.close);
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
                    child: NotificationList(),
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

class NotificationList extends StatefulWidget with GetItStatefulWidgetMixin {
  NotificationList({super.key});

  @override
  State<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList>
    with GetItStateMixin {
  Timer? timer;

  @override
  void dispose() {
    timer?.cancel();
    get<NotificationCenterService>().dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // Used to refresh notification up time.
    // TODO stop the timer when the Notification center is hidden.
    timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      setState(() {});
    });
  }

  NotificationTile buildNotificationTile(
    BuildContext context,
    nati.Notification notification,
  ) {
    ImageData? imageData = switch (notification.appImage) {
      nati.ImageSource_Data(
        field0: nati.ImageData(
          :final data,
          :final width,
          :final height,
          :final onePointTwoBitAlpha,
          :final rowstride
        )
      ) =>
        ImageData(
          data: data,
          width: width,
          height: height,
          alpha: onePointTwoBitAlpha,
          rowstride: rowstride,
        ),
      nati.ImageSource_Path(field0: final path) => ImageData(path: path),
      null => null,
    };

    ImageData? iconData = switch (notification.appIcon) {
      nati.ImageSource_Data(
        field0: nati.ImageData(
          :final data,
          :final width,
          :final height,
          :final onePointTwoBitAlpha,
          :final rowstride
        )
      ) =>
        ImageData(
          data: data,
          width: width,
          height: height,
          alpha: onePointTwoBitAlpha,
          rowstride: rowstride,
        ),
      nati.ImageSource_Path(field0: final path) => ImageData(path: path),
      null => null,
    };

    ImageProvider<Object>? imageProvider =
        switch ((imageData?.data, imageData?.path)) {
      (null, final path?) when path.isNotEmpty => Image.file(File(path)).image,
      (_?, _) => createImageIiibiiay(
          imageData!.width!,
          imageData.height!,
          imageData.data!,
          imageData.alpha! ? 4 : 3,
          imageData.rowstride!,
        ).image,
      (_, _) => null,
    };

    ImageProvider<Object>? iconProvider =
        switch ((iconData?.data, iconData?.path)) {
      (null, final path?) when path.isNotEmpty => Image.file(File(path)).image,
      (_?, _) => createImageIiibiiay(
          iconData!.width!,
          iconData.height!,
          iconData.data!,
          iconData.alpha! ? 4 : 3,
          iconData.rowstride!,
        ).image,
      (_, _) => null,
    };

    final appName = notification.appName.capitalize();

    return NotificationTile(
      notification.id,
      appName,
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
      actions:
          buildFromActionList(notification.id, actions(notification.actions)),
      imageProvider: imageProvider,
      iconProvider: iconProvider,
    );
  }

  @override
  Widget build(BuildContext context) {
    final notifications =
        watchOnly((NotificationCenterService s) => s.notifications);
    // TODO sort notification by date
    final notificationByCategory = notifications
        .fold(<String, List<nati.Notification>>{}, (map, notification) {
      final key = notification.appName;

      map.putIfAbsent(key, () => []);
      map[key]!.add(notification);
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

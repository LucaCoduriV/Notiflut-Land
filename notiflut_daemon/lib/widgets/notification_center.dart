import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:notiflutland/services/notification_service.dart';
import 'package:notiflutland/messages/daemon_event.pb.dart' as daemon_event
    show Notification;

import '../utils.dart';
import 'category.dart';
import 'notification.dart';

class NotificationCenter extends StatefulWidget with GetItStatefulWidgetMixin {
  NotificationCenter({super.key});

  @override
  State<NotificationCenter> createState() => _NotificationCenterState();
}

class _NotificationCenterState extends State<NotificationCenter>
    with GetItStateMixin {
  Timer? notificationUpTimeTimer;

  @override
  void dispose() {
    notificationUpTimeTimer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    notificationUpTimeTimer =
        Timer.periodic(const Duration(seconds: 30), (timer) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final notifications = watchOnly((NotificationService s) => s.notifications);
    final notificationByCategory = notifications
        .fold(<String, List<daemon_event.Notification>>{}, (map, notification) {
      final key = notification.appName;

      map.putIfAbsent(key, () => []);
      map[key]!.add(notification);
      return map;
    });

    final keys = notificationByCategory.keys;
    final categoryWidgets = keys.map((e) {
      final notifications = notificationByCategory[e]!;

      final notificationTiles = notifications.map((n) {
        ImageProvider<Object>? imageProvider = imageRawToProvider(n.appImage);
        ImageProvider<Object>? iconeProvider = imageRawToProvider(n.appIcon);
        return NotificationTile(
          n.id,
          n.appName,
          n.summary,
          n.body,
          iconProvider: iconeProvider,
          imageProvider: imageProvider,
          createdAt: n.createdAt.toDateTime(),
          actions: actionsListToMap(n.actions)
              .map((e) => NotificationAction(e.$2, () {
                    get<NotificationService>().invokeAction(n.id, e.$1);
                    get<NotificationService>().closeNotification(n.id);
                  }))
              .toList(),
          onTileTap: () {
            get<NotificationService>().invokeAction(n.id, "default");
            get<NotificationService>().closeNotification(n.id);
          },
          closeAction: () {
            get<NotificationService>().closeNotification(n.id);
          },
        );
      }).toList();

      return NotificationCategory(
        key: Key(e),
        appName: e,
        children: notificationTiles,
      );
    }).toList();
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          constraints: const BoxConstraints(maxWidth: 500),
          height: double.infinity,
          color: Colors.transparent,
          child: ListView(
            children: categoryWidgets,
          ),
        ),
      ],
    );
  }
}

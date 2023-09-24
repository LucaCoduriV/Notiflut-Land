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

      final notificationTiles = notifications.reversed.map((e) {
        ImageProvider<Object>? imageProvider = imageRawToProvider(e.appImage);
        ImageProvider<Object>? iconeProvider = imageRawToProvider(e.appIcon);
        return NotificationTile(
          e.id,
          e.appName,
          e.summary,
          e.body,
          iconProvider: iconeProvider,
          imageProvider: imageProvider,
          createdAt: e.createdAt.toDateTime(),
          actions: actionsListToMap(e.actions)
              .map((e) => NotificationAction(e.$1, () {
                    print(e.$2);
                  }))
              .toList(),
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

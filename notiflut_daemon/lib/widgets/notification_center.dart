import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:notiflutland/services/notification_service.dart';

import '../utils.dart';
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 500,
          height: double.infinity,
          color: Colors.red,
          child: ListView(
              children: notifications.reversed.map((e) {
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
          }).toList()),
        ),
      ],
    );
  }
}

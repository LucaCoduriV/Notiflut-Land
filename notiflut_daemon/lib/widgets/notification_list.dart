import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:notiflutland/services/notification_service.dart';
import 'package:notiflutland/utils.dart';
import 'package:notiflutland/widgets/notification.dart';

class NotificationList extends StatelessWidget with GetItMixin {
  NotificationList({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications =
        watchOnly((NotificationService service) => service.notifications);
    return ListView(
      children: notifications.map((e) {
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
      }).toList(),
    );
  }
}

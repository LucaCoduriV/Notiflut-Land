import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:notiflutland/messages/daemon_event.pbenum.dart';
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
        ImageProvider<Object>? imageProvider = switch(e.appImage.type.value){
          final value when value == ImageSource_ImageSourceType.Data.value => createImageIiibiiay(
              e.appImage.imageData.width,
              e.appImage.imageData.height,
              Uint8List.fromList(e.appImage.imageData.data),
              e.appImage.imageData.onePointTwoBitAlpha ? 4 : 3,
              e.appImage.imageData.rowstride,
            ).image,
          final value when value == ImageSource_ImageSourceType.Path.value && e.appImage.path.isNotEmpty => Image.file(File(e.appImage.path)).image,
          _ => null,
        };

        ImageProvider<Object>? iconeProvider = switch(e.appIcon.type.value){
          final value when value == ImageSource_ImageSourceType.Data.value => createImageIiibiiay(
              e.appIcon.imageData.width,
              e.appIcon.imageData.height,
              Uint8List.fromList(e.appImage.imageData.data),
              e.appIcon.imageData.onePointTwoBitAlpha ? 4 : 3,
              e.appIcon.imageData.rowstride,
            ).image,
          final value when value == ImageSource_ImageSourceType.Path.value && e.appIcon.path.isNotEmpty => Image.file(File(e.appIcon.path)).image,
          _ => null,
        };
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

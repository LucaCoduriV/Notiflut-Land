import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:notiflutland/services/notification_service.dart';
import 'package:notiflutland/utils.dart';
import 'package:notiflutland/widgets/notification.dart';
import 'package:notiflutland/window_utils.dart';

class NotificationList extends StatefulWidget with GetItStatefulWidgetMixin {
  NotificationList({super.key});

  @override
  State<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList>
    with GetItStateMixin {
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final notifications =
        watchOnly((NotificationService service) => service.notifications);
    resizeWindowAfterBuild();
    return ListView(
      shrinkWrap: true,
      controller: scrollController,
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
      }).toList(),
    );
  }

  Future<void> resizeWindowAfterBuild() async {
    //This delay is used to be sure that the build function is completed
    await Future.delayed(
        Duration(milliseconds: 500));
    if (scrollController.hasClients) {
      final size =
          scrollController.position.extentAfter + scrollController.position.extentInside;
      if (size != 0) {
        print("New size: $size");
        await setWindowSize(Size(500, size));
      }
    }
  }
}

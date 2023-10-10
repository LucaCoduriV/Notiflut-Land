import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:notiflutland/services/notification_service.dart';
import 'package:notiflutland/utils.dart';
import 'package:notiflutland/widgets/notification.dart';
import 'package:notiflutland/window_utils.dart';
import 'package:notiflutland/messages/daemon_event.pb.dart' as daemon_event
    show Notification;

class PopupsList extends StatefulWidget with GetItStatefulWidgetMixin {
  PopupsList({super.key});

  @override
  State<PopupsList> createState() => _PopupsListState();
}

class _PopupsListState extends State<PopupsList> with GetItStateMixin {
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final notifications =
        watchOnly((NotificationService service) => service.popups);
    resizeWindowAfterBuild();
    return ListView(
      shrinkWrap: true,
      controller: scrollController,
      children: notifications.reversed.map((n) {
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
              .where((element) => element.$1 != "default")
              .map((e) => NotificationAction(e.$2, () {
                    get<NotificationService>().invokeAction(n.id, e.$1);
                    get<NotificationService>().closePopup(n.id, n.createdAt);
                  }))
              .toList(),
          onTileTap: () {
            get<NotificationService>().invokeAction(n.id, "default");
            get<NotificationService>().closePopup(n.id, n.createdAt);
          },
          closeAction: () {
            get<NotificationService>().closePopup(n.id, n.createdAt);
          },
        );
      }).toList(),
    );
  }

  Future<void> resizeWindowAfterBuild() async {
    //This delay is used to be sure that the build function is completed
    await Future.delayed(const Duration(milliseconds: 500));
    if (scrollController.hasClients) {
      final size = scrollController.position.extentAfter +
          scrollController.position.extentInside;
      if (size > 1) {
        print("New size: $size");
        await setWindowSize(Size(500, size));
      }
    }
  }
}

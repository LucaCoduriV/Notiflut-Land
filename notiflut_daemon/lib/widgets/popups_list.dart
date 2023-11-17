import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:notiflutland/services/subwindow_service.dart';
import 'package:notiflutland/utils.dart';
import 'package:notiflutland/widgets/notification.dart';

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
        watchOnly((SubWindowService service) => service.popups);
    final notificationService = get<SubWindowService>();
    resizeWindowAfterBuild();
    return ListView(
      shrinkWrap: true,
      controller: scrollController,
      children: notifications.reversed.map((tuple) {
        final n = tuple.$1;
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
                    get<SubWindowService>().invokeAction(n.id, e.$1);
                    get<SubWindowService>()
                        .closePopupWithDate(n.id, n.createdAt);
                  }))
              .toList(),
          onTileTap: () {
            notificationService.invokeAction(n.id, "default");
            notificationService.closePopupWithDate(n.id, n.createdAt);
          },
          closeAction: () {
            notificationService.closePopupWithDate(n.id, n.createdAt);
          },
          onHover: (pointer) {
            notificationService.cancelClosePopup(n.id);
          },
          onHoverExit: (pointer) {
            final timer =
                notificationService.schedulePopupCleanUp(n.id, n.createdAt);
            notificationService.updateTimer(n.id, timer);
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
        await get<SubWindowService>().setWindowSize(Size(500, size));
      }
    }
  }
}

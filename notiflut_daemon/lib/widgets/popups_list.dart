import 'package:flutter/material.dart';
import 'package:notiflut/services/subwindow_service.dart';
import 'package:notiflut/utils.dart';
import 'package:notiflut/widgets/notification.dart';
import 'package:watch_it/watch_it.dart';

import '../services/theme_service.dart';

class PopupsList extends StatefulWidget with WatchItStatefulWidgetMixin {
  PopupsList({super.key});

  @override
  State<PopupsList> createState() => _PopupsListState();
}

class _PopupsListState extends State<PopupsList> {
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final notifications = watchIt<SubWindowService>().popups;
    final notificationService = di<SubWindowService>();
    final theme = watchIt<ThemeService>().theme;
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
                    di<SubWindowService>().invokeAction(n.id, e.$1);
                    di<SubWindowService>()
                        .closePopupWithDate(n.id, n.createdAt);
                  }))
              .toList(),
          onTileTap: () {
            notificationService.invokeAction(n.id, "default");
            notificationService.closePopupWithDate(n.id, n.createdAt);
          },
          closeAction: () {
            notificationService.closePopupWithDate(n.id, n.createdAt);
            notificationService.sendCloseEvent(n.id);
          },
          onHover: (pointer) {
            notificationService.cancelClosePopupTimer(n.id);
          },
          onHoverExit: (pointer) {
            final timer = notificationService.schedulePopupCleanUp(
              n.id,
              n.createdAt,
              duration: const Duration(seconds: 2),
            );
            notificationService.updateTimer(n.id, timer);
          },
          backgroundColor: theme != null
              ? Color(theme.notificationStyle.backgroundColor)
              : null,
          borderRadius: theme != null
              ? BorderRadius.circular(
                  theme.notificationStyle.borderRadius.toDouble())
              : null,
          bodyTextColor: theme != null
              ? Color(theme.notificationStyle.bodyTextColor)
              : null,
          titleTextColor: theme != null
              ? Color(theme.notificationStyle.titleTextColor)
              : null,
          subtitleTextColor: theme != null
              ? Color(theme.notificationStyle.subtitleTextColor)
              : null,
          buttonTextColor: theme != null
              ? Color(theme.notificationStyle.buttonTextColor)
              : null,
          borderWidth: theme?.notificationStyle.borderWidth.toDouble(),
          borderColor:
              theme != null ? Color(theme.notificationStyle.borderColor) : null,
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
        await di<SubWindowService>().setLayerSize(Size(500, size));
      }
    }
  }
}

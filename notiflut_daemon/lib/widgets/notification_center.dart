import 'dart:async';

import 'package:flutter/material.dart';
import 'package:notiflut/messages/daemon_event.pb.dart' as daemon_event
    show Notification;
import 'package:notiflut/services/cache_service.dart';
import 'package:notiflut/widgets/mediaPlayer.dart';
import 'package:watch_it/watch_it.dart';

import '../services/mainwindow_service.dart';
import '../services/mediaplayer_service.dart';
import '../services/theme_service.dart';
import '../utils.dart';
import 'category.dart';
import 'notification.dart';

class NotificationCenter extends StatefulWidget
    with WatchItStatefulWidgetMixin {
  NotificationCenter({super.key});

  @override
  State<NotificationCenter> createState() => _NotificationCenterState();
}

class _NotificationCenterState extends State<NotificationCenter> {
  Timer? notificationUpTimeTimer;
  final CacheService<String, ImageProvider<Object>> _imageCache =
      CacheService();

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
    final mainWindowService = watchIt<MainWindowService>();
    final notifications = mainWindowService.notifications;
    final theme = watchIt<ThemeService>().theme;
    final showMediaPlayer =
        watchPropertyValue((MediaPlayerService s) => s.showMediaPlayerWidget);

    final notificationByCategory = notifications
        .fold(<String, List<daemon_event.Notification>>{}, (map, notification) {
      final key = notification.appName;

      map.putIfAbsent(key, () => []);
      map[key]!.add(notification);
      return map;
    });

    final keys = notificationByCategory.keys;
    final categoryWidgets = keys.map((appName) {
      final notifications = notificationByCategory[appName]!;

      final notificationTiles = notifications.map((n) {
        ImageProvider<Object>? imageProvider = _imageCache.getOrPut(
            n.summary, () => imageRawToProvider(n.appImage));
        ImageProvider<Object>? iconeProvider = _imageCache.getOrPut(
            n.appName, () => imageRawToProvider(n.appIcon));
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
                    mainWindowService.invokeAction(n.id, e.$1);
                    mainWindowService.closeNotification(n.id);
                  }))
              .toList(),
          onTileTap: () {
            mainWindowService.invokeAction(n.id, "default");
            mainWindowService.closeNotification(n.id);
          },
          closeAction: () {
            mainWindowService.closeNotification(n.id);
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
      }).toList();

      return NotificationCategory(
        key: Key(appName),
        appName: appName,
        backgroundColor: theme != null
            ? Color(theme.notificationStyle.backgroundColor)
            : null,
        onClose: () {
          mainWindowService.closeAllAppNotifications(appName);
        },
        borderColor:
            theme != null ? Color(theme.notificationStyle.borderColor) : null,
        borderWidth: theme?.notificationStyle.borderWidth.toDouble(),
        borderRadius: theme?.notificationStyle.borderRadius.toDouble(),
        children: notificationTiles,
      );
    }).toList();

    // TODO find why there is a warning on runtime
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          width: 500,
          color: Colors.transparent,
          child: ListView(
            children: [
              if (showMediaPlayer)
                MediaPlayer(
                  borderRadius: theme != null
                      ? BorderRadius.circular(
                          theme.notificationStyle.borderRadius.toDouble())
                      : null,
                  backgroundColor: theme != null
                      ? Color(theme.notificationStyle.backgroundColor)
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
                  borderWidth: theme?.notificationStyle.borderWidth.toDouble(),
                  borderColor: theme != null
                      ? Color(theme.notificationStyle.borderColor)
                      : null,
                ),
              ...categoryWidgets
            ],
          ),
        ),
      ],
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:notiflut/messages/daemon_event.pb.dart' as daemon_event
    show Notification;
import 'package:notiflut/services/cache_service.dart';
import 'package:notiflut/widgets/mediaPlayer.dart';
import 'package:watch_it/watch_it.dart';

import '../services/mainwindow_service.dart';
import '../services/mediaplayer_service.dart';
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
    final notifications = watchIt<MainWindowService>().notifications;
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
    final categoryWidgets = keys.map((e) {
      final notifications = notificationByCategory[e]!;

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
                    di<MainWindowService>().invokeAction(n.id, e.$1);
                    di<MainWindowService>().closeNotification(n.id);
                  }))
              .toList(),
          onTileTap: () {
            di<MainWindowService>().invokeAction(n.id, "default");
            di<MainWindowService>().closeNotification(n.id);
          },
          closeAction: () {
            di<MainWindowService>().closeNotification(n.id);
          },
        );
      }).toList();

      return NotificationCategory(
        key: Key(e),
        appName: e,
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
          color: Colors.red,
          child: ListView(
            children: [
              if (showMediaPlayer) MediaPlayer(),
              ...categoryWidgets
            ],
          ),
        ),
      ],
    );
  }
}

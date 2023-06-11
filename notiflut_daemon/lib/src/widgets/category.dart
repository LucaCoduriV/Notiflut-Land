import 'package:flutter/material.dart';
import 'package:notiflut_land/src/widgets/notification.dart';

class NotificationCategory extends StatefulWidget {
  final String appName;
  final List<NotificationTile> children;
  final bool defaultState;

  const NotificationCategory({
    required this.appName,
    this.defaultState = false,
    this.children = const [],
    super.key,
  });

  @override
  State<NotificationCategory> createState() => _NotificationCategoryState();
}

class _NotificationCategoryState extends State<NotificationCategory> {
  @override
  bool _open = false;

  @override
  void initState() {
    super.initState();
    _open = widget.defaultState;
  }

  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(widget.appName),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _open = !_open;
                });
              },
              child: Text(_open ? "Show less" : "See more"),
            ),
          ],
        ),
        AnimatedCrossFade(
          firstChild: NotificationTileStack(widget.children[0]),
          secondChild: Column(children: widget.children),
          crossFadeState:
              _open ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(seconds: 1),
        ),
      ],
    );
  }
}

class NotificationTileStack extends StatelessWidget {
  final NotificationTile tile;
  const NotificationTileStack(this.tile, {super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: NotificationTile.empty(),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: NotificationTile.empty(),
        ),
        tile,
      ],
    );
  }
}

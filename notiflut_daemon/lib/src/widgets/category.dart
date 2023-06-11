import 'package:flutter/material.dart';

class NotificationCategory extends StatelessWidget {
  final String appName;
  final List<Widget> children;
  final bool open;
  final void Function(bool)? onOpen;


  const NotificationCategory({
    required this.appName,
    this.open = false,
    this.onOpen = null,
    this.children = const [],
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(appName),
            ElevatedButton(
              onPressed: () => onOpen?.call(!open),
              child: Text(open ? "Show less" : "See more"),
            ),
          ],
        ),
      ]..addAll(children),
    );
  }
}

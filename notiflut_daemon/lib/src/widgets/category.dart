import 'package:flutter/material.dart';

class NotificationCategory extends StatefulWidget {
  final String appName;
  final List<Widget> children;
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
          firstChild: const SizedBox(width: 500),
          secondChild: Column(children: widget.children),
          crossFadeState: _open
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(seconds: 1),
        ),
      ],
    );
  }
}

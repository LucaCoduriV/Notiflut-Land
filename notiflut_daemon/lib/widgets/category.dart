import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:notiflut/utils.dart';
import 'package:notiflut/widgets/notification.dart';

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
  bool _open = false;

  @override
  void initState() {
    super.initState();
    _open = widget.defaultState;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Text(
                widget.appName.capitalize(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            if (widget.children.length > 1)
              Row(
                children: [
                  ElevatedButton(
                    style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Color(0xBBE0E0E0)),
                        shape: MaterialStatePropertyAll(
                          RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                        )),
                    onPressed: () {
                      setState(() {
                        _open = !_open;
                      });
                    },
                    child: Text(_open ? "Show less" : "See more",
                        style: const TextStyle(color: Colors.black)),
                  ),
                  const SizedBox(width: 20),
                  CircleAvatar(
                    radius: 15,
                    backgroundColor: const Color(0xBBE0E0E0),
                    child: IconButton(
                      iconSize: 15,
                      icon: const Icon(
                        Icons.close,
                        color: Colors.black,
                      ),
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(width: 5),
                ],
              ),
          ],
        ),
        AnimatedCrossFade(
          firstChild: widget.children.isEmpty
              ? NotificationTile.empty()
              : NotificationTileStack(widget.children[0]),
          secondChild: Column(children: widget.children),
          crossFadeState: widget.children.length == 1
              ? CrossFadeState.showSecond
              : _open
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 300),
        ),
      ],
    );
  }
}

class NotificationTileStack extends StatelessWidget {
  final NotificationTile tile;
  const NotificationTileStack(this.tile, {super.key});

  Widget buildFakeNotificationBottomTile(BuildContext context, int lvl) {
    return Container(
      margin: EdgeInsets.fromLTRB(10 + lvl * 10, 0, 10 + lvl * 10, 0),
      decoration: const BoxDecoration(
        color: Color(0xBBE0E0E0),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 1.0,
            offset: Offset(0.0, 0.75),
            inset: true,
          )
        ],
      ),
      height: 10,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            tile,
            Column(
              children: [
                Visibility(
                  visible: false,
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  child: NotificationTile(
                    tile.id,
                    tile.appName,
                    tile.title,
                    tile.body,
                    actions: tile.actions,
                    margin: const EdgeInsets.fromLTRB(4, 4, 4, 0),
                  ),
                ),
                buildFakeNotificationBottomTile(context, 1),
                buildFakeNotificationBottomTile(context, 2),
              ],
            )
          ],
        ),
      ],
    );
  }
}

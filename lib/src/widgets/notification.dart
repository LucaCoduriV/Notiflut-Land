import 'package:flutter/material.dart';
import '../native.dart' as nati;
import '../native/bridge_definitions.dart' as nati;

class NotificationAction {
  final Function() action;
  final String label;
  const NotificationAction(this.label, this.action);
}

List<NotificationAction> buildFromActionList(
    int id, Map<String, String> actions) {
  return actions.entries
      .where((element) => element.key != "default")
      .map((entry) => NotificationAction(entry.value, () async {
            await nati.api.sendDeamonAction(
                action: nati.DeamonAction.clientActionInvoked(id, entry.key));
          }))
      .toList();
}

class NotificationTile extends StatelessWidget {
  final int id;
  final String title;
  final String subtitle;
  final ImageProvider? imageProvider;
  final Function()? onTileTap;
  final Function()? closeAction;
  final List<NotificationAction>? actions;
  final DateTime? createdAt;

  const NotificationTile(
    this.id,
    this.title,
    this.subtitle, {
    super.key,
    this.imageProvider,
    this.closeAction,
    this.onTileTap,
    this.actions,
    this.createdAt,
  });
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final buttons = actions
        ?.map((v) => TextButton(onPressed: v.action, child: Text(v.label)))
        .toList();
    String time = "";
    if (createdAt != null) {
      final Duration duration = DateTime.now().difference(createdAt!);
      if (duration.inSeconds < 60) {
        time = "Now";
      } else if (duration.inHours < 1) {
        time = "${duration.inMinutes} min. ago";
      } else if (duration.inDays < 1) {
        time = "${duration.inHours} hours ago";
      } else {
        time = "${createdAt!.day}/${createdAt!.month}";
      }
    }
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          ListTile(
            title: Text(title),
            onTap: onTileTap,
            subtitle: Text(subtitle),
            leading: CircleAvatar(
              backgroundImage: imageProvider,
            ),
            trailing: SizedBox(
              width: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(time),
                  InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: closeAction,
                    child: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: buttons ?? [],
          ),
        ],
      ),
    );
  }
}

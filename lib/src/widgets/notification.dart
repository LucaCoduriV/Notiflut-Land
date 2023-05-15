
import 'package:flutter/material.dart';
import '../native.dart' as nati;

class NotificationAction {
  final Function() action;
  final String label;
  const NotificationAction(this.label, this.action);
}

List<NotificationAction> buildFromActionList(int id, List<String> actions) {
  List<NotificationAction> result = [];
  for (int i = 0; i < actions.length; i += 2) {
    result.add(NotificationAction(actions[i + 1], () async {
      await nati.api.sendDeamonAction(
          action: nati.DeamonAction.clientActionInvoked(id, actions[i]));
    }));
  }
  return result;
}

class NotificationTile extends StatelessWidget {
  final int id;
  final String title;
  final String subtitle;
  final ImageProvider? imageProvider;
  final Function()? onTileTap;
  final Function()? closeAction;
  final List<NotificationAction>? actions;
  const NotificationTile(this.id, this.title, this.subtitle,
      {super.key,
      this.imageProvider,
      this.closeAction,
      this.onTileTap,
      this.actions});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final buttons = actions
        ?.map((v) => ElevatedButton(onPressed: v.action, child: Text(v.label)))
        .toList();
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
            trailing: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: closeAction,
              child: const Icon(Icons.close),
            ),
          ),
          Row(
            children: buttons ?? [],
          ),
        ],
      ),
    );
  }
}

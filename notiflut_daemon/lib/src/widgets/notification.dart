import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_url/open_url.dart';
import '../native.dart' as nati;
import '../native/bridge_definitions.dart' as nati;
import 'package:flutter_html/flutter_html.dart';

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
            await nati.api.sendDaemonAction(
                action: nati.DaemonAction.flutterActionInvoked(id, entry.key));
          }))
      .toList();
}

/// This function is used to render html images
ImageSourceMatcher _fileUriMatcher() => (attributes, element) {
      return attributes['src'] != null &&
          attributes['src']!.startsWith("file://");
    };

/// This function is used to render html images
ImageRender _fileUriRenderer() => (context, attributes, element) {
      String src = attributes["src"]!.replaceFirst("file://", "");
      var image = Image.file(
        File(src),
        fit: BoxFit.cover,
        width: double.infinity,
        height: 200.0,
      );
      return image;
    };

class NotificationTile extends StatelessWidget {
  final int id;
  final String appName;
  final String title;
  final String body;
  final ImageProvider? iconProvider;
  final ImageProvider? imageProvider;
  final Function()? onTileTap;
  final Function()? closeAction;
  final List<NotificationAction>? actions;
  final DateTime? createdAt;
  final EdgeInsetsGeometry? margin;

  factory NotificationTile.empty() {
    return const NotificationTile(0, "", "", "");
  }

  const NotificationTile(
    this.id,
    this.appName,
    this.title,
    this.body, {
    super.key,
    this.imageProvider,
    this.iconProvider,
    this.closeAction,
    this.onTileTap,
    this.actions,
    this.createdAt,
    this.margin,
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
      margin: margin,
      color: const Color(0xBBE0E0E0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.transparent,
                      backgroundImage: iconProvider,
                      radius: 13,
                    ),
                    const SizedBox(width: 10),
                    Text(appName, style: const TextStyle(fontSize: 13)),
                  ],
                ),
                SizedBox(
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
              ],
            ),
          ),
          ListTile(
            title: Text(title),
            onTap: onTileTap,
            subtitle: Html(
              data: body.replaceAll("\\n", "</br>"),
              customImageRenders: {
                _fileUriMatcher(): _fileUriRenderer(),
                assetUriMatcher(): assetImageRender(),
                networkSourceMatcher(extension: "svg"): svgNetworkImageRender(),
                networkSourceMatcher(): networkImageRender(),
              },
              onLinkTap: (link, context, _, element) {
                openUrl(link!);
              },
              style: {
                "body": Style(
                  margin: const EdgeInsets.all(0),
                  padding: const EdgeInsets.all(0),
                ),
                "img": Style(
                  display: Display.BLOCK,
                  width: double.infinity,
                ),
              },
            ),
            leading: CircleAvatar(
              backgroundColor: Colors.transparent,
              backgroundImage: imageProvider,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: buttons ?? [],
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}

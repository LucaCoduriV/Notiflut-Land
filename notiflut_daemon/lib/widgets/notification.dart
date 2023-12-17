import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_url/open_url.dart';
import 'package:flutter_html/flutter_html.dart';

class NotificationAction {
  final Function() action;
  final String label;

  const NotificationAction(this.label, this.action);
}

/// Transforms the list of string to list of tuple
/// We do this beacause the data received by rust is organized like that.
List<(String, String)> actionsListToMap(List<String> actionsList) {
  List<(String, String)> newList = [];

  for (int i = 0; i < actionsList.length; i += 2) {
    newList.add((actionsList[i], actionsList[i + 1]));
  }
  return newList;
}

class NotificationTile extends StatelessWidget {
  final int id;
  final String appName;
  final String title;
  final String body;
  final ImageProvider? iconProvider;
  final ImageProvider? imageProvider;
  final Function()? onTileTap;
  final Function()? closeAction;
  final Function(PointerEnterEvent)? onHover;
  final Function(PointerExitEvent)? onHoverExit;
  final List<NotificationAction>? actions;
  final DateTime? createdAt;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;

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
    this.onHover,
    this.onHoverExit,
    this.actions,
    this.createdAt,
    this.margin,
    this.backgroundColor,
    this.borderRadius,
  });
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final buttons = actions
        ?.map((v) => TextButton(
            onPressed: v.action,
            child: Text(
              v.label,
              style: const TextStyle(color: Colors.black),
            )))
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
    return MouseRegion(
      onEnter: onHover,
      onExit: onHoverExit,
      child: Card(
        surfaceTintColor: Colors.transparent,
        margin: margin,
        color: backgroundColor ?? const Color(0xBBE0E0E0),
        shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(20)),
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
                  Row(
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
                ],
              ),
            ),
            ListTile(
              title: Text(title),
              onTap: onTileTap,
              subtitle: Html(
                data: body.replaceAll("\\n", "</br>"),
                extensions: [
                  ImageExtension(
                      networkSchemas: {"file"},
                      builder: (extensionContext) {
                        final element = extensionContext.styledElement;
                        String src = element!.attributes["src"]!;
                        if (src.contains("file://")) {
                          src = src.replaceAll("file://", "");

                          final alt = element.attributes["alt"]!;
                          if (!File(src).existsSync()) {
                            return Text(alt);
                          }
                        }
                        return Image.file(
                          File(src),
                        );
                      }),
                ],
                onLinkTap: (link, context, element) {
                  openUrl(link!);
                },
                style: {
                  "a": Style(
                    color: Colors.black,
                  ),
                  // "body": Style(
                  //   margin: Margins.all(0.0),
                  //   padding: HtmlPaddings.all(0.0),
                  // ),
                  // "img": Style(
                  //   display: Display.block,
                  //   width: Width.auto(),
                  //   margin: Margins.all(0.0),
                  //   padding: HtmlPaddings.all(0.0),
                  // ),
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
      ),
    );
  }
}

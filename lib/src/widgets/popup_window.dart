import 'dart:convert';
import 'dart:developer';

import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:window_manager/window_manager.dart';

import '../utils.dart';
import 'notification.dart';

class PopupWindow extends StatefulWidget {
  const PopupWindow({
    Key? key,
    required this.layerController,
    required this.args,
  }) : super(key: key);

  final LayerShellController layerController;
  final Map? args;

  @override
  State<PopupWindow> createState() => _PopupWindowState();
}

class _PopupWindowState extends State<PopupWindow> {
  List<NotificationPopupData> datas = [];
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    DesktopMultiWindow.setMethodHandler(_handleMethodCallback);
  }

  Future<dynamic> _handleMethodCallback(
    MethodCall call,
    int fromWindowId,
  ) async {
    switch (call.method) {
      case "Show":
        final args = NotificationPopupData.fromJson(call.arguments);
        datas.add(args);
        Future.delayed(const Duration(seconds: 5), () {
          datas.retainWhere((element) => element.summary != args.summary);
          if (datas.isEmpty) {
            widget.layerController.hide();
          }
          setState(() {});
        });
        setState(() {});
        widget.layerController.show();
        break;
      default:
        {}
    }
  }

  Future<Widget> _createNotificationPopup(
      NotificationPopupData data, BuildContext context) async {
    final title = data.summary;
    final body = data.body;
    final appName = data.appName;
    ImageProvider? image;
    if (data.iconWidth != null &&
        data.iconHeight != null &&
        data.iconRowstride != null &&
        data.iconData != null &&
        data.iconAlpha != null) {
      image = createImage(
        data.iconWidth!,
        data.iconHeight!,
        data.iconData!,
        data.iconAlpha! ? 4 : 3,
        data.iconRowstride!,
      ).image;
      await precacheImage(image, context);
    }
    return NotificationTile(0, title, body, imageProvider: image);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.transparent,
        body: FutureBuilder(
          future: Future.wait(
              datas.map((e) => _createNotificationPopup(e, context)).toList()),
          builder: (context, snap) {
            executeAfterBuild();
            if (snap.data != null) {
              return ListView(
                shrinkWrap: true,
                controller: controller,
                children: snap.data!,
              );
            }
            return ListView(
              shrinkWrap: true,
              controller: controller,
            );
          },
        ),
      ),
    );
  }

  Future<void> executeAfterBuild() async {
    await Future.delayed(Duration.zero);
    if (controller.hasClients) {
      final size =
          controller.position.extentAfter + controller.position.extentInside;
      widget.layerController.setLayerSize(Size(500, size));
    }
  }
}

class NotificationPopupData {
  double positionx;
  double positiony;
  double height;
  double width;

  String summary;
  String appName;
  String body;

  Uint8List? iconData;
  int? iconHeight;
  int? iconWidth;
  int? iconRowstride;
  bool? iconAlpha;

  int timeout;

  NotificationPopupData({
    required this.positionx,
    required this.positiony,
    required this.height,
    required this.width,
    required this.summary,
    required this.appName,
    required this.body,
    required this.timeout,
    this.iconData,
    this.iconHeight,
    this.iconWidth,
    this.iconRowstride,
    this.iconAlpha,
  });

  String toJson() {
    return jsonEncode({
      "positionx": positionx,
      "positiony": positiony,
      "height": height,
      "width": width,
      "summary": summary,
      "appName": appName,
      "body": body,
      "icon-data": iconData,
      "icon-height": iconHeight,
      "icon-width": iconWidth,
      "icon-rowstride": iconRowstride,
      "icon-alpha": iconAlpha,
      "timeout": timeout,
    });
  }

  factory NotificationPopupData.fromJson(String json) {
    final args = jsonDecode(json) as Map<String, dynamic>;

    final offset =
        Offset(args['positionx'] as double, args['positiony'] as double);
    final double height = args['height'];
    final double width = args['width'];
    String title = args['summary'];
    String body = args['body'];
    String appName = args['appName'];
    int timeOut = args['timeout'];
    List<dynamic>? iconDataDyn = (args['icon-data'] as List<dynamic>?);

    Uint8List? iconData;
    if (iconDataDyn != null) {
      iconData = Uint8List.fromList(iconDataDyn.cast<int>().toList());
    }
    int? iconWidth = args['icon-width'] as int?;
    int? iconHeight = args['icon-height'] as int?;
    int? iconRowstride = args['icon-rowstride'] as int?;
    bool? iconAlpha = args['icon-alpha'] as bool?;

    return NotificationPopupData(
      timeout: timeOut,
      positiony: offset.dy,
      positionx: offset.dx,
      height: height,
      width: width,
      summary: title,
      appName: appName,
      body: body,
      iconData: iconData,
      iconWidth: iconWidth,
      iconHeight: iconHeight,
      iconRowstride: iconRowstride,
      iconAlpha: iconAlpha,
    );
  }
}

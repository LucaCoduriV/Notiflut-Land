import 'dart:convert';
import 'dart:developer';

import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_flutter_russt/main.dart';

class MethodsArgument {
  double positionx;
  double positiony;

  String summary;
  String appName;
  String body;

  Uint8List? iconData;
  int? iconHeight;
  int? iconWidth;
  int? iconRowstride;
  bool? iconAlpha;

  int timeout;

  MethodsArgument({
    required this.positionx,
    required this.positiony,
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

  factory MethodsArgument.fromJson(String json) {
    final args = jsonDecode(json) as Map<String, dynamic>;

    final offset =
        Offset(args['positionx'] as double, args['positiony'] as double);
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

    return MethodsArgument(
      timeout: timeOut,
      positiony: offset.dy,
      positionx: offset.dx,
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

class ExampleSubWindow extends StatefulWidget {
  const ExampleSubWindow({
    Key? key,
    required this.windowController,
    required this.args,
  }) : super(key: key);

  final WindowController windowController;
  final Map? args;

  @override
  State<ExampleSubWindow> createState() => _ExampleSubWindowState();
}

class _ExampleSubWindowState extends State<ExampleSubWindow> {
  String title = "";
  String body = "";
  String appName = "";
  ImageProvider? image;

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
        final args = MethodsArgument.fromJson(call.arguments);

        Future.delayed(Duration(seconds: args.timeout)).then((value) {
          DesktopMultiWindow.invokeMethod(0, "hided");
          widget.windowController.hide();
          appName = "";
          body = "";
          title = "";
          image = null;
        });

        if (args.iconWidth != null &&
            args.iconHeight != null &&
            args.iconRowstride != null &&
            args.iconData != null &&
            args.iconAlpha != null) {
          image = createImage(args.iconWidth!, args.iconHeight!, args.iconData!, args.iconAlpha! ? 4 : 3, args.iconRowstride!)
              .image;
        }
        setState(() {});
        break;
      default:
        {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color.fromARGB(150, 255, 255, 255),
        appBar: AppBar(
          title: Text(title),
        ),
        body: Column(
          children: [
            if (widget.args != null)
              Text(
                'Arguments: ${widget.args.toString()}',
                style: const TextStyle(fontSize: 20),
              ),
            OutlinedButton(
                onPressed: () {
                  widget.windowController.hide();
                },
                child: Text("CLOSE !"))
          ],
        ),
      ),
    );
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

    ImageProvider<Object>? iconProvider;
    if (data.icon?.width != null) {
      final icon = data.icon;
      iconProvider = createImageIiibiiay(icon!.width!, icon.height!, icon.data!,
              icon.alpha! ? 4 : 3, icon.rowstride!)
          .image;
    } else if (data.icon?.path != null && data.icon!.path!.isNotEmpty) {
      iconProvider = Image.file(File(data.icon!.path!)).image;
    }
    ImageProvider<Object>? imageProvider;
    if (data.image?.width != null) {
      final image = data.image;
      imageProvider = createImageIiibiiay(image!.width!, image.height!,
              image.data!, image.alpha! ? 4 : 3, image.rowstride!)
          .image;
    } else if (data.image?.path != null && data.image!.path!.isNotEmpty) {
      imageProvider = Image.file(File(data.image!.path!)).image;
    }
    if (iconProvider != null) {
      await precacheImage(iconProvider, context);
    }
    if (imageProvider != null) {
      await precacheImage(imageProvider, context);
    }

    return NotificationTile(
      0,
      appName,
      title,
      body,
      imageProvider: imageProvider,
      iconProvider: iconProvider,
    );
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

class ImageData {
  final String? path;

  final Uint8List? data;
  final int? height;
  final int? width;
  final int? rowstride;
  final bool? alpha;
  const ImageData({
    this.path,
    this.data,
    this.height,
    this.width,
    this.rowstride,
    this.alpha,
  });

  String toJson() {
    return jsonEncode({
      "image-data": data,
      "image-height": height,
      "image-width": width,
      "image-rowstride": rowstride,
      "image-alpha": alpha,
      "image-path": path,
    });
  }

  static ImageData? fromJson(String? json) {
    if (json == null) {
      return null;
    }
    final args = jsonDecode(json) as Map<String, dynamic>;

    List<dynamic>? imageDataDyn = (args['image-data'] as List<dynamic>?);
    String? imagePath = args['image-path'];

    Uint8List? imageData;
    if (imageDataDyn != null) {
      imageData = Uint8List.fromList(imageDataDyn.cast<int>().toList());
    }
    int? imageWidth = args['image-width'] as int?;
    int? imageHeight = args['image-height'] as int?;
    int? imageRowstride = args['image-rowstride'] as int?;
    bool? iconAlpha = args['image-alpha'] as bool?;

    return ImageData(
      data: imageData,
      width: imageWidth,
      height: imageHeight,
      rowstride: imageRowstride,
      alpha: iconAlpha,
      path: imagePath,
    );
  }
}

class NotificationPopupData {
  int id;

  String summary;
  String appName;
  String body;
  int timeout;
  ImageData? icon;
  ImageData? image;

  NotificationPopupData({
    required this.id,
    required this.summary,
    required this.appName,
    required this.body,
    required this.timeout,
    this.icon,
    this.image,
  });

  String toJson() {
    return jsonEncode({
      "id": id,
      "summary": summary,
      "appName": appName,
      "body": body,
      "timeout": timeout,
      "image": image?.toJson(),
      "icon": icon?.toJson(),
    });
  }

  factory NotificationPopupData.fromJson(String json) {
    final args = jsonDecode(json) as Map<String, dynamic>;

    int id = args['id'];
    String title = args['summary'];
    String body = args['body'];
    String appName = args['appName'];
    int timeOut = args['timeout'];
    ImageData? icon = ImageData.fromJson(args['icon']);
    ImageData? image = ImageData.fromJson(args['image']);

    return NotificationPopupData(
      id: id,
      timeout: timeOut,
      summary: title,
      appName: appName,
      body: body,
      image: image,
      icon: icon,
    );
  }
}

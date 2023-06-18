import 'dart:convert';
import 'dart:io';

import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notiflut_land/src/window_manager.dart';

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
  /// Contains all Notifications that are currently beeing showed.
  List<NotificationPopupData> datas = [];
  final ScrollController controller = ScrollController();
  bool doneByAfterBuild = false;

  /// I use this to be sure that the window was resized before showing it.
  final timeToWaitBeforeShow = 500;

  @override
  void initState() {
    super.initState();
    DesktopMultiWindow.setMethodHandler(_handleMethodCallback);
  }

  Future<dynamic> _handleMethodCallback(
    MethodCall call,
    int fromWindowId,
  ) async {
    final action = PopupWindowAction.fromString(call.method);
    switch (action) {
      case PopupWindowAction.showPopup:
        final args = NotificationPopupData.fromJson(call.arguments);
        datas.add(args);
        // The delayed is used to hide the notification automatically after it was
        // showed.
        Future.delayed(Duration(seconds: 5, milliseconds: timeToWaitBeforeShow),
            () {
          datas.retainWhere((element) => element.summary != args.summary);
          if (datas.isEmpty) {
            widget.layerController.hide();
          }
          setState(() {});
        });
        setState(() {});
        await Future.delayed(Duration(milliseconds: timeToWaitBeforeShow));
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
      // ignore: use_build_context_synchronously
      await precacheImage(imageProvider, context);
    }

    return NotificationTile(
      0,
      appName,
      title,
      body,
      imageProvider: imageProvider,
      iconProvider: iconProvider,
      actions: buildFromActionList(data.id, actions(data.actions)),
      onTileTap: () {
        DesktopMultiWindow.invokeMethod(
          0,
          PopupWindowAction.notificationAction.toString(),
          {
            "id": data.id,
            "action": "default",
          },
        );
      },
      closeAction: () {
        datas.removeWhere((element) => element.id == data.id);
        if (datas.isEmpty) {
          widget.layerController.hide();
        }
        setState(() {});
        DesktopMultiWindow.invokeMethod(
          0,
          PopupWindowAction.closeNotification.toString(),
          data.id,
        );
      },
    );
  }

  List<NotificationAction> buildFromActionList(
      int id, Map<String, String> actions) {
    return actions.entries
        .where((element) => element.key != "default")
        .map(
          (entry) => NotificationAction(entry.value, () async {
            print("${entry.key}: ${entry.value}");
            DesktopMultiWindow.invokeMethod(
              0,
              PopupWindowAction.notificationAction.toString(),
              {
                "id": id,
                "action": entry.key,
              },
            );
          }),
        )
        .toList();
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

  /// This function is used to resize the popup notification window to be the
  /// same height as the notification.
  /// TODO This function is a bit weird for now because I did not understand how to
  /// get the real size of a widget before showing it.
  Future<void> executeAfterBuild() async {
    await Future.delayed(Duration(milliseconds: timeToWaitBeforeShow));
    if (controller.hasClients) {
      final size =
          controller.position.extentAfter + controller.position.extentInside;
      if (size != 0) {
        print("New size: $size");
        await widget.layerController.setLayerSize(Size(500, size));
      }
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

/// This classed is used to transfer data between the main thread and
/// the thread used to show popups.
/// TODO transfer data as bytes to be faster.
class NotificationPopupData {
  int id;

  String summary;
  String appName;
  String body;
  int timeout;
  ImageData? icon;
  ImageData? image;
  List<String> actions;

  NotificationPopupData({
    required this.id,
    required this.summary,
    required this.appName,
    required this.body,
    required this.timeout,
    required this.actions,
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
      "actions": actions,
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
    List<String> actions = (args['actions'] as List).cast<String>();

    return NotificationPopupData(
      id: id,
      timeout: timeOut,
      summary: title,
      appName: appName,
      body: body,
      image: image,
      icon: icon,
      actions: actions,
    );
  }
}

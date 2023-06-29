import 'dart:io';

import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:notiflut_land/src/window_manager.dart';

import '../dto/notification_popup_data.dart';
import '../services/popup_window_service.dart';
import '../utils.dart';
import 'notification.dart';

class PopupWindow extends StatefulWidget with GetItStatefulWidgetMixin {
  PopupWindow({
    Key? key,
    required this.layerController,
    required this.args,
  }) : super(key: key);

  final LayerShellController layerController;
  final Map? args;

  @override
  State<PopupWindow> createState() => _PopupWindowState();
}

class _PopupWindowState extends State<PopupWindow> with GetItStateMixin {
  /// Contains all Notifications that are currently beeing shown.
  final ScrollController controller = ScrollController();
  bool doneByAfterBuild = false;

  @override
  void initState() {
    super.initState();
  }

  Future<Widget> _createNotificationPopup(
    NotificationPopupData data,
    List<NotificationPopupData> datas,
    BuildContext context,
  ) async {
    final title = data.summary;
    final body = data.body;
    final appName = data.appName;

    ImageProvider<Object>? imageProvider =
        switch ((data.image?.data, data.image?.path)) {
      (null, final path?) when path.isNotEmpty => Image.file(File(path)).image,
      (_?, _) => createImageIiibiiay(
          data.image!.width!,
          data.image!.height!,
          data.image!.data!,
          data.image!.alpha! ? 4 : 3,
          data.image!.rowstride!,
        ).image,
      (_, _) => null,
    };

    ImageProvider<Object>? iconProvider =
        switch ((data.icon?.data, data.icon?.path)) {
      (null, final path?) when path.isNotEmpty => Image.file(File(path)).image,
      (_?, _) => createImageIiibiiay(
          data.icon!.width!,
          data.icon!.height!,
          data.icon!.data!,
          data.icon!.alpha! ? 4 : 3,
          data.icon!.rowstride!,
        ).image,
      (_, _) => null,
    };

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
        //Send message to main window
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
        //Send message to main window
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
    final datas = watchOnly((PopupWindowService s) => s.notifications);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.transparent,
        body: FutureBuilder(
          future: Future.wait(datas
              .map((e) => _createNotificationPopup(e, datas, context))
              .toList()),
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
    await Future.delayed(
        Duration(milliseconds: get<PopupWindowService>().timeToWaitBeforeShow));
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

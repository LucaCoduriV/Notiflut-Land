import 'dart:convert';

import 'image_data.dart';

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

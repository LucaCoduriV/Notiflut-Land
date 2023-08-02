import 'package:freezed_annotation/freezed_annotation.dart';
import 'image_data.dart';

part 'notification_popup_data.freezed.dart';
part 'notification_popup_data.g.dart';

/// This classed is used to transfer data between the main thread and
/// the thread used to show popups.
/// TODO transfer data as bytes to be faster.
@freezed
class NotificationPopupData with _$NotificationPopupData {
  factory NotificationPopupData({
    required int id,
    required String summary,
    required String appName,
    required String body,
    required int timeout,
    required List<String> actions,
    ImageData? icon,
    ImageData? image,
  }) = _NotificationPopupData;

  factory NotificationPopupData.fromJson(Map<String, dynamic> json) =>
      _$NotificationPopupDataFromJson(json);

  NotificationPopupData._();

  @override
  bool operator ==(Object other) {
    return other is NotificationPopupData &&
        other.id == id &&
        other.summary == summary &&
        other.appName == appName &&
        other.body == body &&
        other.timeout == timeout &&
        other.actions == actions &&
        other.icon == icon &&
        other.image == image;
  }

  @override
  int get hashCode => Object.hash(id, summary, appName, body, timeout);
}

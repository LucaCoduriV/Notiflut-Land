// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_popup_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_NotificationPopupData _$$_NotificationPopupDataFromJson(
        Map<String, dynamic> json) =>
    _$_NotificationPopupData(
      id: json['id'] as int,
      summary: json['summary'] as String,
      appName: json['appName'] as String,
      body: json['body'] as String,
      timeout: json['timeout'] as int,
      actions:
          (json['actions'] as List<dynamic>).map((e) => e as String).toList(),
      icon: json['icon'] == null
          ? null
          : ImageData.fromJson(json['icon'] as Map<String, dynamic>),
      image: json['image'] == null
          ? null
          : ImageData.fromJson(json['image'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_NotificationPopupDataToJson(
        _$_NotificationPopupData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'summary': instance.summary,
      'appName': instance.appName,
      'body': instance.body,
      'timeout': instance.timeout,
      'actions': instance.actions,
      'icon': instance.icon,
      'image': instance.image,
    };

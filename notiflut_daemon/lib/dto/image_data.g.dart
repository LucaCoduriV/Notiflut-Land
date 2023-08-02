// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ImageData _$$_ImageDataFromJson(Map<String, dynamic> json) => _$_ImageData(
      path: json['path'] as String?,
      data: const Uint8ListConverter().fromJson(json['data'] as List<int>?),
      height: json['height'] as int?,
      width: json['width'] as int?,
      rowstride: json['rowstride'] as int?,
      alpha: json['alpha'] as bool?,
    );

Map<String, dynamic> _$$_ImageDataToJson(_$_ImageData instance) =>
    <String, dynamic>{
      'path': instance.path,
      'data': const Uint8ListConverter().toJson(instance.data),
      'height': instance.height,
      'width': instance.width,
      'rowstride': instance.rowstride,
      'alpha': instance.alpha,
    };

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:typed_data';

part 'image_data.freezed.dart';
part 'image_data.g.dart';

class Uint8ListConverter implements JsonConverter<Uint8List?, List<dynamic>?> {
  const Uint8ListConverter();

  @override
  Uint8List? fromJson(List<dynamic>? json) {
    final list = json?.cast<int>();
    return list == null ? null : Uint8List.fromList(list);
  }

  @override
  List<dynamic>? toJson(Uint8List? object) {
    return object?.toList();
  }
}

@freezed
class ImageData with _$ImageData {
  factory ImageData({
    final String? path,
    @Uint8ListConverter() final Uint8List? data,
    final int? height,
    final int? width,
    final int? rowstride,
    final bool? alpha,
  }) = _ImageData;

  factory ImageData.fromJson(Map<String, dynamic> json) =>
      _$ImageDataFromJson(json);
}

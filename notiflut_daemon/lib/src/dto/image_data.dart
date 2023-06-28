import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:typed_data';

part 'image_data.freezed.dart';
part 'image_data.g.dart';

class Uint8ListConverter implements JsonConverter<Uint8List?, List<int>?> {
  const Uint8ListConverter();

  @override
  Uint8List? fromJson(List<int>? json) {
    return json == null ? null : Uint8List.fromList(json);
  }

  @override
  List<int>? toJson(Uint8List? object) {
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

factory ImageData.fromJson(Map<String, dynamic> json) => _$ImageDataFromJson(json);
}

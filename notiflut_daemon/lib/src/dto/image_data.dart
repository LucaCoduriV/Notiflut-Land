import 'dart:convert';
import 'dart:typed_data';

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

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:notiflutland/messages/daemon_event.pb.dart' as daemon_event;
import 'package:palette_generator/palette_generator.dart';

import 'messages/daemon_event.pbenum.dart';

/// Returns an Image from raw data
Image createImageIiibiiay(
    int width, int height, Uint8List bytes, int channels, int rowStride) {
  final image = img.Image.fromBytes(
    width: width,
    height: height,
    bytes: bytes.buffer,
    numChannels: channels,
    rowStride: rowStride,
    order: img.ChannelOrder.rgb,
  );
  final encodedImage = img.encodeBmp(image);
  return Image.memory(
    encodedImage,
    height: 100,
    width: 100,
  );
}

ImageProvider? imageRawToProvider(daemon_event.ImageSource source) {
  if(!source.hasPath() && !source.hasImageData()){
   return null;
  }
  return switch (source.type.value) {
    final value when value == ImageSource_ImageSourceType.Data.value =>
      createImageIiibiiay(
        source.imageData.width,
        source.imageData.height,
        Uint8List.fromList(source.imageData.data),
        source.imageData.onePointTwoBitAlpha ? 4 : 3,
        source.imageData.rowstride,
      ).image,
    final value
        when value == ImageSource_ImageSourceType.Path.value &&
            source.path.isNotEmpty =>
      Image.file(File(source.path)).image,
    _ => null,
  };
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

Future<Color?> getDominantColor(ImageProvider provider) async {
  PaletteGenerator paletteGenerator =
      await PaletteGenerator.fromImageProvider(provider);

  return paletteGenerator.dominantColor?.color;
}

Color getContrastingColor(Color color) {
  // Adjust this threshold based on my preference
  const double threshold = 128.0;

  // Calculate the relative luminance of the color
  double luminance = 0.299 * color.red + 0.587 * color.green + 0.114 * color.blue;

  // Choose white or black text based on luminance
  return luminance > threshold ? Colors.black : Colors.white;
}

Color getContrastingTextColor(Color color) {
  // Adjust this target lightness based on my preference
  const double targetLightness = 0.5;

  HSLColor hslColor = HSLColor.fromColor(color);
  double currentLightness = hslColor.lightness;

  // Calculate the difference between the target and current lightness
  double lightnessDifference = targetLightness - currentLightness;

  // Adjust the lightness of the color
  HSLColor adjustedColor = hslColor.withLightness(currentLightness + lightnessDifference);

  return adjustedColor.toColor();
}

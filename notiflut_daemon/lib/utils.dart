import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:notiflutland/messages/daemon_event.pb.dart' as daemon_event;

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
  final png = img.encodePng(image);
  return Image.memory(
    png,
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

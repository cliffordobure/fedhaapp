import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

Future<Color?> getDominantColorFromProvider(ImageProvider imageProvider) async {
  try {
    final PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(imageProvider);
    return paletteGenerator.darkVibrantColor?.color ??
        paletteGenerator.dominantColor?.color;
  } catch (e) {
    debugPrint('Error loading image palette: $e');
    return Colors.blue[300];
  }
}

@Deprecated('Use getDominantColorFromProvider with a local AssetImage')
Future<Color?> getDominantColorFromUrl(String url) async {
  try {
    return getDominantColorFromProvider(NetworkImage(url));
  } catch (e) {
    debugPrint('Error loading image: $e');
    return Colors.blue[300];
  }
}

bool isColorLight(Color? color) {
  final luminance = color?.computeLuminance();
  return luminance != null ? luminance > 0.5 : true;
}

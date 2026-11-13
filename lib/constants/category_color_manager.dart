import 'dart:math';

import 'package:flutter/material.dart';

class CategoryColorManager {
  final Map<String, Color> _colorMap = {};
  final Random _random = Random();

  Color _generateRandomColor() {
    return Color.fromRGBO(
      _random.nextInt(256),
      _random.nextInt(256),
      _random.nextInt(256),
      1,
    );
  }

  Color getColorForCategory(String category) {
    if (!_colorMap.containsKey(category)) {
      _colorMap[category] = _generateRandomColor();
    }
    return _colorMap[category]!;
  }
}

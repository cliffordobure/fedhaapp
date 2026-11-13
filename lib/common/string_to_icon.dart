import 'package:flutter/material.dart';

/// Parses stored icon strings without creating dynamic [IconData],
/// which breaks release APK icon tree-shaking.
IconData? stringToIcon(String iconDataString,
    {String fontFamily = 'MaterialIcons'}) {
  try {
    final parts = iconDataString.split('IconData(U+');
    if (parts.length != 2) {
      throw const FormatException('Invalid IconData format');
    }

    final codePoint = parts[1].split(')')[0];
    if (!RegExp(r'^[0-9a-fA-F]+$').hasMatch(codePoint)) {
      throw const FormatException('Invalid code point format');
    }

    final code = int.parse(codePoint, radix: 16);
    for (final icon in _knownIcons) {
      if (icon.codePoint == code) return icon;
    }
    return Icons.help_outline;
  } on FormatException {
    return null;
  } catch (e) {
    return null;
  }
}

const List<IconData> _knownIcons = <IconData>[
  Icons.flag_outlined,
  Icons.home_outlined,
  Icons.help_outline,
  Icons.shopping_cart_outlined,
  Icons.directions_car_outlined,
  Icons.school_outlined,
  Icons.savings_outlined,
  Icons.favorite_outline,
  Icons.account_balance_wallet_outlined,
];

import 'package:flutter/material.dart';

extension HexColor on Color {
  String get toHex => value.toRadixString(16).substring(2);

  static Color? fromString(String code) {
    try {
      final buffer = StringBuffer();
      if (code.length == 6 || code.length == 7) buffer.write('ff');
      buffer.write(code.replaceFirst('#', ''));
      return Color(int.parse('$buffer', radix: 16));
    } catch (error) {
      debugPrint('[Cast error]: error when convert from $code to Color');
      return null;
    }
  }
}

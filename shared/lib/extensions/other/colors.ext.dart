import 'dart:ui';

import 'package:flutter/material.dart';

extension HexColor on Color {
  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String get toHex => '#${value.toRadixString(16)}';
}

extension StringToHex on String {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  Color get toColor {
    String str =
        (length == 7 && codeUnitAt(0) == 35) ? replaceFirst('#', '') : this;
    if (str.length == 6) str = 'ff$str';
    return Color(int.parse(str, radix: 16));
  }
}

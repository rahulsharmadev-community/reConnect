import 'package:flutter/material.dart';
import 'package:shared/shared.dart';
import 'app_theme_data.dart';

class AppTheme {
  final AppThemeData dark, light;
  const AppTheme({
    required this.dark,
    required this.light,
  });

  Duration get animDelay => 300.milliseconds;
  Duration get autoScrollDelay => 1000.milliseconds;

  BorderRadius messageBorderRadius(
    bool isTopLeft,
    bool isbottomRight,
    double curved,
  ) =>
      BorderRadius.only(
        topLeft: Radius.circular(isTopLeft ? 2 : curved),
        topRight: Radius.circular(curved),
        bottomRight: Radius.circular(isbottomRight ? 2 : curved),
        bottomLeft: Radius.circular(curved),
      );
}

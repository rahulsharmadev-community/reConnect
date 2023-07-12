import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

abstract class AppUiUxSetup {
  static Duration get animDelay => 300.milliseconds;
  static Duration get autoScrollDelay => 1000.milliseconds;

  static BorderRadius messageBorderRadius(
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
  static roundedBorder([double value = 16]) =>
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(value));

  static InputDecorationTheme inputDecorationTheme({
    required Color focus,
    required Color unfocus,
    required Color error,
    required Color disable,
  }) {
    var radius = BorderRadius.circular(8);
    return InputDecorationTheme(
        isDense: true,
        focusColor: focus,
        floatingLabelStyle: TextStyle(color: focus),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: unfocus), borderRadius: radius),
        disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: disable), borderRadius: radius),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: focus), borderRadius: radius),
        focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: error), borderRadius: radius),
        errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: error), borderRadius: radius));
  }
}

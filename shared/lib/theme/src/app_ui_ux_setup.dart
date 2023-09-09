part of 'app_theme_data.dart';

class AppDecoration {
  Duration get animDelay => Duration(milliseconds: 300);
  Duration get autoScrollDelay => Duration(milliseconds: 1000);
  const AppDecoration._();
  BorderRadius messageBorderRadius(
          {bool isTopLeft = false,
          bool isBottomRight = false,
          bool isTopRight = false,
          bool isBottomLeft = false,
          double curved = 16}) =>
      BorderRadius.only(
        topLeft: Radius.circular(isTopLeft ? 2 : curved),
        topRight: Radius.circular(isTopRight ? 2 : curved),
        bottomRight: Radius.circular(isBottomRight ? 2 : curved),
        bottomLeft: Radius.circular(isBottomLeft ? 2 : curved),
      );
  RoundedRectangleBorder roundedBorder([double value = 16]) =>
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(value));

  InputDecorationTheme inputDecorationTheme({
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

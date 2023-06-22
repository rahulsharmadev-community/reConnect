import 'dart:async';
import 'models/_export_.dart';

/// Duration utilities.
extension DurationExtensions on Duration {
  /// Utility to delay some callback (or code execution).
  ///
  /// Sample:
  /// ```
  /// void main() async {
  ///   final _delay = 3.seconds;
  ///   print('+ wait $_delay');
  ///   await _delay.delay();
  ///   print('- finish wait $_delay');
  ///   print('+ callback in 700ms');
  ///   await 0.7.seconds.delay(() {
  /// }
  ///```
  int get inYears => (inMonths / 12).round();

  int get inMonths => (inDays / 30.4167).round();
  int get inWeeks => (inDays / 7).round();

  Future delay([FutureOr Function()? callback]) async =>
      Future.delayed(this, callback);

  hms({bool showFull = false}) =>
      '${inHours > 0 ? '${(inHours % 60).round()}:' : ''}'
              '${inMinutes > 0 ? '${(inMinutes % 60).round()}:' : ''}'
              '${(inSeconds % 60).round()}'
          .trim();

  /// Sample
  /// ```dart
  ///   Comming Soon..
  /// ```
  Timeago timeagoSince(
          {String? code,
          bool showSeconds = true,
          bool showMinutes = true,
          bool showHours = true,
          bool showDays = true,
          bool showWeeks = false,
          bool showMonths = true,
          bool showYears = true}) =>
      Timeago.fromDuration(this,
          code: code,
          showSeconds: showSeconds,
          showMinutes: showMinutes,
          showHours: showHours,
          showDays: showDays,
          showWeeks: showWeeks,
          showMonths: showMonths,
          showYears: showYears);
}

import 'package:flutter/material.dart' show TimeOfDay, DayPeriod;
import 'models/_export_.dart';

extension DateTimeExtensions on DateTime {
  /// Copies a [DateTime], overriding specified values.
  ///
  /// A UTC [DateTime] will remain in UTC; a local [DateTime] will remain local.

  DateTime copyWith({
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
  }) {
    return (isUtc ? DateTime.utc : DateTime.new)(
      year ?? this.year,
      month ?? this.month,
      day ?? this.day,
      hour ?? this.hour,
      minute ?? this.minute,
      second ?? this.second,
      millisecond ?? this.millisecond,
      microsecond ?? this.microsecond,
    );
  }

  TimeOfDay get timeOfDay => TimeOfDay.fromDateTime(this);

  /// Whether this time of day is before or after noon.
  DayPeriod get period => hour < _hoursPerPeriod ? DayPeriod.am : DayPeriod.pm;

  /// Which hour of the current period (e.g., am or pm) this time is.
  ///
  /// For 12AM (midnight) and 12PM (noon) this returns 12.
  int get hourOfPeriod => hour == 0 || hour == 12 ? 12 : hour - periodOffset;

  /// The hour at which the current period starts.
  int get periodOffset => period == DayPeriod.am ? 0 : _hoursPerPeriod;

  /// The number of hours in one day period (see also [DayPeriod]), i.e. 12.
  int get _hoursPerPeriod => 12;

  /// Equal to: (month / 4).round();
  /// eg. (6/4).round() = 2
  int get quarter => (month / 4).round();

  /// Sample
  /// ```dart
  ///  DateTime(2015,5,9).format();
  /// ```
  DateTimeFormat format({String? seprator, String? code}) =>
      DateTimeFormat(this, seprator: seprator, code: code);

  /// Sample
  /// ```dart
  /// DateTime(2015,5,9).timeagoSince();
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
      Timeago.since(this,
          code: code,
          showSeconds: showSeconds,
          showMinutes: showMinutes,
          showHours: showHours,
          showDays: showDays,
          showWeeks: showWeeks,
          showMonths: showMonths,
          showYears: showYears);

  /// Returns true if [this] occurs strictly before [other], accounting for time
  /// zones.
  ///
  /// Alias for [DateTime.isBefore].
  bool operator <(DateTime other) => isBefore(other);

  /// Returns true if [this] occurs strictly after [other], accounting for time
  /// zones.
  ///
  /// Alias for [DateTime.isAfter].
  bool operator >(DateTime other) => isAfter(other);

  /// Returns true if [this] occurs at or before [other], accounting for time
  /// zones.
  ///
  /// Alias for [isAtOrBefore].
  bool operator <=(DateTime other) => isAtOrBefore(other);

  /// Returns true if [this] occurs at or after [other], accounting for time
  /// zones.
  ///
  /// Alias for [isAtOrAfter].
  bool operator >=(DateTime other) => isAtOrAfter(other);

  /// Returns a new [DateTime] instance with [duration] added to [this].
  ///
  /// Alias for [DateTime.add].
  DateTime operator +(Duration duration) => add(duration);

  /// Returns a new [DateTime] instance with [duration] subtract to [this].
  ///
  /// Alias for [DateTime.subtract].
  DateTime operator -(Duration other) => subtract(other);

  /// Returns true if [this] occurs at or before [other], accounting for time
  /// zones.
  ///
  /// Delegates to [DateTime]'s built-in comparison methods and therefore obeys
  /// the same contract.
  bool isAtOrBefore(DateTime other) =>
      isAtSameMomentAs(other) || isBefore(other);

  /// Returns true if [this] occurs at or after [other], accounting for time
  /// zones.
  ///
  /// Delegates to [DateTime]'s built-in comparison methods and therefore obeys
  /// the same contract.
  bool isAtOrAfter(DateTime other) => isAtSameMomentAs(other) || isAfter(other);
}

import 'package:shared/extensions/datetime/duration_ext.dart';

import 'datetimelang_fun.dart';
import 'datetime_format.dart';

class Timeago {
  final Duration duration;
  final bool showSeconds,
      showMinutes,
      showHours,
      showDays,
      showWeeks,
      showMonths,
      showYears;
  final String? code;

  Timeago(
    DateTime startAt,
    DateTime endAt, {
    this.code,
    this.showSeconds = true,
    this.showMinutes = true,
    this.showHours = true,
    this.showDays = true,
    this.showWeeks = false,
    this.showMonths = true,
    this.showYears = true,
  }) : duration = endAt.difference(startAt);

  Timeago.since(DateTime since,
      {this.code,
      this.showSeconds = true,
      this.showMinutes = true,
      this.showHours = true,
      this.showDays = true,
      this.showWeeks = false,
      this.showMonths = true,
      this.showYears = true})
      : duration = DateTime.now().difference(since);

  Timeago.fromDuration(this.duration,
      {this.code,
      this.showSeconds = true,
      this.showMinutes = true,
      this.showHours = true,
      this.showDays = true,
      this.showWeeks = false,
      this.showMonths = true,
      this.showYears = true});

  format(
      {bool isFull = false,
      String? seprator,
      String Function(DateTimeFormat)? monthFormat,
      String Function(DateTimeFormat)? yearFormat}) {
    var dtl = DateTimeLang.dateTimeLang(code);

    if (showYears && duration.inYears > 0) {
      return (yearFormat == null)
          ? '${duration.inYears} ${isFull ? dtl.years : dtl.shortyears} ${dtl.timeagosuffix}'
          : yearFormat(DateTimeFormat(DateTime.now().subtract(duration),
              seprator: seprator, code: code));
    } else if (showMonths && duration.inMonths > 0) {
      return (monthFormat == null)
          ? '${duration.inMonths} ${isFull ? dtl.months.NAME : dtl.shortmonths.NAME} ${dtl.timeagosuffix}'
          : monthFormat(DateTimeFormat(DateTime.now().subtract(duration),
              seprator: seprator, code: code));
    } else if (showWeeks && duration.inWeeks > 0) {
      return '${duration.inWeeks} ${isFull ? dtl.weekdays.NAME : dtl.shortweekdays.NAME} ${dtl.timeagosuffix}';
    } else if (showDays && duration.inDays > 0) {
      return '${duration.inDays} ${isFull ? dtl.days : dtl.shortdays} ${dtl.timeagosuffix}';
    } else if (showHours && duration.inHours > 0) {
      return '${duration.inHours} ${isFull ? dtl.hours : dtl.shorthours} ${dtl.timeagosuffix}';
    } else if (showMinutes && duration.inMinutes > 0) {
      return '${duration.inMinutes} ${isFull ? dtl.minutes : dtl.shortminutes} ${dtl.timeagosuffix}';
    } else if (showSeconds && duration.inSeconds > 10) {
      return '${duration.inSeconds} ${isFull ? dtl.seconds : dtl.shortseconds} ${dtl.timeagosuffix}';
    } else {
      return dtl.justnow;
    }
  }
}

// ignore_for_file: file_names
import 'datetimelang_fun.dart';
import '../datetime.ext.dart';
import 'datetime_lang_model.dart';

class DateTimeFormat {
  final DateTime _dt;
  final String? _;
  final String? code;
  DateTimeFormat(DateTime dateTime, {String? seprator, this.code})
      : _ = seprator,
        _dt = dateTime;

  DateTimeLangModel get dtl => DateTimeLang.dateTimeLang(code);

  /// ```dart
  /// yM() =>  10/2022
  /// ```
  String yM() => '${_dt.month}${_ ?? '/'}${_dt.year}';

  /// ```dart
  ///   yMd() => 10/30/2022
  /// ```
  String yMd() => '${_dt.day}${_ ?? '/'}${_dt.month}${_ ?? '/'}${_dt.year}';

  /// ```dart
  ///   yMEd()=> Sun, 10/30/2022
  ///   yMEd(isFull: true) => Sunday, 10/30/2022
  /// ```
  String yMEd({bool isFull = false}) {
    return '${isFull ? dtl.weekdays.LIST[_dt.weekday - 1] : dtl.shortweekdays.LIST[_dt.weekday - 1]}, '
        '${yMd()}';
  }

  /// ```dart
  ///   yMMM() => Oct 2022
  ///   yMMM(isFull: true) => October 2022
  /// ```
  String yMMM({bool isFull = false}) =>
      '${isFull ? dtl.months.LIST[_dt.month - 1] : dtl.shortmonths.LIST[_dt.month - 1]}${_ ?? ' '}'
      '${_dt.year}';

  /// ```dart
  ///   yMMd() => 30 Oct 2022
  ///   yMMd(isFull: true) => 30 October 2022
  /// ```
  String yMMd({bool isFull = false}) => '${_dt.day}${_ ?? ' '}'
      '${isFull ? dtl.months.LIST[_dt.month - 1] : dtl.shortmonths.LIST[_dt.month - 1]}${_ ?? ' '}'
      '${_dt.year}';

  /// ```dart
  ///   yMMMd() => Oct 30, 2022
  ///   yMMMd(isFull: true) => October 30, 2022
  /// ```
  String yMMMd({bool isFull = false}) =>
      '${isFull ? dtl.months.LIST[_dt.month - 1] : dtl.shortmonths.LIST[_dt.month - 1]} '
      '${_dt.day}${_ ?? ', '}'
      '${_dt.year}';

  /// ```dart
  ///   yMMMEd() => Sun, Oct 30, 2022
  ///   yMMMEd(isFull: true) =>Sunday, October 30, 2022
  /// ```
  String yMMMEd({bool isFull = false}) =>
      '${isFull ? dtl.weekdays.LIST[_dt.weekday - 1] : dtl.shortweekdays.LIST[_dt.weekday - 1]}${_ ?? ', '}'
      '${yMMMd(isFull: isFull)}';

  /// ```dart
  ///   yQQQ() => Q4 2022
  ///   yQQQ(isFull: true)=> 4th quarter 2022
  /// ```
  String yQQQ({bool isFull = false}) {
    return isFull
        ? '${_dt.quarter}${_ ?? ' '}'
            'quarter${_ ?? ' '}'
            '${_dt.year}'
        : 'Q${_dt.quarter}${_ ?? ' '}'
            '${_dt.year}';
  }

  /// ```dart
  /// hm() => 02:37
  /// hm() => 2:37 AM
  ///  /// ```
  String hm({bool showPeriod = false}) {
    return '${_dt.hour}${_ ?? ':'}'
            '${_dt.minute} '
            '${showPeriod ? '${_dt.period.name}' : ''}'
        .trim();
  }

  /// ```dart
  /// hms() => 02:37:31
  /// hms() => 2:37:31 AM
  /// ```
  hms({bool showPeriod = false}) {
    return '${_dt.hour}${_ ?? ':'}'
            '${_dt.minute}${_ ?? ':'}'
            '${_dt.second} '
            '${showPeriod ? '${_dt.period.name}' : ''}'
        .trim();
  }
}

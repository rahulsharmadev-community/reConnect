// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

class DateTimeLangModel {
  const DateTimeLangModel({
    required this.code,
    required this.justnow,
    required this.timeagosuffix,
    required this.months,
    required this.shortmonths,
    required this.weekdays,
    required this.shortweekdays,
    required this.years,
    required this.days,
    required this.hours,
    required this.minutes,
    required this.seconds,
    required this.shortyears,
    required this.shortdays,
    required this.shorthours,
    required this.shortminutes,
    required this.shortseconds,
  });

  final String code;
  final String justnow;
  final String timeagosuffix;
  final MetaData months;
  final MetaData shortmonths;
  final MetaData weekdays;
  final MetaData shortweekdays;
  final String years;
  final String days;
  final String hours;
  final String minutes;
  final String seconds;
  final String shortyears;
  final String shortdays;
  final String shorthours;
  final String shortminutes;
  final String shortseconds;

  factory DateTimeLangModel.fromJson(String str) =>
      DateTimeLangModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DateTimeLangModel.fromMap(Map<String, dynamic> map) =>
      DateTimeLangModel(
        code: map["CODE"],
        justnow: map["JUSTNOW"],
        timeagosuffix: map["TIMEAGOSUFFIX"],
        months: MetaData.fromMap(map["MONTHS"]),
        shortmonths: MetaData.fromMap(map["SHORTMONTHS"]),
        weekdays: MetaData.fromMap(map["WEEKDAYS"]),
        shortweekdays: MetaData.fromMap(map["SHORTWEEKDAYS"]),
        years: map["YEARS"],
        days: map["DAYS"],
        hours: map["HOURS"],
        minutes: map["MINUTES"],
        seconds: map["SECONDS"],
        shortyears: map["SHORTYEARS"],
        shortdays: map["SHORTDAYS"],
        shorthours: map["SHORTHOURS"],
        shortminutes: map["SHORTMINUTES"],
        shortseconds: map["SHORTSECONDS"],
      );

  Map<String, dynamic> toMap() => {
        "CODE": code,
        "JUSTNOW": justnow,
        "TIMEAGOSUFFIX": timeagosuffix,
        "MONTHS": months.toMap(),
        "SHORTMONTHS": shortmonths.toMap(),
        "WEEKDAYS": weekdays.toMap(),
        "SHORTWEEKDAYS": shortweekdays.toMap(),
        "YEARS": years,
        "DAYS": days,
        "HOURS": hours,
        "MINUTES": minutes,
        "SECONDS": seconds,
        "SHORTYEARS": shortyears,
        "SHORTDAYS": shortdays,
        "SHORTHOURS": shorthours,
        "SHORTMINUTES": shortminutes,
        "SHORTSECONDS": shortseconds,
      };
}

class MetaData {
  MetaData({
    required this.NAME,
    required this.LIST,
  });

  final String NAME;
  final List<String> LIST;

  factory MetaData.fromJson(String str) => MetaData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MetaData.fromMap(Map<String, dynamic> map) => MetaData(
        NAME: map["NAME"],
        LIST: List<String>.from(map["LIST"].map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "NAME": NAME,
        "LIST": List<dynamic>.from(LIST.map((x) => x)),
      };
}

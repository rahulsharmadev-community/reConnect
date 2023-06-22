import 'datetime_lang_model.dart';

class DateTimeLang {
  DateTimeLang._();

  static final _availableLang = <DateTimeLangModel>[
    DateTimeLangModel(
      code: "hi",
      justnow: "हाल ही में",
      timeagosuffix: "पूर्व",
      years: "वर्षों",
      days: "दिन",
      hours: "घंटे",
      minutes: "मिनट",
      seconds: "सेकंड",
      shortyears: "वर्षों",
      shortdays: "दिन",
      shorthours: "घंटे",
      shortminutes: "मिनट",
      shortseconds: "सेकंड",
      months: MetaData(NAME: "महीने", LIST: [
        "जनवरी",
        "फ़रवरी",
        "मार्च",
        "अप्रैल",
        "मई",
        "जून",
        "जुलाई",
        "अगस्त",
        "सितंबर",
        "अक्तूबर",
        "नवंबर",
        "दिसंबर"
      ]),
      shortmonths: MetaData(NAME: "महीने", LIST: [
        "जन॰",
        "फ़र॰",
        "मार्च",
        "अप्रैल",
        "मई",
        "जून",
        "जुल॰",
        "अग॰",
        "सित॰",
        "अक्तू॰",
        "नव॰",
        "दिस॰"
      ]),
      weekdays: MetaData(NAME: "सप्ताह", LIST: [
        "रविवार",
        "सोमवार",
        "मंगलवार",
        "बुधवार",
        "गुरुवार",
        "शुक्रवार",
        "शनिवार"
      ]),
      shortweekdays: MetaData(
          NAME: "सप्ताह",
          LIST: ["रवि", "सोम", "मंगल", "बुध", "गुरु", "शुक्र", "शनि"]),
    ),
    DateTimeLangModel(
      code: "en",
      justnow: "Just now",
      timeagosuffix: "ago",
      years: "Years",
      days: "Days",
      hours: "Hours",
      minutes: "Minutes",
      seconds: "Seconds",
      shortyears: "Yr",
      shortdays: "D",
      shorthours: "Hr",
      shortminutes: "Min",
      shortseconds: "Sec",
      months: MetaData(NAME: "Months", LIST: [
        "January",
        "February",
        "March",
        "April",
        "May",
        "June",
        "July",
        "August",
        "September",
        "October",
        "November",
        "December"
      ]),
      shortmonths: MetaData(NAME: "Mo", LIST: [
        "Jan",
        "Feb",
        "Mar",
        "Apr",
        "May",
        "Jun",
        "Jul",
        "Aug",
        "Sept",
        "Oct",
        "Nov",
        "Dec"
      ]),
      weekdays: MetaData(NAME: "Weeks", LIST: [
        "Sunday",
        "Monday",
        "Tuesday",
        "Wednesday",
        "Thursday",
        "Friday",
        "Saturday"
      ]),
      shortweekdays: MetaData(
          NAME: "w", LIST: ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]),
    )
  ];

  static String _defaultLang = 'en';
  static setDefaultLang(String code) => _defaultLang = code;

  static DateTimeLangModel dateTimeLang([String? langCode]) =>
      _availableLang.firstWhere(
        (element) => element.code == (langCode ?? _defaultLang),
        orElse: () => _availableLang[1],
      );
}

import 'package:flutter/material.dart';
import 'package:shared/shared.dart';
import 'app_theme.dart';

class AppThemeRepo {
  AppThemeRepo._();
  static Duration animDelay = 300.milliseconds;
  static Duration autoScrollDelay = 1000.milliseconds;

  static final Map<String, AppTheme> theme = {
    'DEFAULT': AppTheme(
      dark: CustomThemeData(
          appColors: AppColors(
            background: '222222'.toColor,
            appBar: '292A2E'.toColor,
            secondary: '303338'.toColor,
            icon: '90A2B4'.toColor,
            primaryUserMessageCard: '505962'.toColor,
            clientMessageCard: '292A2E'.toColor,
            clientText: 'F9FAFC'.toColor,
            primaryUserText: 'F9FAFC'.toColor,
            clientCaption: Colors.white54,
            primaryUserCaption: Colors.white54,
            primeryText: 'F9FAFC'.toColor,
            secondaryText: Colors.white38,
          ),
          themeData: ThemeData(
              useMaterial3: true,
              appBarTheme: AppBarTheme(color: '292A2E'.toColor, elevation: 8),
              colorScheme: ColorScheme.dark(
                background: '222222'.toColor,
                secondary: '303338'.toColor,
              )),
          primaryUserMessageContextStyle: const TextStyle(fontSize: 13),
          primaryUserMessageCaptionStyle: const TextStyle(fontSize: 11),
          clientMessageContextStyle: const TextStyle(fontSize: 13),
          clientMessageCaptionStyle: const TextStyle(fontSize: 11),
          replyContextStyle: const TextStyle(fontSize: 10),
          replyTitleStyle: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
          messageBorderRadius:
              (bool isTopLeft, bool isbottomRight, double curved) =>
                  BorderRadius.only(
                    topLeft: Radius.circular(isTopLeft ? 2 : curved),
                    topRight: Radius.circular(curved),
                    bottomRight: Radius.circular(isbottomRight ? 2 : curved),
                    bottomLeft: Radius.circular(curved),
                  )),
      light: CustomThemeData(
          appColors: AppColors(
            background: Colors.white,
            appBar: Colors.white,
            secondary: Colors.white,
            icon: '53A1EB'.toColor,
            primaryUserMessageCard: '52A2E9'.toColor,
            clientMessageCard: 'F0F0F0'.toColor,
            clientText: Colors.black,
            primaryUserText: 'F9FAFC'.toColor,
            clientCaption: Colors.black54,
            primaryUserCaption: Colors.white54,
            primeryText: Colors.black,
            secondaryText: Colors.black45,
          ),
          themeData: ThemeData(
              useMaterial3: true,
              appBarTheme: AppBarTheme(color: '292A2E'.toColor, elevation: 8),
              colorScheme: const ColorScheme.light(
                background: Colors.white,
                secondary: Colors.white,
              )),
          primaryUserMessageContextStyle: const TextStyle(fontSize: 13),
          primaryUserMessageCaptionStyle: const TextStyle(fontSize: 11),
          clientMessageContextStyle: const TextStyle(fontSize: 13),
          clientMessageCaptionStyle: const TextStyle(fontSize: 11),
          replyContextStyle: const TextStyle(fontSize: 10),
          replyTitleStyle: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
          messageBorderRadius:
              (bool isTopLeft, bool isbottomRight, double curved) =>
                  BorderRadius.only(
                    topLeft: Radius.circular(isTopLeft ? 2 : curved),
                    topRight: Radius.circular(curved),
                    bottomRight: Radius.circular(isbottomRight ? 2 : curved),
                    bottomLeft: Radius.circular(curved),
                  )),
    )
  };
}

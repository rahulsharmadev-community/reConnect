import 'package:flutter/material.dart';
import 'package:shared/shared.dart';
import 'app_theme.dart';

class AppThemeRepo {
  AppThemeRepo._();

  static final Map<String, AppTheme> theme = {
    'regular': AppTheme(
      dark: CustomThemeData(
          appColors: AppColors(
            background: '222222'.toColor,
            appBar: '292A2E'.toColor,
            secondary: '303338'.toColor,
            icon: '90A2B4'.toColor,
            logInUserMessageCard: '505962'.toColor,
            clientMessageCard: '292A2E'.toColor,
            clientText: 'F9FAFC'.toColor,
            logInUserText: 'F9FAFC'.toColor,
            clientCaption: Colors.white54,
            logInUserCaption: Colors.white54,
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
          logInUserMessageContextStyle: const TextStyle(fontSize: 13),
          logInUserMessageCaptionStyle: const TextStyle(fontSize: 11),
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
            logInUserMessageCard: '52A2E9'.toColor,
            clientMessageCard: 'F0F0F0'.toColor,
            clientText: Colors.black,
            logInUserText: 'F9FAFC'.toColor,
            clientCaption: Colors.black54,
            logInUserCaption: Colors.white54,
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
          logInUserMessageContextStyle: const TextStyle(fontSize: 13),
          logInUserMessageCaptionStyle: const TextStyle(fontSize: 11),
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

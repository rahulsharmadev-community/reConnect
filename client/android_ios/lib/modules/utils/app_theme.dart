import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class AppTheme extends Equatable {
  final CustomThemeData dark, light;
  const AppTheme({
    required this.dark,
    required this.light,
  });

  @override
  List<Object?> get props => [dark, light];
}

class CustomThemeData extends Equatable {
  final ThemeData themeData;
  final AppColors appColors;
  final TextStyle logInUserMessageContextStyle;
  final TextStyle logInUserMessageCaptionStyle;
  final TextStyle clientMessageContextStyle;
  final TextStyle clientMessageCaptionStyle;
  final TextStyle replyContextStyle;
  final TextStyle replyTitleStyle;
  final BorderRadius Function(bool isTopLeft, bool isbottomRight, double curved)
      messageBorderRadius;

  const CustomThemeData(
      {required this.appColors,
      required this.themeData,
      required this.logInUserMessageContextStyle,
      required this.logInUserMessageCaptionStyle,
      required this.clientMessageContextStyle,
      required this.clientMessageCaptionStyle,
      required this.replyContextStyle,
      required this.replyTitleStyle,
      required this.messageBorderRadius});

  @override
  List<Object?> get props => [
        themeData,
        appColors,
        logInUserMessageContextStyle,
        logInUserMessageCaptionStyle,
        clientMessageContextStyle,
        clientMessageCaptionStyle,
        replyContextStyle,
        replyTitleStyle,
        messageBorderRadius
      ];
}

class AppColors extends Equatable {
  final Color background;
  final Color appBar;

  /// For banner, snackbar, dialog...
  final Color secondary;
  final Color icon;
  final Color logInUserMessageCard;
  final Color clientMessageCard;
  final Color clientText;
  final Color logInUserText;
  final Color clientCaption;
  final Color logInUserCaption;
  final Color primeryText;

  /// For Captions
  final Color secondaryText;

  const AppColors(
      {required this.background,
      required this.appBar,
      required this.secondary,
      required this.icon,
      required this.logInUserMessageCard,
      required this.clientMessageCard,
      required this.clientText,
      required this.logInUserText,
      required this.clientCaption,
      required this.logInUserCaption,
      required this.primeryText,
      required this.secondaryText});

  @override
  List<Object?> get props => [
        background,
        appBar,
        secondary,
        icon,
        logInUserMessageCard,
        clientMessageCard,
        clientText,
        logInUserText,
        clientCaption,
        logInUserCaption,
        primeryText,
        secondaryText
      ];
}

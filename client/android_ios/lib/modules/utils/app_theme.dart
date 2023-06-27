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
  final TextStyle primaryUserMessageContextStyle;
  final TextStyle primaryUserMessageCaptionStyle;
  final TextStyle clientMessageContextStyle;
  final TextStyle clientMessageCaptionStyle;
  final TextStyle replyContextStyle;
  final TextStyle replyTitleStyle;
  final BorderRadius Function(bool isTopLeft, bool isbottomRight, double curved)
      messageBorderRadius;

  const CustomThemeData(
      {required this.appColors,
      required this.themeData,
      required this.primaryUserMessageContextStyle,
      required this.primaryUserMessageCaptionStyle,
      required this.clientMessageContextStyle,
      required this.clientMessageCaptionStyle,
      required this.replyContextStyle,
      required this.replyTitleStyle,
      required this.messageBorderRadius});

  @override
  List<Object?> get props => [
        themeData,
        appColors,
        primaryUserMessageContextStyle,
        primaryUserMessageCaptionStyle,
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
  final Color primaryUserMessageCard;
  final Color clientMessageCard;
  final Color clientText;
  final Color primaryUserText;
  final Color clientCaption;
  final Color primaryUserCaption;
  final Color primeryText;

  /// For Captions
  final Color secondaryText;

  const AppColors(
      {required this.background,
      required this.appBar,
      required this.secondary,
      required this.icon,
      required this.primaryUserMessageCard,
      required this.clientMessageCard,
      required this.clientText,
      required this.primaryUserText,
      required this.clientCaption,
      required this.primaryUserCaption,
      required this.primeryText,
      required this.secondaryText});

  @override
  List<Object?> get props => [
        background,
        appBar,
        secondary,
        icon,
        primaryUserMessageCard,
        clientMessageCard,
        clientText,
        primaryUserText,
        clientCaption,
        primaryUserCaption,
        primeryText,
        secondaryText
      ];
}

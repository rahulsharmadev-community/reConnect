import 'package:flutter/material.dart';
import 'app_color_scheme.dart';

class AppThemeData {
  final AppColorScheme colorScheme;
  final FontWeight defRegular;
  final FontWeight defMedium;
  final FontWeight defSemiBold;
  final FontWeight defBold;
  final double bodyFs;
  final double titleFs;
  final double headlineFs;
  final double captionFs;
  final double primaryUserMsgBodyFs;
  final double primaryUserMsgCaptionFs;
  final double clientMsgBodyFs;
  final double clientMsgCaptionFs;
  final double replyBodyFs;
  final double replyTitleFs;
  const AppThemeData(
      {this.bodyFs = 14,
      this.titleFs = 16,
      this.headlineFs = 20,
      this.captionFs = 12,
      this.primaryUserMsgBodyFs = 13,
      this.primaryUserMsgCaptionFs = 11,
      this.clientMsgBodyFs = 13,
      this.clientMsgCaptionFs = 11,
      this.replyBodyFs = 10,
      this.replyTitleFs = 11,
      this.defRegular = FontWeight.w400,
      this.defMedium = FontWeight.w500,
      this.defSemiBold = FontWeight.w600,
      this.defBold = FontWeight.w700,
      required this.colorScheme});

  ThemeData get themeData => ThemeData(
      useMaterial3: true,
      appBarTheme: const AppBarTheme(elevation: 8),
      colorScheme: colorScheme);

  TextTheme get textTheme => TextTheme(
        headlineMedium: TextStyle(fontWeight: defBold, fontSize: headlineFs),
        bodySmall: TextStyle(fontWeight: defSemiBold, fontSize: captionFs),
        headlineSmall: TextStyle(fontWeight: defMedium, fontSize: titleFs),
        titleMedium: TextStyle(fontWeight: defMedium, fontSize: titleFs),
        labelSmall: TextStyle(fontWeight: defMedium, fontSize: captionFs),
        bodyLarge: TextStyle(fontWeight: defRegular, fontSize: bodyFs),
        titleSmall: TextStyle(fontWeight: defMedium, fontSize: bodyFs),
        bodyMedium: TextStyle(fontWeight: defRegular, fontSize: titleFs),
        titleLarge: TextStyle(fontWeight: defBold, fontSize: titleFs),
        labelLarge: TextStyle(fontWeight: defSemiBold, fontSize: bodyFs),
      );

  TextStyle get primaryUserMessageContextStyle =>
      TextStyle(fontSize: primaryUserMsgBodyFs);
  TextStyle get primaryUserMessageCaptionStyle =>
      TextStyle(fontSize: primaryUserMsgCaptionFs);
  TextStyle get clientMessageContextStyle =>
      TextStyle(fontSize: clientMsgBodyFs);
  TextStyle get clientMessageCaptionStyle =>
      TextStyle(fontSize: clientMsgCaptionFs);
  TextStyle get replyContextStyle => TextStyle(fontSize: replyBodyFs);
  TextStyle get replyTitleStyle =>
      TextStyle(fontSize: replyTitleFs, fontWeight: defMedium);
}
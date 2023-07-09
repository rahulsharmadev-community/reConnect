import 'package:flutter/material.dart' show Color, ColorScheme;

class AppColorScheme extends ColorScheme {
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

  const AppColorScheme({
    required this.icon,
    required this.primaryUserMessageCard,
    required this.clientMessageCard,
    required this.clientText,
    required this.primaryUserText,
    required this.clientCaption,
    required this.primaryUserCaption,
    required this.primeryText,
    required this.secondaryText,
    required super.primary,
    required super.onPrimary,
    required super.primaryContainer,
    required super.onPrimaryContainer,
    required super.secondary,
    required super.onSecondary,
    required super.secondaryContainer,
    required super.onSecondaryContainer,
    required super.tertiary,
    required super.onTertiary,
    required super.tertiaryContainer,
    required super.onTertiaryContainer,
    required super.error,
    required super.onError,
    required super.errorContainer,
    required super.onErrorContainer,
    required super.outline,
    required super.outlineVariant,
    required super.background,
    required super.onBackground,
    required super.surface,
    required super.onSurface,
    required super.surfaceVariant,
    required super.onSurfaceVariant,
    required super.inverseSurface,
    required super.onInverseSurface,
    required super.inversePrimary,
    required super.shadow,
    required super.scrim,
    required super.surfaceTint,
    required super.brightness,
  });
}

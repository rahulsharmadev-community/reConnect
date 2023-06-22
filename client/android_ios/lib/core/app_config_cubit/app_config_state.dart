part of 'app_config_cubit.dart';

@immutable
abstract class AppConfigState {
  static AppConfigState fromMap(Map<String, dynamic> map) {
    switch (map['state']) {
      case AppConfigLoading:
        return AppConfigLoading();
      case AppConfigError:
        return AppConfigError();
      default:
        return AppConfigured.fromMap(map);
    }
  }

  get toMap => {};
}

class AppConfigLoading extends AppConfigState {
  @override
  get toMap => {'state': AppConfigLoading};
}

class AppConfigError extends AppConfigState {
  @override
  get toMap => {'state': AppConfigError};
}

class AppConfigured extends AppConfigState {
  final ThemeMode themeMode;
  final String activeThemeName;
  final Duration animDelay;
  final Duration autoScrollDelay;

  AppTheme get activeTheme => AppThemeRepo.theme[activeThemeName]!;

  AppConfigured(
      {String? activeThemeName,
      ThemeMode? themeMode,
      Duration? animDelay,
      Duration? autoScrollDelay})
      : themeMode = themeMode ?? ThemeMode.system,
        animDelay = animDelay ?? 300.milliseconds,
        autoScrollDelay = autoScrollDelay ?? 1000.milliseconds,
        activeThemeName =
            activeThemeName ?? AppThemeRepo.theme.entries.first.key;

  @override
  Map<String, dynamic> get toMap => {
        'themeMode': themeMode.index,
        'activeThemeName': activeThemeName,
        'animDelay': animDelay.inMilliseconds,
        'autoScrollDelay': autoScrollDelay.inMilliseconds
      };

  static AppConfigured fromMap(Map<String, dynamic> map) {
    return AppConfigured(
        themeMode: ThemeMode.values[map['themeMode']],
        activeThemeName: map['activeThemeName'],
        animDelay: map['animDelay'].milliseconds,
        autoScrollDelay: map['autoScrollDelay'].milliseconds);
  }
}

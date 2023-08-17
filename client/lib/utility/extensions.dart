import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reConnect/core/BLOCs/primary_user_bloc/primary_user_bloc.dart';
import 'package:shared/shared.dart';
import 'package:shared/theme/app_theme.dart';

extension PrimaryUserBlocExt on BuildContext {
  PrimaryUser get primaryUser => read<PrimaryUserBloc>().primaryUser!;

  AppThemeData get theme {
    var settings = primaryUser.settings;
    return Theme.of(this).brightness.index == 0
        ? settings.theme.appTheme.dark
        : settings.theme.appTheme.light;
  }

  AppDecoration get decoration {
    var settings = primaryUser.settings;
    return Theme.of(this).brightness.index == 0
        ? settings.theme.appTheme.dark.decoration
        : settings.theme.appTheme.light.decoration;
  }
}

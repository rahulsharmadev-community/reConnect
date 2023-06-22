// ignore_for_file: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:reConnect/modules/utils/app_theme.dart';
import 'package:reConnect/modules/utils/app_theme_repo.dart';
import 'package:shared/shared.dart';
part 'app_config_state.dart';

class AppConfigCubit extends HydratedCubit<AppConfigState> {
  AppConfigCubit() : super(AppConfigLoading()) {
    logs('AppConfigCubit  : $state');
    if (state is AppConfigLoading) {
      logs('If block run');
      emit(AppConfigured());
      logs('after emit AppConfigured');
    }
  }

  @override
  AppConfigState? fromJson(Map<String, dynamic> json) =>
      AppConfigState.fromMap(json);
  @override
  Map<String, dynamic>? toJson(AppConfigState state) => state.toMap;
}

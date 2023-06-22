// ignore_for_file: use_build_context_synchronously

import 'package:android_info/android_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reConnect/utility/navigation/app_navigator.dart';
import 'core/app_config_cubit/app_config_cubit.dart';
import 'utility/routes/app_router.dart';

class FlutterAppRunner extends StatelessWidget {
  final AndroidDeviceInfo? android;
  final String? ios;
  const FlutterAppRunner({
    super.key,
    this.ios,
    this.android,
  }) : assert((android == null && ios == null), 'Both are not null');

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppConfigCubit>(
          create: (context) => AppConfigCubit(),
        )
      ],
      child: Builder(builder: (context) {
        return BlocBuilder<AppConfigCubit, AppConfigState>(
            builder: (context, state) {
          switch (state.runtimeType) {
            case AppConfigured:
              print('-------------AppConfigured--------');
              return _FlutterAppRun();
            case AppConfigLoading:
              print('-------------AppConfigLoading--------');
              return const MaterialApp(
                  home: Scaffold(
                      body: Center(child: CircularProgressIndicator())));
            default:
              print('-------------default--------');
              return const MaterialApp(
                  home: Scaffold(body: Center(child: Text('Error Occur'))));
          }
        });
      }),
    );
  }
}

class _FlutterAppRun extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var config = (context.watch<AppConfigCubit>().state as AppConfigured);
    var appTheme = config.activeTheme;
    return MaterialApp.router(
      theme: appTheme.light.themeData,
      darkTheme: appTheme.light.themeData,
      themeMode: config.themeMode,
      routerConfig: appRouterConfig,
      scaffoldMessengerKey: AppNavigator.messengerKey,
      debugShowCheckedModeBanner: kDebugMode,
    );
  }
}

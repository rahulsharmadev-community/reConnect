// ignore_for_file: use_build_context_synchronously
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reConnect/core/authentication_bloc/authentication_bloc.dart';
import 'package:reConnect/utility/navigation/app_navigator.dart';
import 'package:shared/firebase_api/firebase_api.dart';
import 'package:shared/shared.dart';
import 'core/app_config_cubit/app_config_cubit.dart';
import 'utility/routes/app_router.dart';

class FlutterAppRunner extends StatelessWidget {
  final DeviceInfo deviceInfo;
  const FlutterAppRunner(
    this.deviceInfo, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<AuthenticationBloc>(
            create: (context) => AuthenticationBloc(
                deviceInfo: deviceInfo, userRepository: UserRepository())
              ..add(CheckDeviceRegistered()),
          ),
          BlocProvider<AppConfigCubit>(
            create: (context) => AppConfigCubit(),
          )
        ],
        child: Builder(builder: (context) {
          return BlocBuilder<AppConfigCubit, AppConfigState>(
              builder: (context, state) {
            switch (state.runtimeType) {
              case AppConfigured:
                return _FlutterAppRun();
              case AppConfigLoading:
                return const MaterialApp(
                    home: Scaffold(
                        body: Center(child: CircularProgressIndicator())));
              default:
                return const MaterialApp(
                    home: Scaffold(body: Center(child: Text('Error Occur'))));
            }
          });
        }));
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

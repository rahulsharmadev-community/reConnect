// ignore_for_file: use_build_context_synchronously, camel_case_types
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reConnect/core/authentication_bloc/authentication_bloc.dart';
import 'package:reConnect/core/firebase_bloc/primary_user_bloc/primary_user_bloc.dart';
import 'package:reConnect/modules/screens/auth_screens/registration_screen/registration_screen.dart';
import 'package:reConnect/modules/screens/other_screens/loading_screen.dart';
import 'package:reConnect/core/firebase_api/firebase_api.dart';
import 'package:shared/shared.dart';
import 'modules/screens/other_screens/error_screen.dart';
import 'utility/routes/app_router.dart';
import 'package:shared/theme/collection.dart';

class reConnectAppRunner extends StatelessWidget {
  final DeviceInfo deviceInfo;
  const reConnectAppRunner(
    this.deviceInfo, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final userRepo = PrimaryUserRepository(
      deviceInfo: deviceInfo,
      chatRoomsRepository: ChatRoomsRepository(),
    );
    return MultiBlocProvider(providers: [
      BlocProvider<PrimaryUserBloc>(
          create: (context) => PrimaryUserBloc(userRepo)),
      BlocProvider<AuthenticationBloc>(
        create: (context) => AuthenticationBloc(
            deviceInfo: deviceInfo,
            userRepository: userRepo,
            primaryUserBloc: context.read<PrimaryUserBloc>())
          ..add(CheckDeviceRegistered()),
      ),
    ], child: widgetBuilder());
  }

  BlocBuilder<AuthenticationBloc, AuthenticationState> widgetBuilder() {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        switch (state.runtimeType) {
          case Authorized:
            return const reConnectAppHome();
          case Unauthorized:
            return const RegistrationScreen();
          case ErrorState:
            return const ErrorScreen(true);
          default:
            return const LoadingScreen(true);
        }
      },
    );
  }
}

class reConnectAppHome extends StatelessWidget {
  const reConnectAppHome({super.key});
  @override
  Widget build(BuildContext context) {
    // Rebuild only when the selected parameter changes.
    var themeMode = context.select<PrimaryUserBloc, ThemeMode>(
        (state) => state.primaryUser!.settings.themeMode);

    var theme = context.select<PrimaryUserBloc, String>(
        (state) => state.primaryUser!.settings.theme);

    return MaterialApp.router(
      theme: AppThemesCollection.theme[theme]!.light.themeData,
      darkTheme: AppThemesCollection.theme[theme]!.dark.themeData,
      themeMode: themeMode,
      routerConfig: appRouterConfig,
      scaffoldMessengerKey: AppNavigator.messengerKey,
      debugShowCheckedModeBanner: kDebugMode,
    );
  }
}

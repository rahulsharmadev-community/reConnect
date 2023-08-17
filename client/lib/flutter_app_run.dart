// ignore_for_file: use_build_context_synchronously, camel_case_types
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reConnect/core/BLOCs/app_metadata_cubit/app_meta_data_cubit.dart';
import 'package:reConnect/core/BLOCs/authentication_bloc/authentication_bloc.dart';
import 'package:reConnect/core/BLOCs/primary_user_bloc/primary_user_bloc.dart';
import 'package:reConnect/core/services/notifications_service.dart';
import 'package:reConnect/modules/screens/auth_screens/registration_screen/registration_screen.dart';
import 'package:reConnect/modules/screens/other_screens/loading_screen.dart';
import 'package:reConnect/core/APIs/firebase_api/firebase_api.dart';
import 'package:shared/shared.dart';
import 'package:shared/theme/app_theme.dart';
import 'modules/screens/other_screens/error_screen.dart';
import 'utility/routes/app_router.dart';

class reConnectAppRunner extends StatelessWidget {
  final DeviceInfo deviceInfo;
  const reConnectAppRunner(
    this.deviceInfo, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final userRepo = PrimaryUserApi(
      deviceInfo: deviceInfo,
      chatRoomsApi: ChatRoomsApi(),
    );
    return MultiBlocProvider(providers: [
      BlocProvider<PrimaryUserBloc>(
          create: (context) => PrimaryUserBloc(userRepo)),
      BlocProvider<AppMetaDataCubit>(
          create: (context) => AppMetaDataCubit(api: AppMetaDataApi())),
      BlocProvider<AuthenticationBloc>(
        create: (context) => AuthenticationBloc(
          deviceInfo: deviceInfo,
          userRepo: userRepo,
          primaryUserBloc: context.read<PrimaryUserBloc>(),
          fCMid: FirebaseNotificationService.instance.firebaseMessagingToken,
        )..add(AuthenticationEvent.checkDeviceRegistered()),
      ),
    ], child: widgetBuilder());
  }

  BlocConsumer<AuthenticationBloc, AuthenticationState> widgetBuilder() {
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is Authorized) {
          context.read<AppMetaDataCubit>().fetchChatRoomDefaultPermissions();
        }
      },
      builder: (context, state) {
        switch (state.runtimeType) {
          case Authorized:
            return const reConnectAppHome();
          case Unauthorized:
            return const RegistrationScreen();
          case ErrorState:
            return const ErrorScreen(materialAppWraper: true);
          default:
            return const LoadingScreen(materialAppWraper: true);
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

    var theme = context.select<PrimaryUserBloc, AppThemes>((state) {
      return state.primaryUser!.settings.theme;
    }).appTheme;

    return MaterialApp.router(
      theme: theme.light.themeData,
      darkTheme: theme.dark.themeData,
      themeMode: themeMode,
      routerConfig: AppRoutes.config,
      scaffoldMessengerKey: AppNavigator.messengerKey,
      debugShowCheckedModeBanner: kDebugMode,
    );
  }
}

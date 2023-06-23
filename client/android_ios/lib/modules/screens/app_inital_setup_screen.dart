import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reConnect/utility/navigation/app_navigator.dart';
import 'package:reConnect/utility/routes/app_router.dart';

import '../../core/authentication_bloc/authentication_bloc.dart';

class AppInitalSetupScreen extends StatelessWidget {
  const AppInitalSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthenticationBloc, AuthenticationState>(
            listener: (context, state) async {
          if (state is Unauthorized) {
            await AppNavigator.on(
                (router) => router.goNamed(AppRoutes.LogInScreen.name));
          }
          if (state is Authorized) {
            await AppNavigator.on(
                (router) => router.goNamed(AppRoutes.AppDashBoard.name));
          }
        }),
      ],
      child: const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}

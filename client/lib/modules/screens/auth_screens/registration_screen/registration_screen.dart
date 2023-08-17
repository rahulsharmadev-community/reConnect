import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reConnect/core/BLOCs/authentication_bloc/authentication_bloc.dart';
import 'package:shared/theme/src/themes/app_themes.dart';

import 'widgets/aggrement_text.dart';
part 'widgets/registeration_form.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var remaningHeight = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).padding.top + kToolbarHeight);
    return MaterialApp(
      theme: AppThemes.DEFAULT.appTheme.light.themeData,
      darkTheme: AppThemes.DEFAULT.appTheme.dark.themeData,
      themeMode: ThemeMode.dark,
      home: Scaffold(
        appBar: buildAppBar(context),
        body: SingleChildScrollView(
          child: SizedBox(
            height: remaningHeight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _RegisterationForm(
                  onRegister: (name, email, phoneNo) => context
                      .read<AuthenticationBloc>()
                      .add(AuthenticationEvent.deviceRegistration(
                          name, email, phoneNo)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar(context) {
    var theme = Theme.of(context);
    var expanded = Expanded(
      child: Container(
        height: 3,
        decoration: BoxDecoration(
            color: theme.colorScheme.onPrimary,
            borderRadius: BorderRadius.circular(3)),
      ),
    );
    return AppBar(
        title: Row(
      children: [
        expanded,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Text(
            "Registration",
            style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onPrimary),
          ),
        ),
        expanded
      ],
    ));
  }
}

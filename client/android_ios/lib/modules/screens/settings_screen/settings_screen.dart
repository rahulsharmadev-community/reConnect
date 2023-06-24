import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:reConnect/core/firebase_bloc/login_user_bloc/login_user_bloc.dart';
import 'package:reConnect/modules/screens/settings_screen/setting_metadata.dart';
import 'package:shared/shared.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print('----Parent Widget Rebuild-----');

    return Scaffold(
      body:
          BlocBuilder<LoginUserBloc, LoginUserState>(builder: (context, state) {
        final logInUser = (state as LoginUserLoaded).logInUser;
        var list = SettingMetaData.list
            .map((e) => e.widget(
                  logInUser.settings,
                  (p0) => context.read<LoginUserBloc>().add(UpdateSettings(p0)),
                ))
            .toList();
        print('----ListView Widget Rebuild-----');
        return ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) => list[index],
        );
      }),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reConnect/core/firebase_bloc/primary_user_bloc/primary_user_bloc.dart';
import 'package:reConnect/modules/screens/settings_screen/setting_metadata.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<PrimaryUserBloc, PrimaryUserState>(
          builder: (context, state) {
        var list = SettingMetaData.list
            .map((e) => e.widget(
                  (state as PrimaryUserLoaded).primaryUser.settings,
                  (p0) => context
                      .read<PrimaryUserBloc>()
                      .add(PrimaryUserEvent.updateSettings(p0)),
                ))
            .toList();
        return ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) => list[index],
        );
      }),
    );
  }
}

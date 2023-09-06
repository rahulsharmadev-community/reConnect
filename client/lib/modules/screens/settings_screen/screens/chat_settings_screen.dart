import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reConnect/core/BLOCs/primary_user_bloc/primary_user_bloc.dart';
import 'package:reConnect/modules/screens/settings_screen/setting_metadata.dart';

class ChatSettingsScreen extends StatelessWidget {
  const ChatSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final read = context.read<PrimaryUserBloc>();
    final my =
        context.select((PrimaryUserBloc value) => value.primaryUser!.settings);
    return Scaffold(
      appBar: AppBar(title: const Text('Chat Setting')),
      body: ListView.builder(
        itemCount: SettingMetaData.chat_settings.length,
        itemBuilder: (context, i) {
          var value = SettingMetaData.chat_settings[i];
          return value.widget(
            context,
            old: my,
            onChanged: (p0) {
              read.add(PrimaryUserEvent.updateSettings(p0));
            },
          );
        },
      ),
    );
  }
}

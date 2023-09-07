import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reConnect/core/BLOCs/primary_user_bloc/primary_user_bloc.dart';
import 'package:reConnect/modules/screens/settings_screen/setting_metadata.dart';
import 'package:reConnect/modules/widgets/other_widget.dart';

class NotificationSoundScreen extends StatelessWidget {
  NotificationSoundScreen({super.key});

  final messages = <SettingMetaData>[
    SettingMetaData.message_sound,
    SettingMetaData.message_vibrate_type,
    SettingMetaData.in_app_message_notification,
    SettingMetaData.message_reaction_notification,
    SettingMetaData.background_message_notification
  ];
  final groups = <SettingMetaData>[
    SettingMetaData.group_sound,
    SettingMetaData.group_vibrate_type,
    SettingMetaData.in_app_group_notification,
    SettingMetaData.group_reaction_notification,
    SettingMetaData.background_group_notification
  ];
//  in_app_sound,
//  in_app_vibrate,
  @override
  Widget build(BuildContext context) {
    final read = context.read<PrimaryUserBloc>();
    final my =
        context.select((PrimaryUserBloc value) => value.primaryUser!.settings);

    display(SettingMetaData data) {
      return data.widget(   context,
        old: my,
        onChanged: (p0) => read.add(PrimaryUserEvent.updateSettings(p0)),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Chat Setting')),
      body: ListView(
        children: [
          display(SettingMetaData.show_security_notifications),
          display(SettingMetaData.notify_on_credential_change),
          const Divider(),
          const rSubTitle('Messages'),
          ...messages.map(display),
          const Divider(),
          const rSubTitle('Groups'),
          ...groups.map(display)
        ],
      ),
    );
  }
}

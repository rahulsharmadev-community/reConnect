import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reConnect/core/BLOCs/primary_user_bloc/primary_user_bloc.dart';
import 'package:reConnect/modules/screens/settings_screen/setting_metadata.dart';
import 'package:reConnect/modules/widgets/other_widget.dart';

class PrivacySecurityScreen extends StatelessWidget {
  PrivacySecurityScreen({super.key});

  final wsp = [
    SettingMetaData.hide_about,
    SettingMetaData.hide_status,
    SettingMetaData.hide_profile_img,
    SettingMetaData.status_reply_permission,
    SettingMetaData.hide_credential,
    SettingMetaData.blocked_users,
    SettingMetaData.sync_contacts,
  ];
  final security = [
    SettingMetaData.screenshot_restriction,
    SettingMetaData.recording_restriction,
    SettingMetaData.advanced_encryption,
  ];

  @override
  Widget build(BuildContext context) {
    final read = context.read<PrimaryUserBloc>();
    final my =
        context.select((PrimaryUserBloc value) => value.primaryUser!.settings);

    Widget display(SettingMetaData data) {
      return data.widget(   context,
        old: my,
        onChanged: (p0) => read.add(PrimaryUserEvent.updateSettings(p0)),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Privacy and security')),
      body: ListView(
        children: [
          const Divider(),
          const rSubTitle('Who can see my personal info'),
          ...wsp.map(display),
          const Divider(),
          const rSubTitle('Advacne security'),
          ...security.map(display),
        ],
      ),
    );
  }
}

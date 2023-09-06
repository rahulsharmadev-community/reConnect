import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reConnect/core/BLOCs/primary_user_bloc/primary_user_bloc.dart';
import 'package:reConnect/modules/screens/settings_screen/setting_metadata.dart';
import 'package:reConnect/modules/widgets/other_widget.dart';

class StorageDataScreen extends StatelessWidget {
  const StorageDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final read = context.read<PrimaryUserBloc>();
    final my =
        context.select((PrimaryUserBloc value) => value.primaryUser!.settings);

    Widget display(SettingMetaData data) {
      return data.widget(
        context,
        old: my,
        onChanged: (p0) => read.add(PrimaryUserEvent.updateSettings(p0)),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Storage and data')),
      body: ListView(
        children: [
          const Divider(),
          const rSubTitle(
            'Media auto-download',
            subtitle: 'Voice messages are always automatically downloaded',
          ),
          ...SettingMetaData.storage_and_data.map(display),
        ],
      ),
    );
  }
}

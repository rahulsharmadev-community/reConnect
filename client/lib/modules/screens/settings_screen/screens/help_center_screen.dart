import 'package:flutter/material.dart';
import 'package:reConnect/modules/screens/settings_screen/setting_metadata.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help Center'),
      ),
      body: ListView(
        children: [
          ...SettingMetaData.help_center
              .map((data) => data.widget(context, old: null, onChanged: null))
        ],
      ),
    );
  }
}

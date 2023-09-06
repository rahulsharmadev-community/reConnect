import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reConnect/core/BLOCs/primary_user_bloc/primary_user_bloc.dart';
import 'package:reConnect/modules/widgets/userlisttile.dart';
import 'package:reConnect/utility/routes/app_routes.dart';
import 'setting_metadata.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final TextEditingController controller;
  String get text => controller.text;
  var searchedList = SettingMetaData.all;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget displayCollection() {
    final my = context.read<PrimaryUserBloc>().primaryUser!;
    return ListView(children: [
      UserListTile(
          name: my.name,
          profileImg: my.profileImg,
          subtitle: Opacity(opacity: 0.7, child: Text(my.about)),
          onTap: () => AppRoutes.ProfileSettingsScreen.pushNamed()),
      tile(
          icon: Icons.message,
          title: 'Chat Settings',
          subtitle: 'Theme, wallpapers, chat history',
          onTap: () => AppRoutes.ChatSettingsScreen.pushNamed()),
      tile(
          icon: Icons.lock,
          title: 'Privacy and Security',
          subtitle: 'Block contects, hide status, advanced encryption',
          onTap: () => AppRoutes.PrivacySecurityScreen.pushNamed()),
      tile(
          icon: Icons.notifications,
          title: 'Notification and Sound',
          subtitle: 'Message, group and security alerts, vibrations and sound',
          onTap: () => AppRoutes.NotificationSoundScreen.pushNamed()),
      tile(
          icon: Icons.data_usage_rounded,
          title: 'Storage and Data',
          subtitle: 'Network usege, auto-download',
          onTap: () => AppRoutes.StorageDataScreen.pushNamed()),
      tile(
          icon: Icons.help_outline,
          title: 'Help Center',
          subtitle: 'Help center, contact us, privacy policy, licence',
          onTap: () => AppRoutes.HelpCenterScreen.pushNamed()),
    ]);
  }

  ListTile tile(
      {required IconData icon,
      required String title,
      required String subtitle,
      required VoidCallback? onTap}) {
    return ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Opacity(
          opacity: 0.7,
          child: Text(
            subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        onTap: onTap);
  }

  Scaffold nextScreen(String title, List<SettingMetaData<dynamic>> ls) {
    var settings = context.read<PrimaryUserBloc>().primaryUser!.settings;
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ListView.builder(
          itemCount: ls.length,
          itemBuilder: (ctx, i) => ls[i].widget(
                context,
                old: settings,
                onChanged: (p0) => context
                    .read<PrimaryUserBloc>()
                    .add(PrimaryUserEvent.updateSettings(p0)),
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: searchField()),
      body: BlocBuilder<PrimaryUserBloc, PrimaryUserState>(
          builder: (context, state) {
        var list = searchedList
            .map((e) => e.widget(
                  context,
                  old: (state as PrimaryUserLoaded).primaryUser.settings,
                  onChanged: (p0) => context
                      .read<PrimaryUserBloc>()
                      .add(PrimaryUserEvent.updateSettings(p0)),
                ))
            .toList();
        return text.isEmpty
            ? displayCollection()
            : ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) => list[index],
              );
      }),
    );
  }

  searchField() {
    return TextField(
      onChanged: (value) {
        if (value.trim().isNotEmpty) {
          searchedList = SettingMetaData.all
              .where((item) => item.name.toLowerCase().contains(value.trim()))
              .toList();
        } else {
          searchedList = SettingMetaData.all;
        }
        setState(() {});
      },
      controller: controller,
      decoration: InputDecoration(
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          hintText: 'Search...',
          suffix: InkWell(
            onTap: () {
              controller.clear();
              setState(() {
                searchedList = SettingMetaData.all;
              });
            },
            child: const Icon(Icons.clear_rounded),
          )),
    );
  }
}

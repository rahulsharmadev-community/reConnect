import 'package:flutter/material.dart';
import 'package:reConnect/modules/widgets/profile_avatar.dart';

class UserListTile extends StatelessWidget {
  /// name(Title) always a string.
  final String name;

  /// If profileImage is null then first letter of
  /// name display as profileImg
  final String? profileImg;
  final VoidCallback? onTap, onTapHold;
  final Widget? subtitle, trailing, sweetTrailing;
  const UserListTile(
      {super.key,
      required this.name,
      this.profileImg,
      this.onTap,
      this.onTapHold,
      this.subtitle,
      this.trailing,
      this.sweetTrailing});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      onLongPress: onTapHold,
      leading: ProfileAvatar(
        name: name,
        profileImg: profileImg,
      ),
      contentPadding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
      title: (sweetTrailing != null)
          ? Row(children: [Text(name), const Spacer(), sweetTrailing!])
          : Text(name),
      subtitle: subtitle,
      trailing: trailing,
    );
  }
}

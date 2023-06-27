import 'package:flutter/material.dart';

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

  leading() {
    bool notExist = (profileImg == null);
    return CircleAvatar(
        radius: 26,
        backgroundImage: notExist ? null : Image.network(profileImg!).image,
        child: notExist
            ? Padding(
                padding: const EdgeInsets.all(12.0),
                child: FittedBox(
                    child: Text(
                  name[0].toUpperCase(),
                  style: const TextStyle(fontSize: 64),
                )))
            : null);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      onLongPress: onTapHold,
      leading: leading(),
      contentPadding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
      title: (sweetTrailing != null)
          ? Row(children: [Text(name), const Spacer(), sweetTrailing!])
          : Text(name),
      subtitle: subtitle,
      trailing: trailing,
    );
  }
}

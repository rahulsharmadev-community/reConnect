import 'package:cached_image/cached_image.dart';
import 'package:flutter/material.dart';
import 'package:reConnect/utility/cached_locations.dart';

class ProfileAvatar extends StatelessWidget {
  /// name(Title) always a string.
  final String name;

  /// If profileImage is null then first letter of
  /// name display as profileImg
  final String? profileImg;
  final VoidCallback? onTap, onTapHold;
  final double borderRadius;
  final double size;

  const ProfileAvatar(
      {super.key,
      required this.name,
      this.borderRadius = 1000,
      this.size = 52,
      this.profileImg,
      this.onTap,
      this.onTapHold});

  @override
  Widget build(BuildContext context) {
    var nameWidget = Padding(
        padding: const EdgeInsets.all(12.0),
        child: FittedBox(
            child: Text(
          name[0].toUpperCase(),
          style: const TextStyle(fontSize: 64),
        )));
    return InkResponse(
      onTap: onTap,
      onLongPress: onTapHold,
      child: Container(
          width: size,
          height: size,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              color: Colors.grey),
          child: profileImg == null
              ? nameWidget
              : CachedImage(
                  profileImg!,
                  location: rProfilePicsLocation,
                  loadingBuilder: (c, p) => nameWidget,
                  fit: BoxFit.cover,
                )),
    );
  }
}

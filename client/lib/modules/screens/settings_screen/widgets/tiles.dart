import 'package:flutter/material.dart';

class SwitchTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Function(bool)? onChanged;
  final bool value;
  const SwitchTile({
    super.key,
    this.subtitle,
    this.onChanged,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) => ListTile(
        title: Text(title),
        subtitle: subtitle != null ? Text(subtitle!) : null,
        onTap: onChanged != null ? () => onChanged!(!value) : null,
        trailing: Switch(
          activeColor: Colors.green,
          onChanged: onChanged,
          value: value,
        ),
      );
}

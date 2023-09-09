// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:jars/jars.dart';

class rSubTitle extends StatelessWidget {
  final String text;
  final String? subtitle;
  final double opacity;
  final EdgeInsetsGeometry padding;
  final TextStyle? style;
  const rSubTitle(this.text,
      {super.key,
      this.subtitle,
      this.style,
      this.opacity = 0.7,
      EdgeInsetsGeometry? padding})
      : padding = padding ?? const EdgeInsets.all(8.0);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(text, style: style ?? context.textTheme.titleMedium),
          if (subtitle != null) Text(subtitle!)
        ],
      ).opacity(opacity),
    );
  }
}

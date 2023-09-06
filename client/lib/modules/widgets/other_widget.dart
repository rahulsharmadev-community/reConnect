// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

class rSubTitle extends StatelessWidget {
  final String text;
  final String? subtitle;
  final double opacity;
  final EdgeInsetsGeometry? padding;
  final TextStyle? style;
  const rSubTitle(this.text,
      {super.key, this.subtitle, this.style, this.opacity = 0.7, this.padding});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(8.0),
      child: Opacity(
          opacity: opacity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(text,
                  style: style ?? Theme.of(context).textTheme.titleMedium),
              if (subtitle.isNotNull) Text(subtitle!)
            ],
          )),
    );
  }
}

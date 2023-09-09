import 'package:flutter/material.dart';

extension WidgetExt on Widget {
  AlignJar get align => AlignJar(this);
  SizedBox expandBox() => SizedBox.expand(child: this);
}

class AlignJar {
  final Widget widget;
  AlignJar(this.widget);
  Align topLeft() => Align(alignment: Alignment.topLeft, child: widget);
  Align topCenter() => Align(alignment: Alignment.topCenter, child: widget);
  Align topRight() => Align(alignment: Alignment.topRight, child: widget);
  Align centerLeft() => Align(alignment: Alignment.centerLeft, child: widget);
  Align center() => Align(alignment: Alignment.center, child: widget);
  Align centerRight() => Align(alignment: Alignment.centerRight, child: widget);
  Align bottomLeft() => Align(alignment: Alignment.bottomLeft, child: widget);
  Align bottomCenter() =>
      Align(alignment: Alignment.bottomCenter, child: widget);
  Align bottomRight() => Align(alignment: Alignment.bottomRight, child: widget);
}

extension DateTimeEXT on DateTime {
  bool get isToday {
    final now = DateTime.now();
    return day == now.day && month == now.month && year == now.year;
  }
}

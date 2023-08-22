import 'package:flutter/material.dart';

class RoundDivider extends StatelessWidget {
  final Color? color;
  final double? thickness;
  final double? width;
  const RoundDivider({super.key, this.color, this.thickness, this.width})
      : assert(thickness == null || thickness >= 0.0),
        assert(width == null || width >= 0.0 || width <= 1.0);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: thickness ?? 4,
      width: MediaQuery.of(context).size.width * (width ?? 0.10),
      decoration: BoxDecoration(
          color: color ?? Colors.grey,
          borderRadius: BorderRadius.circular(1000)),
    );
  }
}

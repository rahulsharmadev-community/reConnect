import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

extension GapExt on num {
  Gap get gap => Gap(toDouble());
}

class MaxGap extends Gap {
  const MaxGap({super.key}) : super.max();
}

class Gap extends LeafRenderObjectWidget {
  final double value;
  const Gap([this.value = 8, Key? key]) : super(key: key);
  const Gap.max({super.key}) : value = double.maxFinite;

  BoxConstraints size(double h, double w) =>
      BoxConstraints.tightFor(width: w, height: h);

  @override
  RenderObject createRenderObject(BuildContext context) {
    bool isParent<T extends Widget>() =>
        context.findAncestorWidgetOfExactType<T>() != null;

    if (isParent<Column>() || isParent<ListView>()) {
      return RenderConstrainedBox(additionalConstraints: size(value, 0));
    }
    if (isParent<Row>()) {
      return RenderConstrainedBox(additionalConstraints: size(0, value));
    }
    return RenderConstrainedBox(additionalConstraints: size(0, 0));
  }
}

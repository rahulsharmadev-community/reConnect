import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:jars/jars.dart';

class AggrementText extends StatelessWidget {
  final TapGestureRecognizer recognizer;
  final Color color;
  const AggrementText(
      {super.key, required this.recognizer, required this.color});

  @override
  Widget build(BuildContext context) {
    var style = Theme.of(context).primaryTextTheme.bodySmall!;
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: 'By selecting Agree & Continue below, I agree to our ',
        style: style.copyWith(color: Colors.black),
        children: <TextSpan>[
          TextSpan(
              recognizer: recognizer,
              text: 'Terms of Service and Privacy Policy',
              style: style.copyWith(color: color)),
        ],
      ),
    ).paddingHorizontal(16);
  }
}

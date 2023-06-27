import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class AggrementText extends StatelessWidget {
  final TapGestureRecognizer recognizer;
  final Color color;
  const AggrementText(
      {super.key, required this.recognizer, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: 'By selecting Agree & Continue below, I agree to our ',
          style: const TextStyle(color: Colors.black, fontSize: 12),
          children: <TextSpan>[
            TextSpan(
                recognizer: recognizer,
                text: 'Terms of Service and Privacy Policy',
                style: TextStyle(
                    color: color, fontWeight: FontWeight.bold, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

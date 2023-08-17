import 'package:flutter/material.dart';

class SimpleSider extends StatefulWidget {
  final double max, min, gap, initalValue;
  final String title;
  final String? subtitle;
  const SimpleSider(
      {super.key,
      required this.max,
      required this.min,
      this.gap = 2,
      required this.initalValue,
      required this.title,
      this.subtitle});

  @override
  State<SimpleSider> createState() => _SimpleSiderState();
}

class _SimpleSiderState extends State<SimpleSider> {
  late double initValue;
  @override
  void initState() {
    initValue = widget.initalValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(widget.title, style: const TextStyle(fontSize: 18)),
                if (widget.subtitle != null)
                  Text(widget.subtitle!, style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
          Slider.adaptive(
            onChanged: (value) => setState(() => initValue = value),
            value: initValue,
            divisions: (widget.max - widget.min) ~/ widget.gap,
            label: '$initValue',
            min: widget.min,
            max: widget.max,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    fixedSize:
                        Size(MediaQuery.of(context).size.width / 1.5, 48)),
                onPressed: initValue == widget.initalValue
                    ? null
                    : () => Navigator.pop(context, initValue),
                child: const Text('Submit'),
              ),
            ),
          ),
        ]);
  }
}

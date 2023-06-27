import 'package:flutter/material.dart';

class ChooserDialog extends StatefulWidget {
  final String title;
  final String? subtitle;

  /// RadioListTile : (title, subtitle)
  final (String, String?) initalValue;

  /// RadioListTile : (title, subtitle)
  final List<(String, String?)> list;
  const ChooserDialog(
      {super.key,
      required this.list,
      required this.title,
      this.subtitle,
      required this.initalValue});

  @override
  State<ChooserDialog> createState() => _ChooserDialogState();
}

class _ChooserDialogState extends State<ChooserDialog> {
  late (String, String?)? currentValue;

  @override
  void initState() {
    currentValue = widget.initalValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(widget.title),
          if (widget.subtitle != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                widget.subtitle!,
                style: const TextStyle(fontSize: 16, color: Colors.white54),
              ),
            ),
        ],
      ),
      children: widget.list
          .map(
            (e) => RadioListTile<(String, String?)>(
              value: e,
              groupValue: currentValue,
              onChanged: (value) async {
                setState(() => currentValue = value);
                await Future.delayed(
                  const Duration(milliseconds: 100),
                  () => Navigator.pop(context, e),
                );
              },
              title: Text(e.$1),
              subtitle: e.$2 != null ? Text(e.$2!) : null,
            ),
          )
          .toList(),
    );
  }
}

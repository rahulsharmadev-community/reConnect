import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

class MsgDateTimeStatus extends StatelessWidget {
  final DateTime createdAt;
  final MessageStatus? status;
  final TextStyle style;
  const MsgDateTimeStatus(
    this.createdAt, {
    this.status,
    required this.style,
    super.key,
  });

  get icon {
    switch (status) {
      case MessageStatus.deleted:
        return (Icons.delete_forever, Colors.red);
      case MessageStatus.sent:
        return (Icons.done, Colors.blueGrey);
      case MessageStatus.seen:
        return (Icons.done_all, Colors.blue);
      case MessageStatus.failed:
        return (Icons.priority_high, Colors.yellow);
      default:
        return (Icons.schedule, Colors.grey);
    }
  }

  get iconWidget => Padding(
      padding: const EdgeInsets.only(left: 3.0),
      child: Icon(icon.$1, color: icon.$2, size: 12));

  @override
  Widget build(BuildContext context) {
    var dateTimeWidget = Text(DateTimeFormat(createdAt).hm(showPeriod: true),
        textAlign: TextAlign.end, style: style);
    return status == null
        ? dateTimeWidget
        : Row(mainAxisSize: MainAxisSize.min, children: [
            dateTimeWidget,
            iconWidget,
          ]);
  }
}

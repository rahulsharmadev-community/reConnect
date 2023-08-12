import 'package:flutter/material.dart';
import 'package:shared/shared.dart';
import 'common_function.dart';

class MessageCardForPrimaryUser extends StatelessWidget {
  final Message msg;
  const MessageCardForPrimaryUser(this.msg, {super.key});

  @override
  Widget build(BuildContext context) {
    final fun = CommonFunction(context);
    var contentStyle = fun.theme.primaryUserMessageContentStyle;
    var borderRadius = fun.decoration.messageBorderRadius(isbottomRight: true);
    var color = fun.colorScheme.primaryUserMessageCard;
    var maxWidth = msg.hasAttachment
        ? msg.attachments.first.size?.width ?? fun.defaultWidth
        : fun.textWidth(msg.text ?? '', contentStyle) +
            fun.textWidth(DateTimeFormat(msg.createdAt).hm(showPeriod: true),
                contentStyle) +
            42;
            
    Widget iconWidget = Padding(
        padding: const EdgeInsets.only(left: 3.0),
        child: Icon(msg.status!.icon, color: msg.status!.color, size: 12));

    // Widget Only For Primary User
    Widget dateTimeStatus() {
      var dateTimeWidget =
          fun.dateTimeWidget(dateTime: msg.createdAt, style: contentStyle);

      return msg.status == null
          ? dateTimeWidget
          : Padding(
              padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
              child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [dateTimeWidget, iconWidget]),
            );
    }

    List<Widget> showDeletedMsgAndDataTime = [
      Text('🚫 You deleted this message', style: contentStyle),
      dateTimeStatus()
    ];

    return Container(
        constraints: fun.boxConstraints(maxWidth),
        clipBehavior: Clip.hardEdge,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: borderRadius,
        ),
        child: Wrap(
          spacing: 0,
          runSpacing: 4,
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.end,
          children: msg.status == MessageStatus.deleted
              ? showDeletedMsgAndDataTime
              : [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (msg.hasReply) fun.replyContainer(msg.reply!),
                        if (msg.hasAttachment)
                          fun.attachmentContainer(msg.attachments)
                      ]),
                  fun.msgText(msg.text),
                  dateTimeStatus(),
                ],
        ));
  }
}

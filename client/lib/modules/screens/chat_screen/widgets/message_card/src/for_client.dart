import 'package:flutter/material.dart';
import 'package:reConnect/utility/extensions.dart';
import 'package:shared/shared.dart';
import 'common_function.dart';

class MessageCardForClient extends StatelessWidget {
  final Message msg;
  const MessageCardForClient(this.msg, {super.key});

  @override
  Widget build(BuildContext context) {
    final fun = CommonFunction(context);

    final maxWidth = msg.hasAttachment
        ? msg.attachments.first.size?.width ?? fun.defaultWidth
        : fun.textWidth(msg.text ?? '', fun.theme.clientMessageContentStyle) +
            fun.textWidth(DateTimeFormat(msg.createdAt).hm(showPeriod: true),
                fun.theme.clientMessageContentStyle) +
            42;

    final boxDecoration = BoxDecoration(
      color: fun.colorScheme.clientMessageCard,
      borderRadius: fun.decoration.messageBorderRadius(isTopLeft: true),
    );

    // Widget Only For Client
    final displayClientName = Text(
        context.primaryUser.contacts[msg.senderId]!.name,
        style: fun.theme.clientMessageTitleStyle);

    final dateTimeWidget = fun.dateTimeWidget(
        dateTime: msg.createdAt, style: fun.theme.clientMessageContentStyle);

    final showDeletedMsgAndDataTime = [
      Text('🚫 $displayClientName deleted this message',
          style: fun.theme.clientMessageContentStyle),
      dateTimeWidget
    ];

    buildChildren(List<Widget> children) {
      return msg.status == MessageStatus.deleted
          ? showDeletedMsgAndDataTime
          : children;
    }

    return Container(
      constraints: fun.boxConstraints(maxWidth),
      clipBehavior: Clip.hardEdge,
      padding: const EdgeInsets.all(8),
      decoration: boxDecoration,
      child: Wrap(
        spacing: 0,
        runSpacing: 4,
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.end,
        children: buildChildren([
          Row(children: [displayClientName]),
          Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (msg.reply != null) fun.replyContainer(msg.reply!),
                if (msg.hasAttachment) fun.attachmentContainer(msg.attachments)
              ]),
          fun.msgText(msg.text),
          dateTimeWidget,
        ]),
      ),
    );
  }
}

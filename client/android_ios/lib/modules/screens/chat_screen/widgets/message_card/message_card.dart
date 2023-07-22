// ignore_for_file: unused_element, must_be_immutable

import 'package:flutter/material.dart';
import 'package:reConnect/utility/extensions.dart';
import 'in_msg_attachment_content.dart';
import 'In_msg_reply_content.dart';
import 'msg_datetime_status.dart';
import 'package:shared/shared.dart';

class MessageCard extends StatelessWidget {
  const MessageCard(
    this.msg, {
    Key? key,
    this.hideClientName = false,
    this.hideClientImg = false,
    this.hideMessageStatus = false,
  }) : super(key: key);
  final Message msg;

  final bool hideClientName;
  final bool hideClientImg;
  final bool hideMessageStatus;

  @override
  Widget build(BuildContext context) {
    final isForClient = msg.senderId != context.primaryUser.userId;
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment:
            isForClient ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7),
            child: isForClient
                ? _MessageCard.forClient(msg)
                : _MessageCard.forPrimaryUser(msg),
          )
        ],
      ),
    );
  }
}

class _MessageCard extends StatelessWidget {
  final Message msg;
  final bool isForClient;

  const _MessageCard.forClient(this.msg, {super.key}) : isForClient = true;
  const _MessageCard.forPrimaryUser(this.msg, {super.key})
      : isForClient = false;

  Widget buildForClient(
    BuildContext context,
    TextStyle contentStyle,
    TextStyle captionStyle,
    List<Widget> children,
  ) {
    var theme = context.theme;
    String name = context.primaryUser.contacts
        .firstWhere((e) => msg.senderId == e.userId)
        .name;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.clientMessageCard,
            borderRadius: theme.decoration.messageBorderRadius(isTopLeft: true),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name,
                  style: theme.clientMessageCaptionStyle
                      .copyWith(fontWeight: FontWeight.w500)),
              const SizedBox(width: 8),
              Wrap(
                alignment: WrapAlignment.end,
                spacing: 8,
                crossAxisAlignment: WrapCrossAlignment.end,
                children: msg.status == MessageStatus.deleted
                    ? [
                        Text('🚫 $name deleted this message',
                            style: contentStyle),
                        MsgDateTimeStatus(
                          msg.createdAt,
                          style: captionStyle,
                        )
                      ]
                    : children,
              )
            ],
          ),
        ),
      ],
    );
  }

  buildforPrimaryUser(
    BuildContext context,
    TextStyle contentStyle,
    TextStyle captionStyle,
    List<Widget> children,
  ) {
    var colorScheme = context.theme.colorScheme;
    return Container(
        padding: const EdgeInsets.all(8),
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: colorScheme.primaryUserMessageCard,
          borderRadius:
              context.theme.decoration.messageBorderRadius(isbottomRight: true),
        ),
        child: Wrap(
          alignment: WrapAlignment.end,
          spacing: 8,
          crossAxisAlignment: WrapCrossAlignment.end,
          runSpacing: 4,
          children: msg.status == MessageStatus.deleted
              ? [
                  Text('🚫 You deleted this message', style: contentStyle),
                  MsgDateTimeStatus(
                    msg.createdAt,
                    style: captionStyle,
                  )
                ]
              : children,
        ));
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> results = [];
    var theme = context.theme;
    TextStyle contentStyle = isForClient
        ? theme.clientMessageContentStyle
        : theme.primaryUserMessageContentStyle;
    TextStyle captionStyle = isForClient
        ? theme.clientMessageCaptionStyle
        : theme.primaryUserMessageCaptionStyle;

    if (msg.hasReply) {
      results.add(InMsgReplyContent(
        msg,
        isForClient: isForClient,
        messageStyle: contentStyle,
        captionStyle: captionStyle,
        replyContentStyle: theme.replyContentStyle,
        replyTitleStyle: theme.replyTitleStyle,
      ));
    } else if (msg.hasAttachment) {
      results.add(InMsgAttachmentContent(
        msg,
        isForClient,
        captionStyle: captionStyle,
        contentStyle: contentStyle,
      ));
    } else {
      results.add(Text(msg.text ?? 'TEXT NOT FOUND'));
      results.add(MsgDateTimeStatus(
        msg.createdAt,
        style: captionStyle,
      ));
    }

    return isForClient
        ? buildForClient(context, contentStyle, captionStyle, results)
        : buildforPrimaryUser(context, contentStyle, captionStyle, results);
  }
}

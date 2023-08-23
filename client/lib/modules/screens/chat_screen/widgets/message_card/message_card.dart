// ignore_for_file: unused_element, must_be_immutable

import 'package:flutter/material.dart';
import 'src/message_container.dart';
import 'package:reConnect/utility/extensions.dart';
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
    final theme = context.theme;
    final colorS = theme.colorScheme;
    return isForClient
        ? MessageContainer(
            msg,
            color: colorS.clientMessageCard,
            unCurvedTopLeft: true,
            alignment: MessageContainerAlignment.left,
            title: context.primaryUser.contacts[msg.senderId]!.name,
            titleStyle: theme.messageTitleStyle,
            replayTitleStyle: theme.replyTitleStyle,
            replayContentStyle: theme.replyContentStyle,
            contentStyle: theme.clientMessageContentStyle,
            captionStyle: theme.clientMessageCaptionStyle,
          )
        : MessageContainer(
            msg,
            color: colorS.primaryUserMessageCard,
            unCurvedBottomRight: true,
            alignment: MessageContainerAlignment.right,
            titleStyle: theme.messageTitleStyle,
            replayTitleStyle: theme.replyTitleStyle,
            replayContentStyle: theme.replyContentStyle,
            contentStyle: theme.primaryUserMessageContentStyle,
            captionStyle: theme.primaryUserMessageCaptionStyle,
          );
  }
}

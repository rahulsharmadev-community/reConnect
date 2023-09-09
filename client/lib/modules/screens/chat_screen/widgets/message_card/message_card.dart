// ignore_for_file: unused_element, must_be_immutable

import 'package:flutter/material.dart';
import 'src/message_container.dart';
import 'package:reConnect/utility/extensions.dart';
import 'package:shared/shared.dart';

class MessageCard extends StatelessWidget {
  const MessageCard(
    this.msg, {
    Key? key,
    this.isForClient = false,
  }) : super(key: key);
  final Message msg;

  final bool isForClient;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final colorS = theme.colorScheme;
    return isForClient
        ? MessageContainer(
            msg,
            key: key,
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
            key: key,
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

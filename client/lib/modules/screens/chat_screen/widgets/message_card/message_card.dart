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
    this.confirmDismiss,
    this.onDismissed,
    DismissDirection? direction,
    required this.isLastMsg,
  })  : direction = direction ??
            (isForClient
                ? DismissDirection.startToEnd
                : isLastMsg
                    ? DismissDirection.none
                    : DismissDirection.endToStart),
        super(key: key);

  final Message msg;
  final bool isForClient;

  /// LastMessage means this the newest message until now?
  final bool isLastMsg;

  final DismissDirection direction;
  final ConfirmDismissCallback? confirmDismiss;

  /// Called when the widget has been dismissed, after finishing resizing.
  final DismissDirectionCallback? onDismissed;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final colorS = theme.colorScheme;
    final color =
        isForClient ? colorS.clientMessageCard : colorS.primaryUserMessageCard;
    final title =
        isForClient ? context.primaryUser.contacts[msg.senderId]!.name : null;
    final contentStyle = isForClient
        ? theme.clientMessageContentStyle
        : theme.primaryUserMessageContentStyle;
    final captionStyle = isForClient
        ? theme.clientMessageCaptionStyle
        : theme.primaryUserMessageCaptionStyle;

    final msgContainer = MessageContainer(
      msg,
      key: key,
      color: color,
      title: title,
      isLastMsg: isLastMsg,
      contentStyle: contentStyle,
      captionStyle: captionStyle,
      unCurvedTopLeft: isForClient,
      unCurvedBottomRight: !isForClient,
      hideIconStatus: isForClient,
      titleStyle: theme.messageTitleStyle,
      replayTitleStyle: theme.replyTitleStyle,
      replayContentStyle: theme.replyContentStyle,
      alignment: MessageContainerAlignment.values[isForClient ? 0 : 1],
    );

    return Dismissible(
      key: Key(msg.messageId),
      direction: direction,
      onDismissed: onDismissed,
      confirmDismiss: confirmDismiss,
      child: msgContainer,
    );
  }
}

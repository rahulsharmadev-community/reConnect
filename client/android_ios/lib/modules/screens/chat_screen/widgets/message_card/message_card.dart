// ignore_for_file: unused_element, must_be_immutable

import 'package:flutter/material.dart';
import 'package:reConnect/utility/extensions.dart';
import 'message_card_attributes.dart';
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
          isForClient
              ? _MessageCard.forClient(msg)
              : _MessageCard.forPrimaryUser(msg)
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

  @override
  Widget build(BuildContext context) {
    final MessageCardAttributes attribute = isForClient
        ? MessageCardAttributes.forClient(context, msg)
        : MessageCardAttributes.forPrimaryUser(context, msg);

    return attribute.msgContainer(child: attribute.msgContent());
  }
}

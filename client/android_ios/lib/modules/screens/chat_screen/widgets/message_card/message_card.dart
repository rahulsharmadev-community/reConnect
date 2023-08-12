// ignore_for_file: unused_element, must_be_immutable

import 'package:flutter/material.dart';
import 'src/for_client.dart';
import 'src/for_primary_user.dart';
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
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment:
            isForClient ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          isForClient
              ? MessageCardForClient(msg)
              : MessageCardForPrimaryUser(msg)
        ],
      ),
    );
  }
}

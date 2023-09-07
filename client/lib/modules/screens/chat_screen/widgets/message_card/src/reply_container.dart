import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:reConnect/utility/extensions.dart';
import 'package:shared/shared.dart';

class ReplyContainer extends StatelessWidget {
  final Message previousMsg;
  final TextStyle replyContentStyle;
  final TextStyle replyTitleStyle;
  const ReplyContainer(
      {super.key,
      required this.previousMsg,
      required this.replyContentStyle,
      required this.replyTitleStyle});

  String name(Iterable<User> list) {
    for (var user in list) {
      if (user.userId == previousMsg.senderId) return user.name;
    }
    return 'You';
  }

  Container _verticalDivider() {
    return Container(
      height: double.maxFinite,
      width: 3,
      margin: const EdgeInsets.fromLTRB(0, 4, 4, 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.black38,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 4, 4, 4),
      height: 60,
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.all(Radius.circular(14)),
      ),
      child: Stack(
        children: [
          Row(
            children: [
              _verticalDivider(),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      name(context.primaryUser.contacts.values),
                      style: replyTitleStyle,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      previousMsg.text ?? 'TEXT NOT FOUND',
                      style: replyContentStyle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Display Attachments if available (like whatsapp)
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:reConnect/modules/screens/chat_screen/widgets/message_card/msg_datetime_status.dart';
import 'package:shared/shared.dart';

class InMsgAttachmentContent extends StatelessWidget {
  final Message msg;
  final bool isForClient;
  final TextStyle contentStyle, captionStyle;
  const InMsgAttachmentContent(this.msg, this.isForClient,
      {super.key, required this.contentStyle, required this.captionStyle});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 8, 8, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  constraints: const BoxConstraints(
                    minHeight: 56,
                    maxHeight: 120,
                    minWidth: 0,
                    maxWidth: 100,
                  ),
                  clipBehavior: Clip.hardEdge,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(8)),
                  child: Image.network(
                    msg.attachments.first.assetUrl!,
                  )),
              if (msg.text?.isNotEmpty ?? false)
                Text(msg.text ?? 'TEXT NOT FOUND', style: contentStyle),
            ],
          ),
        ),
        MsgDateTimeStatus(
          msg.createdAt,
          status: msg.status,
          style: captionStyle,
        ),
      ],
    );
  }
}

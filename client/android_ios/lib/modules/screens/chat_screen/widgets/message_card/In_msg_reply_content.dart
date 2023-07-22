// ignore_for_file: file_names

import 'package:reConnect/modules/screens/chat_screen/widgets/message_card/in_msg_attachment_content.dart';
import 'package:reConnect/utility/extensions.dart';
import 'package:flutter/material.dart';
import 'package:shared/models/models.dart';
import 'msg_datetime_status.dart';

class InMsgReplyContent extends StatelessWidget {
  final Message msg;
  final TextStyle replyTitleStyle,
      replyContentStyle,
      captionStyle,
      messageStyle;
  final bool isForClient;
  const InMsgReplyContent(this.msg,
      {super.key,
      required this.isForClient,
      required this.replyTitleStyle,
      required this.replyContentStyle,
      required this.captionStyle,
      required this.messageStyle});

  Message get oldMessage => msg.reply!;

  String name(BuildContext context) {
    for (var user in context.primaryUser.contacts) {
      if (user.userId == oldMessage.senderId) return user.name;
    }
    return 'You';
  }

  // Function to calculate the text width in pixels
  double textWidth(String text, TextStyle style,
      [double textScaleFactor = 1.0]) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textScaleFactor: textScaleFactor,
      textDirection: TextDirection.ltr,
    )..layout();
    return textPainter.width;
  }

  @override
  Widget build(BuildContext context) {
    var tsf = MediaQuery.of(context).textScaleFactor;
    double maxWidth2 = textWidth(msg.text!, messageStyle, tsf) + 16;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment:
              isForClient ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(8, 4, 4, 4),
              constraints: BoxConstraints(
                  maxHeight: 60, maxWidth: maxWidth2 > 80 ? maxWidth2 : 100),
              clipBehavior: Clip.hardEdge,
              decoration: const BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.all(Radius.circular(14)),
              ),
              child: Stack(
                children: [
                  Row(
                    children: [
                      verticalDivider(),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              name(context),
                              style: replyTitleStyle,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              oldMessage.reply?.text ?? 'TEXT NOT FOUND',
                              style: replyContentStyle,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                      right: 4,
                      top: 2,
                      child: MsgDateTimeStatus(
                        oldMessage.createdAt,
                        style: replyContentStyle,
                      ))
                ],
              ),
            ),
            if (msg.hasAttachment)
              InMsgAttachmentContent(msg, isForClient,
                  contentStyle: messageStyle, captionStyle: captionStyle)
            else
              Text(
                msg.text ?? 'TEXT NOT FOUND',
                style: messageStyle,
              ),
          ],
        ),
        if (!msg.hasAttachment)
          MsgDateTimeStatus(
            msg.createdAt,
            status: oldMessage.status,
            style: captionStyle,
          )
      ],
    );
  }

  Container verticalDivider() {
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
}

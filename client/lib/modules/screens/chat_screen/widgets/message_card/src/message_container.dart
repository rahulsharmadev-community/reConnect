import 'package:flutter/material.dart';
import 'package:reConnect/modules/screens/chat_screen/widgets/message_card/src/attachment_container.dart';
import 'package:reConnect/modules/screens/chat_screen/widgets/message_card/src/reply_container.dart';
import 'package:reConnect/utility/extensions.dart';
import 'package:shared/shared.dart';

enum MessageContainerAlignment {
  left(MainAxisAlignment.start),
  right(MainAxisAlignment.end),
  center(MainAxisAlignment.center);

  final MainAxisAlignment alignment;
  const MessageContainerAlignment(this.alignment);
}

class MessageContainer extends StatelessWidget {
  final Message msg;
  final String? title;
  final bool hideIconStatus;
  final bool unCurvedTopLeft;
  final bool unCurvedBottomRight;
  final double borderCurved;
  final Color color;
  final TextStyle replayTitleStyle;
  final TextStyle replayContentStyle;
  final TextStyle contentStyle;
  final TextStyle captionStyle;
  final TextStyle titleStyle;
  final EdgeInsetsGeometry padding;
  final MessageContainerAlignment alignment;
  const MessageContainer(this.msg,
      {super.key,
      this.title,
      this.hideIconStatus = false,
      this.unCurvedTopLeft = false,
      this.unCurvedBottomRight = false,
      this.borderCurved = 16,
      this.padding = const EdgeInsets.all(8.0),
      required this.color,
      required this.replayContentStyle,
      required this.replayTitleStyle,
      required this.contentStyle,
      required this.captionStyle,
      required this.titleStyle,
      required this.alignment});

  Widget iconStatus() => Padding(
      padding: const EdgeInsets.only(left: 3.0),
      child: Icon(
        msg.status!.icon,
        color: msg.status!.color,
        size: 12,
      ));

  // // Function to calculate the text width in pixels
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

  Text msgText(String? text) => Text(text?.trim() ?? 'TEXT NOT FOUND');

  Widget dateTimeWidget({
    required DateTime dateTime,
    required TextStyle style,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Text(
        DateTimeFormat(dateTime).hm(showPeriod: true),
        textAlign: TextAlign.end,
        style: style,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double defaultWidth = MediaQuery.of(context).size.width * 0.7;
    var borderRadius = context.decoration.messageBorderRadius(
        isbottomRight: unCurvedBottomRight,
        isTopLeft: unCurvedTopLeft,
        curved: borderCurved);

    var tw = textWidth(msg.text ?? '', contentStyle) +
        textWidth(
            DateTimeFormat(msg.createdAt).hm(showPeriod: true), captionStyle) +
        42;
    var maxWidth = msg.hasAttachment
        ? msg.attachments.first.size?.width ?? defaultWidth
        : tw;

    if (msg.hasAttachment && msg.attachments.first.size != null) {
      maxWidth = msg.attachments.first.size!.width < defaultWidth
          ? msg.attachments.first.size!.width
          : defaultWidth;
    }

    // Widget Only For Primary User
    Widget dateTimeStatus() {
      final dtw = dateTimeWidget(dateTime: msg.createdAt, style: captionStyle);
      return msg.status == null
          ? dtw
          : Padding(
              padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
              child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [dtw, if (!hideIconStatus) iconStatus()]),
            );
    }

    Widget showDeletedMsgAndDataTime() {
      return Wrap(children: [
        Text('🚫 You deleted this message', style: contentStyle),
        dateTimeStatus()
      ]);
    }

    // Use for handling widget overflow or ui exception only
    var uiException = ((msg.hasReply || msg.hasAttachment) && tw < maxWidth);

    boxConstraints(double maxWidth) {
      return BoxConstraints(
          maxWidth: maxWidth > defaultWidth ? defaultWidth : maxWidth);
    }

    return Padding(
      key: key,
      padding: padding,
      child: Row(
        mainAxisAlignment: alignment.alignment,
        children: [
          Container(
            constraints: boxConstraints(maxWidth),
            clipBehavior: Clip.hardEdge,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color,
              borderRadius: borderRadius,
            ),
            child: msg.isDeleted
                ? showDeletedMsgAndDataTime()
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: uiException || title.isNotNull
                        ? CrossAxisAlignment.start
                        : CrossAxisAlignment.end,
                    children: [
                      if (title.isNotNull) Text(title!, style: titleStyle),
                      if (msg.hasReply)
                        ReplyContainer(
                          previousMsg: msg.reply!,
                          replyTitleStyle: replayTitleStyle,
                          replyContentStyle: replayContentStyle,
                        ),
                      if (msg.hasAttachment)
                        AttachmentContainer(msg.attachments),
                      if (uiException)
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [msgText(msg.text), dateTimeStatus()])
                      else
                        Wrap(
                            alignment: WrapAlignment.end,
                            crossAxisAlignment: WrapCrossAlignment.end,
                            children: [msgText(msg.text), dateTimeStatus()]),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

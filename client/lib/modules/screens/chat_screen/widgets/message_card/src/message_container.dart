import 'package:flutter/material.dart';
import 'package:reConnect/utility/extensions.dart';
import 'package:shared/shared.dart';
import 'common_function.dart';

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

  @override
  Widget build(BuildContext context) {
    final fun = CommonFunction(context);
    var borderRadius = context.decoration.messageBorderRadius(
        isbottomRight: unCurvedBottomRight,
        isTopLeft: unCurvedTopLeft,
        curved: borderCurved);

    var textWidth = fun.textWidth(msg.text ?? '', contentStyle) +
        fun.textWidth(
            DateTimeFormat(msg.createdAt).hm(showPeriod: true), captionStyle) +
        42;
    var maxWidth = msg.hasAttachment
        ? msg.attachments.first.size?.width ?? fun.defaultWidth
        : textWidth;

    if (msg.hasAttachment && msg.attachments.first.size != null) {
      maxWidth = msg.attachments.first.size!.width < fun.defaultWidth
          ? msg.attachments.first.size!.width
          : fun.defaultWidth;
    }

    // Widget Only For Primary User
    Widget dateTimeStatus() {
      final dateTimeWidget =
          fun.dateTimeWidget(dateTime: msg.createdAt, style: captionStyle);

      return msg.status == null
          ? dateTimeWidget
          : Padding(
              padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                dateTimeWidget,
                if (!hideIconStatus) iconStatus()
              ]),
            );
    }

    Widget showDeletedMsgAndDataTime() {
      return Wrap(children: [
        Text('🚫 You deleted this message', style: contentStyle),
        dateTimeStatus()
      ]);
    }

    // Use for handling widget overflow or ui exception only
    var uiException =
        ((msg.hasReply || msg.hasAttachment) && textWidth < maxWidth);
    return Padding(
      padding: padding,
      child: Row(
        mainAxisAlignment: alignment.alignment,
        children: [
          Container(
              constraints: fun.boxConstraints(maxWidth),
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
                      crossAxisAlignment: uiException
                          ? CrossAxisAlignment.start
                          : CrossAxisAlignment.end,
                      children: [
                        if (title.isNotNull) Text(title!, style: titleStyle),
                        if (msg.hasReply)
                          fun.replyContainer(
                            previousMsg: msg.reply!,
                            replyTitleStyle: replayTitleStyle,
                            replyContentStyle: replayContentStyle,
                          ),
                        if (msg.hasAttachment)
                          fun.attachmentContainer(msg.attachments),
                        if (uiException)
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                fun.msgText(msg.text),
                                dateTimeStatus()
                              ])
                        else
                          Wrap(
                              alignment: WrapAlignment.end,
                              crossAxisAlignment: WrapCrossAlignment.end,
                              children: [
                                fun.msgText(msg.text),
                                dateTimeStatus()
                              ]),
                      ],
                    )),
        ],
      ),
    );
  }
}

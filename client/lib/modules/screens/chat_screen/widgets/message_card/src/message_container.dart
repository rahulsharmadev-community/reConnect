import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jars/jars.dart';
import 'package:reConnect/addition.dart';
import 'package:reConnect/modules/screens/chat_screen/widgets/message_card/src/attachment_container.dart';
import 'package:reConnect/modules/screens/chat_screen/widgets/message_card/src/reply_container.dart';
import 'package:reConnect/utility/extensions.dart';
import 'package:shared/shared.dart';

enum MessageContainerAlignment {
  left(MainAxisAlignment.start),
  right(MainAxisAlignment.end),
  center(MainAxisAlignment.center);

  final MainAxisAlignment mainAxisAlignment;
  const MessageContainerAlignment(this.mainAxisAlignment);
}

class MessageContainer extends StatefulWidget {
  final Message msg;
  final String? title;
  final bool hideIconStatus;
  final bool unCurvedTopLeft;
  final bool unCurvedBottomRight;
  final bool unCurvedTopRight;
  final bool unCurvedBottomLeft;
  final double borderCurved;
  final Color color;
  final TextStyle replayTitleStyle;
  final TextStyle replayContentStyle;
  final TextStyle contentStyle;
  final TextStyle captionStyle;
  final TextStyle titleStyle;
  final MessageContainerAlignment alignment;
  final bool isLastMsg;
  const MessageContainer(
    this.msg, {
    super.key,
    this.title,
    this.hideIconStatus = false,
    this.unCurvedTopLeft = false,
    this.unCurvedBottomRight = false,
    this.unCurvedTopRight = false,
    this.unCurvedBottomLeft = false,
    this.borderCurved = 16,
    required this.color,
    required this.replayContentStyle,
    required this.replayTitleStyle,
    required this.contentStyle,
    required this.captionStyle,
    required this.titleStyle,
    required this.alignment,
    required this.isLastMsg,
  });

  @override
  State<MessageContainer> createState() => _MessageContainerState();
}

class _MessageContainerState extends State<MessageContainer> {
  late ValueNotifier<bool> showDateTime;
  Timer? closeTimer;
  @override
  void initState() {
    showDateTime = ValueNotifier(widget.isLastMsg);
    if (widget.isLastMsg) {
      closeTimer = Timer(3.seconds, () {
        if (showDateTime.value) showDateTime.value = false;
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    showDateTime.dispose();
    closeTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double defaultWidth = context.widthOf(70);
    var settings = context.primaryUser.settings;
    var borderRadius = context.decoration.messageBorderRadius(
        isBottomRight: widget.unCurvedBottomRight,
        isTopLeft: widget.unCurvedTopLeft,
        curved: settings.messageCorners.toDouble() * 2);

    var msgFontSize = settings.messageFontSize.toDouble();
    Widget deletedMsgContainer() {
      return Wrap(children: [
        Text(
          '🚫 You deleted this message',
          style: widget.contentStyle.copyWith(
            fontSize: msgFontSize,
          ),
        ),
        DateTimeContainer(
          dateTime: widget.msg.createdAt,
          style: widget.contentStyle,
        )
      ]);
    }

    double maxWidth = defaultWidth;
    if (widget.msg.hasAttachment && widget.msg.attachments.first.size != null) {
      maxWidth = widget.msg.attachments.first.size!.width < defaultWidth
          ? widget.msg.attachments.first.size!.width
          : defaultWidth;
    }
    boxConstraints() {
      return BoxConstraints(
        maxWidth: maxWidth > defaultWidth ? defaultWidth : maxWidth,
      );
    }

    return Padding(
      key: widget.key,
      padding: EdgeInsets.symmetric(
          vertical: msgFontSize / 4, horizontal: msgFontSize / 2),
      child: Row(
        mainAxisAlignment: widget.alignment.mainAxisAlignment,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment
                .values[widget.alignment.mainAxisAlignment.index],
            children: [
              GestureDetector(
                onTap: () {
                  showDateTime.value = !showDateTime.value;
                  if (!showDateTime.value) closeTimer?.cancel();

                  if (!(closeTimer?.isActive ?? false)) {
                    closeTimer = Timer(3.seconds, () {
                      if (showDateTime.value) showDateTime.value = false;
                    });
                  }
                },
                child: Container(
                  constraints: boxConstraints(),
                  clipBehavior: Clip.hardEdge,
                  padding: EdgeInsets.symmetric(
                      vertical: msgFontSize / 2,
                      horizontal: msgFontSize / 2 + 4),
                  decoration: BoxDecoration(
                    color: widget.color,
                    borderRadius: borderRadius,
                  ),
                  child: widget.msg.isDeleted
                      ? deletedMsgContainer()
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (widget.title.isNotNull)
                              TitleContainer(
                                title: widget.title,
                                titleStyle: widget.titleStyle,
                              ),
                            if (widget.msg.hasReply)
                              ReplyContainer(
                                previousMsg: widget.msg.reply!,
                                replyTitleStyle: widget.replayTitleStyle,
                                replyContentStyle: widget.replayContentStyle,
                              ),
                            if (widget.msg.hasAttachment)
                              AttachmentContainer(widget.msg.attachments),
                            ContextContainer(
                                text: widget.msg.text,
                                style: widget.contentStyle
                                    .copyWith(fontSize: msgFontSize))
                          ],
                        ),
                ),
              ),
              ValueListenableBuilder<bool>(
                valueListenable: showDateTime,
                builder: (context, value, child) {
                  return AnimatedCrossFade(
                      duration: 150.milliseconds,
                      crossFadeState: CrossFadeState.values[value ? 1 : 0],
                      firstChild: const Gap(),
                      secondChild: Padding(
                        padding: EdgeInsets.fromLTRB(
                            widget.alignment.index == 0 ? 8 : 0, 4, 4, 4),
                        child: DateTimeContainer(
                            dateTime: widget.msg.createdAt,
                            status: widget.hideIconStatus
                                ? null
                                : widget.msg.status,
                            style: widget.captionStyle),
                      ));
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}

class DateTimeContainer extends StatelessWidget {
  final DateTime dateTime;
  final TextStyle? style;
  final MessageStatus? status;
  const DateTimeContainer(
      {super.key, this.status, required this.dateTime, this.style});

  @override
  Widget build(BuildContext context) {
    var fontSize = context.primaryUser.settings.messageFontSize / 1.5;

    Widget iconStatus() {
      return Padding(
          padding: const EdgeInsets.only(left: 3.0),
          child: Icon(
            status!.icon,
            color: status!.color,
            size: fontSize + 2,
          ));
    }

    Widget text() {
      var text = dateTime.isToday
          ? dateTime.format().hm(showPeriod: true)
          : dateTime.format().yMMMd();

      return Text(text, style: style?.copyWith(fontSize: fontSize));
    }

    var widget = status == null
        ? text()
        : Row(mainAxisSize: MainAxisSize.min, children: [text(), iconStatus()]);

    return widget.opacity(0.7);
  }
}

class ContextContainer extends StatelessWidget {
  final String? text;
  final TextStyle style;
  const ContextContainer({
    super.key,
    required this.text,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Text(text?.trim() ?? 'TEXT NOT FOUND', style: style);
  }
}

class TitleContainer extends StatelessWidget {
  const TitleContainer({
    super.key,
    required this.title,
    required this.titleStyle,
  });

  final String? title;
  final TextStyle titleStyle;

  @override
  Widget build(BuildContext context) {
    return Text(title!, style: titleStyle);
  }
}

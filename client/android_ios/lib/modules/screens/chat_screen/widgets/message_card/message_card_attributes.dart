import 'package:flutter/material.dart';
import 'package:reConnect/utility/extensions.dart';
import 'package:shared/shared.dart';
import 'package:shared/theme/app_theme.dart';

class MessageCardAttributes {
  final BuildContext context;
  final AppThemeData theme;
  final bool isForClient;

  TextStyle get contentStyle => isForClient
      ? theme.clientMessageContentStyle
      : theme.primaryUserMessageContentStyle;
  TextStyle get captionStyle => isForClient
      ? theme.clientMessageCaptionStyle
      : theme.primaryUserMessageCaptionStyle;

  TextStyle get replyContentStyle => theme.replyContentStyle;
  TextStyle get replyTitleStyle => theme.replyTitleStyle;

  final Message msg;
  MessageCardAttributes.forClient(this.context, this.msg)
      : theme = context.theme,
        isForClient = true;
  MessageCardAttributes.forPrimaryUser(this.context, this.msg)
      : theme = context.theme,
        isForClient = false;

  // Commen Widgets For Both
  Widget msgContent() {
    var children = [
      Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isForClient) ...[displayClientName(), const SizedBox(width: 8)],
            if (msg.reply != null) _replyContainer(msg.reply!),
            if (msg.hasAttachment) _displayAttachments()
          ]),
      Wrap(
        spacing: 8,
        alignment: WrapAlignment.end,
        crossAxisAlignment: WrapCrossAlignment.end,
        children: [
          _msgText(),
          dateTimeStatus(),
        ],
      )
    ];
    return _msgWrap(children: children);
  }

  Text _msgText() => Text(msg.text ?? 'TEXT NOT FOUND');

  _displayAttachments() => Container(
        margin: const EdgeInsets.all(4),
        constraints: BoxConstraints(
          minHeight: 56,
          maxHeight: msg.attachments.first.size?.width ?? 120,
          minWidth: 0,
          maxWidth: msg.attachments.first.size?.width ?? 120,
        ),
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
        child: Image.network(
          msg.attachments.first.assetUrl!,
          fit: BoxFit.cover,
        ),
      );

  Container _replyContainer(Message previousMsg) {
    String name() {
      for (var user in context.primaryUser.contacts) {
        if (user.userId == previousMsg.senderId) return user.name;
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

    var tsf = MediaQuery.of(context).textScaleFactor;

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
              verticalDivider(),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      name(),
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

  Container msgContainer({required Widget child}) {
    var borderRadius = isForClient
        ? theme.decoration.messageBorderRadius(isTopLeft: true)
        : theme.decoration.messageBorderRadius(isbottomRight: true);
    var color = isForClient
        ? theme.colorScheme.clientMessageCard
        : theme.colorScheme.primaryUserMessageCard;

    var defaultWidth = MediaQuery.of(context).size.width * 0.7;
    var maxWidth = msg.hasAttachment
        ? msg.attachments.first.size?.width ?? defaultWidth
        : defaultWidth;
    return Container(
        constraints: BoxConstraints(maxWidth: maxWidth),
        clipBehavior: Clip.hardEdge,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: borderRadius,
        ),
        child: child);
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

  List<Widget> showDeletedMsgAndDataTime() {
    String title = isForClient
        ? context.primaryUser.contacts
            .firstWhere((e) => msg.senderId == e.userId)
            .name
        : 'You';
    return [
      Text('🚫 $title deleted this message', style: contentStyle),
      dateTimeStatus()
    ];
  }

  Wrap _msgWrap({required List<Widget> children}) {
    return Wrap(
      alignment: WrapAlignment.end,
      spacing: 8,
      runSpacing: 4,
      crossAxisAlignment: WrapCrossAlignment.end,
      children: msg.status == MessageStatus.deleted
          ? showDeletedMsgAndDataTime()
          : children,
    );
  }

  // Widget Only For Primary User
  Widget dateTimeStatus() {
    icon() {
      switch (msg.status) {
        case MessageStatus.deleted:
          return (Icons.delete_forever, Colors.red);
        case MessageStatus.sent:
          return (Icons.done, Colors.blueGrey);
        case MessageStatus.seen:
          return (Icons.done_all, Colors.blue);
        case MessageStatus.failed:
          return (Icons.priority_high, Colors.yellow);
        default:
          return (Icons.schedule, Colors.grey);
      }
    }

    iconWidget() => Padding(
        padding: const EdgeInsets.only(left: 3.0),
        child: Icon(icon().$1, color: icon().$2, size: 12));

    Text dateTimeWidget = Text(
        DateTimeFormat(msg.createdAt).hm(showPeriod: true),
        textAlign: TextAlign.end,
        style: captionStyle);

    return msg.status == null
        ? dateTimeWidget
        : Row(mainAxisSize: MainAxisSize.min, children: [
            dateTimeWidget,
            iconWidget(),
          ]);
  }

  // Widget Only For Client
  Text displayClientName() => Text(
      context.primaryUser.contacts
          .firstWhere((e) => msg.senderId == e.userId)
          .name,
      style: theme.clientMessageTitleStyle);
}

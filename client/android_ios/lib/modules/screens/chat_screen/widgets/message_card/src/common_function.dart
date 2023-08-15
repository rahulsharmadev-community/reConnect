import 'package:cached_image/cached_image.dart';
import 'package:flutter/material.dart';
import 'package:reConnect/modules/screens/chat_screen/screens/attachments_preview_screen.dart';
import 'package:reConnect/utility/extensions.dart';
import 'package:shared/shared.dart';
import 'package:shared/theme/app_theme.dart';

@immutable
class CommonFunction {
  final BuildContext context;
  final AppThemeData theme;
  final AppDecoration decoration;
  final AppColorScheme colorScheme;
  CommonFunction(this.context)
      : theme = context.theme,
        decoration = context.theme.decoration,
        colorScheme = context.theme.colorScheme;

  double get defaultWidth => MediaQuery.of(context).size.width * 0.7;

  boxConstraints(double maxWidth) {
    return BoxConstraints(
        maxWidth: maxWidth > defaultWidth ? defaultWidth : maxWidth);
  }

  TextStyle get replyContentStyle => context.theme.replyContentStyle;
  TextStyle get replyTitleStyle => context.theme.replyTitleStyle;

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

  Text msgText(String? text) => Text(text ?? 'TEXT NOT FOUND');

  attachmentContainer(List<Attachment> attachments) => GestureDetector(
        onTap: () => showDialog(
          context: context,
          useSafeArea: false,
          builder: (ctx) => AttachmentsPreviewScreen(images: attachments),
        ),
        child: Container(
          margin: const EdgeInsets.all(4),
          constraints: BoxConstraints(
            minHeight: 56,
            maxHeight: attachments.first.size?.width ?? 120,
            minWidth: 0,
            maxWidth: attachments.first.size?.width ?? 120,
          ),
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
          child: CachedImage(
            attachments.first.assetUrl!,
            fit: BoxFit.cover,
          ),
        ),
      );

  Container replyContainer(Message previousMsg) {
    String name() {
      for (var user in context.primaryUser.contacts.values) {
        if (user.userId == previousMsg.senderId) return user.name;
      }
      return 'You';
    }

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

  Text dateTimeWidget({
    required DateTime dateTime,
    required TextStyle style,
  }) {
    return Text(
      DateTimeFormat(dateTime).hm(showPeriod: true),
      textAlign: TextAlign.end,
      style: style,
    );
  }
}

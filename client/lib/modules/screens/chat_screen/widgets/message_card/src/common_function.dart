import 'package:cached_image/cached_image.dart';
import 'package:flutter/material.dart';
import 'package:reConnect/core/APIs/github_api/github_repository_api.dart';
import 'package:reConnect/modules/screens/chat_screen/screens/attachments_preview_screen.dart';
import 'package:reConnect/utility/cached_locations.dart';
import 'package:reConnect/utility/extensions.dart';
import 'package:shared/shared.dart';

@immutable
class CommonFunction {
  final BuildContext context;
  const CommonFunction(this.context);

  double get defaultWidth => MediaQuery.of(context).size.width * 0.7;

  boxConstraints(double maxWidth) {
    return BoxConstraints(
        maxWidth: maxWidth > defaultWidth ? defaultWidth : maxWidth);
  }

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

  Text msgText(String? text) => Text(text?.trim() ?? 'TEXT NOT FOUND');

  Widget attachmentContainer(List<Attachment> attachments) {
    var file = attachments.first;
    Widget cachedImage = const Gap();
    if (file.type == AttachmentType.image && file.bytes != null) {
      cachedImage = Image.memory(file.bytes!, fit: BoxFit.cover);
    }
    if (file.type == AttachmentType.image && file.assetUrl != null) {
      var git = GitHubRepositorysApi();
      var url = file.assetUrl!;
      if (GitHubRepositorysApi.pVaultUrlCheck(url)) {
        var pVault = git.pVault;
        cachedImage = CachedImage(
          pVault.downloadUrlToPath(url)!,
          loadingBuilder: (p0, p1) => ValueListenableBuilder(
            valueListenable: p1.progressPercentage,
            builder: (context, value, child) => LinearProgressIndicator(
              value: value,
              semanticsValue: value.toString(),
            ),
          ),
          fit: BoxFit.cover,
          headers: pVault.headers,
          response: pVault.bytesFromResponse,
          responseType: RequestResponseType.json,
        );
      } else {
        cachedImage = CachedImage(
          url,
          fit: BoxFit.cover,
          location:
              url.contains(git.gBoard.repository) ? rStickersLocation : null,
          loadingBuilder: (p0, p1) => ValueListenableBuilder(
            valueListenable: p1.progressPercentage,
            builder: (context, value, child) => LinearProgressIndicator(
              value: value,
              semanticsValue: value.toString(),
            ),
          ),
        );
      }
    }
    return GestureDetector(
      onTap: () => showDialog(
        context: context,
        useSafeArea: false,
        builder: (ctx) => AttachmentsPreviewScreen(images: attachments),
      ),
      child: Container(
        margin: const EdgeInsets.all(4),
        constraints: const BoxConstraints(
          minHeight: 56,
          minWidth: 0,
        ),
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
        child: cachedImage,
      ),
    );
  }

  Container replyContainer(
      {required Message previousMsg,
      required TextStyle replyContentStyle,
      required TextStyle replyTitleStyle}) {
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
              _verticalDivider(),
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
}

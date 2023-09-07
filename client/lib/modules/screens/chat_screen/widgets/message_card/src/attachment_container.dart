import 'package:cached_image/cached_image.dart';
import 'package:flutter/material.dart';
import 'package:shared/shared.dart';
import 'package:reConnect/core/APIs/github_api/github_repository_api.dart';
import 'package:reConnect/modules/screens/chat_screen/screens/attachments_preview_screen.dart';
import 'package:reConnect/utility/cached_locations.dart';

class AttachmentContainer extends StatelessWidget {
  final List<Attachment> attachments;
  const AttachmentContainer(this.attachments, {super.key});

  Widget loadingBuilder(BuildContext context, CachedDataProgress progress) {
    return ValueListenableBuilder(
      valueListenable: progress.progressPercentage,
      builder: (context, value, child) => LinearProgressIndicator(
        value: value,
        semanticsValue: value.toString(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          loadingBuilder: loadingBuilder,
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
          loadingBuilder: loadingBuilder,
        );
      }
    }
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          useSafeArea: false,
          builder: (ctx) => AttachmentsPreviewScreen(images: attachments),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(4),
        constraints: const BoxConstraints(minHeight: 56),
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
        child: cachedImage,
      ),
    );
  }
}

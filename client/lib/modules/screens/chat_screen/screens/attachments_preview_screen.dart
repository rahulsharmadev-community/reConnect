import 'package:cached_image/cached_image.dart';
import 'package:flutter/material.dart';
import 'package:jars/widgets/gap.dart';
import 'package:reConnect/core/APIs/github_api/github_repository_api.dart';
import 'package:shared/shared.dart';

class AttachmentsPreviewScreen extends StatelessWidget {
  final String title;
  final dynamic tag;
  final List<Attachment> attachments;
  const AttachmentsPreviewScreen({
    super.key,
    required this.attachments,
    this.title = 'Preview',
    required this.tag,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.share)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
          ],
        ),
        body: PageView.builder(
          itemCount: attachments.length,
          itemBuilder: (context, i) {
            if (attachments[i].type == AttachmentType.image) {
              return InteractiveViewer(
                maxScale: 3,
                child: Hero(
                  tag: tag,
                  child: imageWidget(attachments[i].assetUrl!),
                ),
              );
            } else {
              return const Gap(8);
            }
          },
        ));
  }

  imageWidget(String image) {
    if (GitHubRepositorysApi.pVaultUrlCheck(image)) {
      var git = GitHubRepositorysApi().pVault;
      return CachedImage(
        git.downloadUrlToPath(image)!,
        fit: BoxFit.fitWidth,
        headers: git.headers,
        response: git.bytesFromResponse,
        responseType: RequestResponseType.json,
      );
    } else {
      return CachedImage(
        image,
        fit: BoxFit.fitWidth,
      );
    }
  }
}

import 'package:cached_image/cached_image.dart';
import 'package:flutter/material.dart';
import 'package:reConnect/core/APIs/github_api/github_repository_api.dart';
import 'package:shared/shared.dart';

class AttachmentsPreviewScreen extends StatelessWidget {
  final String title;
  final List<Attachment> images;
  const AttachmentsPreviewScreen({
    super.key,
    required this.images,
    this.title = 'Preview',
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
          itemCount: images.length,
          itemBuilder: (context, i) {
            if (images[i].type == AttachmentType.image) {
              return InteractiveViewer(
                maxScale: 3,
                child: imageWidget(images[i].assetUrl!),
              );
            } else {
              return const Gap();
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
        responseType: 'json',
      );
    } else {
      return CachedImage(
        image,
        fit: BoxFit.fitWidth,
      );
    }
  }
}

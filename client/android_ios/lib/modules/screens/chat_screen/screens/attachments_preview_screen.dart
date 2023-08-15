import 'package:cached_image/cached_image.dart';
import 'package:flutter/material.dart';
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
          itemBuilder: (context, index) {
            return CachedImage(
              images[index].assetUrl!,
              fit: BoxFit.fitWidth,
            );
          },
        ));
  }
}

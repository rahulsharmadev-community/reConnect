import 'dart:typed_data';
import 'package:cached_image/cached_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ImagePreviewScreen extends StatelessWidget {
  final String title;
  final String? url;
  final Uint8List? bytes;
  final VoidCallback? onDone;
  final VoidCallback? onBack;
  const ImagePreviewScreen(
      {super.key,
      this.onDone,
      this.title = 'Preview',
      this.bytes,
      this.url,
      this.onBack})
      : assert(url == null || bytes == null, 'Any one is required.');

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (onBack != null) {
          onBack!();
        } else {
          context.pop();
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(title: Text(title)),
        body: Column(
          children: [
            Expanded(
              child: Center(
                child: url != null
                    ? CachedImage(
                        url!,
                        fit: BoxFit.fitWidth,
                        loadingBuilder: (p0, p1) => SizedBox.fromSize(
                          size: const Size.square(56),
                          child: ValueListenableBuilder(
                            valueListenable: p1.progressPercentage,
                            builder: (context, value, child) =>
                                CircularProgressIndicator(value: value),
                          ),
                        ),
                      )
                    : Image.memory(
                        bytes!,
                        fit: BoxFit.fitWidth,
                      ),
              ),
            ),
            if (onDone != null)
              OutlinedButton(onPressed: onDone, child: const Text('Done'))
          ],
        ),
      ),
    );
  }
}

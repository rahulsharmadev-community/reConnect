import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../chat_blocs/input_handler_bloc/input_handler_bloc.dart';

class AttachmentCard extends StatelessWidget {
  final KeyboardInsertedContent? keyboardInsertedContent;
  final Uint8List? bytes;

  bool get isKiC => keyboardInsertedContent != null;

  /// KiC: keyboardInsertedContent 😅
  const AttachmentCard.forKiC(this.keyboardInsertedContent, {super.key})
      : bytes = null;

  /// general use for device image
  const AttachmentCard.forImage(this.bytes, {super.key})
      : keyboardInsertedContent = null;

  @override
  Widget build(BuildContext context) {
    const boxConstraints = BoxConstraints(
        minHeight: 56, maxHeight: 150, minWidth: 0, maxWidth: double.maxFinite);
    const boxDecoration = BoxDecoration(
        color: Color.fromARGB(255, 100, 105, 114),
        borderRadius: BorderRadius.vertical(top: Radius.circular(14)));
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 22),
          padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
          constraints: boxConstraints,
          clipBehavior: Clip.hardEdge,
          decoration: boxDecoration,
          child: Stack(
            children: [
              if (isKiC)
                Card(
                    margin: const EdgeInsets.fromLTRB(4, 4, 4, 0),
                    clipBehavior: Clip.hardEdge,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    child: Image.memory(keyboardInsertedContent!.data!,)),
              Positioned(
                right: 0,
                top: 0,
                child: InkWell(
                  child: const CircleAvatar(
                    radius: 9,
                    backgroundColor: Colors.black54,
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 13,
                    ),
                  ),
                  onTap: () {
                    if (isKiC) {
                      context
                          .read<InputHandlerBloc>()
                          .add(OnKiCHandler.remove(keyboardInsertedContent!));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

class InputUtils {
  final FocusNode inputFocusNode;
  final TextEditingController inputController;
  final ScrollController chatScrollController;

  bool _isDisposed = false;
  get isDisposed => _isDisposed;
  InputUtils()
      : inputController = TextEditingController(),
        inputFocusNode = FocusNode(),
        chatScrollController = ScrollController();

  void dispose() {
    if (_isDisposed) {
      return;
    }

    inputFocusNode.dispose();
    chatScrollController.dispose();
    inputController.dispose();
    _isDisposed = true;
  }
}

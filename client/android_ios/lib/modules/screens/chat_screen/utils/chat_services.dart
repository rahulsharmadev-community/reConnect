import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

class ChatServices {
  final FocusNode inputFocusNode;
  final TextEditingController inputController;
  final ScrollController chatScrollController;

  bool _isDisposed = false;
  get isDisposed => _isDisposed;
  ChatServices()
      : inputController = TextEditingController(),
        inputFocusNode = FocusNode(),
        chatScrollController = ScrollController() {
    logs('ChatServices Created');
  }

  void dispose() {
    if (_isDisposed) {
      logs('ChatServices is Already Dispose');
      return;
    }
    logs('ChatServices Dispose');
    inputFocusNode.dispose();
    chatScrollController.dispose();
    inputController.dispose();
    _isDisposed = true;
  }
}

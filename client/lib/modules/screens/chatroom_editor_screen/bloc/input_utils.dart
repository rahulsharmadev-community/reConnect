import 'package:flutter/material.dart';

class ChatRoomEditorInputUtils {
  final FocusNode inputFocusNode;
  final TextEditingController profileImg;
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final TextEditingController searchController;

  bool _isDisposed = false;
  get isDisposed => _isDisposed;
  ChatRoomEditorInputUtils()
      : nameController = TextEditingController(),
        profileImg = TextEditingController(),
        descriptionController = TextEditingController(),
        searchController = TextEditingController(),
        inputFocusNode = FocusNode();

  void dispose() {
    if (_isDisposed) {
      return;
    }
    inputFocusNode.dispose();
    nameController.dispose();
    profileImg.dispose();
    descriptionController.dispose();
    searchController.dispose();
    _isDisposed = true;
  }
}

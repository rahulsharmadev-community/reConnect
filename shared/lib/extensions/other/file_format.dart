class FilesFormat {
  final String _string;
  const FilesFormat(String s) : _string = s;

  /// Checks if string is an video file.
  bool get isVideo {
    var ext = _string.toLowerCase();

    return ext.endsWith(".mp4") ||
        ext.endsWith(".avi") ||
        ext.endsWith(".wmv") ||
        ext.endsWith(".rmvb") ||
        ext.endsWith(".mpg") ||
        ext.endsWith(".mpeg") ||
        ext.endsWith(".3gp");
  }

  /// Checks if string is an image file.
  bool get isImage {
    final ext = _string.toLowerCase();

    return ext.endsWith(".jpg") ||
        ext.endsWith(".jpeg") ||
        ext.endsWith(".png") ||
        ext.endsWith(".gif") ||
        ext.endsWith(".bmp");
  }

  /// Checks if string is an audio file.
  bool get isAudio {
    final ext = _string.toLowerCase();

    return ext.endsWith(".mp3") ||
        ext.endsWith(".wav") ||
        ext.endsWith(".wma") ||
        ext.endsWith(".amr") ||
        ext.endsWith(".ogg");
  }

  /// Checks if string is an powerpoint file.
  bool get isPPT {
    final ext = _string.toLowerCase();

    return ext.endsWith(".ppt") || ext.endsWith(".pptx");
  }

  /// Checks if string is an word file.
  bool get isWord {
    final ext = _string.toLowerCase();

    return ext.endsWith(".doc") || ext.endsWith(".docx");
  }

  /// Checks if string is an excel file.
  bool get isExcel {
    final ext = _string.toLowerCase();

    return ext.endsWith(".xls") || ext.endsWith(".xlsx");
  }

  /// Checks if string is an apk file.
  bool get isAPK {
    return _string.toLowerCase().endsWith(".apk");
  }

  /// Checks if string is an pdf file.
  bool get isPDF {
    return _string.toLowerCase().endsWith(".pdf");
  }

  /// Checks if string is an txt file.
  bool get isTxt {
    return _string.toLowerCase().endsWith(".txt");
  }

  /// Checks if string is an chm file.
  bool get isChm {
    return _string.toLowerCase().endsWith(".chm");
  }

  /// Checks if string is a vector file.
  bool get isVector {
    return _string.toLowerCase().endsWith(".svg");
  }

  /// Checks if string is an html file.
  bool get isHTML {
    return _string.toLowerCase().endsWith(".html");
  }
}

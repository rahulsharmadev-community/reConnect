class FilesFormat {
  final String ext;
  FilesFormat(String fullPath, [String endAt = '.'])
      : ext = get(fullPath.toLowerCase(), endAt);

  static String get(String str, [String endAt = '.']) {
    String buffer = '';
    for (var i = str.length - 1; i >= 0; i--) {
      if (str[i] == endAt) break;
      buffer = str[i] + buffer;
    }
    return '.$buffer';
  }

  /// Checks if string is an video file.
  bool get isVideo =>
      ext == ".mp4" ||
      ext == ".avi" ||
      ext == ".wmv" ||
      ext == ".rmvb" ||
      ext == ".mpg" ||
      ext == ".mpeg" ||
      ext == ".3gp";

  /// Checks if string is an
  /// Flutter Supported image file.
  bool get isImage =>
      ext == ".webp" ||
      ext == ".jpg" ||
      ext == ".jpeg" ||
      ext == ".png" ||
      ext == ".gif" ||
      ext == ".bmp";

  /// Checks if string is an audio file.
  bool get isAudio =>
      ext == ".mp3" ||
      ext == ".wav" ||
      ext == ".wma" ||
      ext == ".amr" ||
      ext == ".ogg";

  /// Checks if string is an powerpoint file.
  bool get isPPT => ext == ".ppt" || ext == ".pptx";

  /// Checks if string is an word file.
  bool get isWord => ext == ".doc" || ext == ".docx";

  /// Checks if string is an excel file.
  bool get isExcel => ext == ".xls" || ext == ".xlsx";

  /// Checks if string is an apk file.
  bool get isAPK => ext == ".apk";

  /// Checks if string is an pdf file.
  bool get isPDF => ext == ".pdf";

  /// Checks if string is an txt file.
  bool get isTxt => ext == ".txt";

  /// Checks if string is an chm file.
  bool get isChm => ext == ".chm";

  /// Checks if string is a vector file.
  bool get isSVG => ext == ".svg";

  /// Checks if string is an html file.
  bool get isHTML => ext == ".html";
}

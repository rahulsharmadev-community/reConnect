class FilesFormat {
  final String _ext;
  FilesFormat(String path, [String endAt = '.'])
      : assert(path.isNotEmpty, "path shouldn't be empty"),
        _ext = get(path.toLowerCase(), endAt);

  static String get(String str, [String endAt = '.']) {
    if (!str.contains('.')) return str;

    var last = str.lastIndexOf('?');
    return str.substring(str.lastIndexOf(endAt) + 1, last == -1 ? null : last);
  }

  /// Checks if string is an video file
  bool get isVideo =>
      _ext == "mp4" ||
      _ext == "avi" ||
      _ext == "wmv" ||
      _ext == "rmvb" ||
      _ext == "mpg" ||
      _ext == "mpeg" ||
      _ext == "3gp";

  /// Checks if string is an
  /// Flutter Supported image file
  bool get isImage =>
      _ext == "webp" ||
      _ext == "jpg" ||
      _ext == "jpeg" ||
      _ext == "png" ||
      _ext == "gif" ||
      _ext == "bmp";

  /// Checks if string is an audio file
  bool get isAudio =>
      _ext == "mp3" ||
      _ext == "wav" ||
      _ext == "wma" ||
      _ext == "amr" ||
      _ext == "ogg";

  /// Checks if string is an powerpoint file
  bool get isPPT => _ext == "ppt" || _ext == "pptx";

  /// Checks if string is an word file
  bool get isWord => _ext == "doc" || _ext == "docx";

  /// Checks if string is an excel file
  bool get isExcel => _ext == "xls" || _ext == "xlsx";

  /// Checks if string is an apk file
  bool get isAPK => _ext == "apk";

  /// Checks if string is an pdf file
  bool get isPDF => _ext == "pdf";

  /// Checks if string is an txt file
  bool get isTxt => _ext == "txt";

  /// Checks if string is an chm file
  bool get isChm => _ext == "chm";

  /// Checks if string is a vector file
  bool get isSVG => _ext == "svg";

  /// Checks if string is an html file
  bool get isHTML => _ext == "html";

  @override
  String toString() => _ext;
}

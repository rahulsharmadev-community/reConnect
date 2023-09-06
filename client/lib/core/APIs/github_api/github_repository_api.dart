import 'dart:convert';

import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:reConnect/tokens/github.repo.token.dart' as token;

/// pVault: Use personal vault to store user-encrypted data.\
/// gBoard: Used to store google board data such as gifs and stickers
class GitHubRepositorysApi {
  // Google Board
  final GitHubRepositoryService gBoard;

  // Personal Vault
  final GitHubRepositoryService pVault;

  GitHubRepositorysApi()
      : gBoard = GitHubRepositoryService.formMap(token.gBoard),
        pVault = GitHubRepositoryService.formMap(token.pVault);

  static gBoardUrlCheck(String url) {
    var p = [token.gBoard['owner']!, token.gBoard['repository']!].join('.*');
    return url.contains(RegExp(p));
  }

  static pVaultUrlCheck(String url) {
    var p = [token.pVault['owner']!, token.pVault['repository']!].join('.*');
    return url.contains(RegExp(p));
  }
}

class GitHubRepositoryService {
  final String domain, owner, repository, token, branch, downloadDomain;
  final Dio _dio;

  GitHubRepositoryService.formMap(Map<String, String> map)
      : owner = map['owner']!,
        repository = map['repository']!,
        token = map['token']!,
        branch = map['branch']!,
        domain = map['domain']!,
        downloadDomain = map['downloadDomain']!,
        _dio = Dio();

  String getPath(String path) =>
      '$domain/repos/$owner/$repository/contents/$path';

  String getDownloadUri([String path = '']) {
    if (domain == downloadDomain) return getPath(path);
    return '$downloadDomain/$owner/$repository/$branch/$path';
  }

  Map<String, String> get headers => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

  /// Checks if a file exists at the specified filePath in gitHub repository
  /// using a HEAD request with [Dio] HTTP client.
  Future<bool> isFileExist(String filePath) async {
    try {
      final response = await _dio.head(getPath(filePath));
      return response.statusCode == 200 ? true : false;
    } catch (e) {
      return false;
    }
  }

  /// Uploads bytes of a file to a specified filePath on gitHub repository
  /// using Dio HTTP client.
  Future<String> uploadBytes(String filePath, Uint8List bytes) async {
    // Check if the file already exists at the specified filePath.
    // If the file exists, return the download URI of the existing file.
    if (await isFileExist(filePath)) return getDownloadUri(filePath);

    final content = {
      'message': 'Upload image file',
      'branch': branch,
      'content': base64Encode(bytes), // bytes to string
    };

    try {
      final response = await _dio.put(
        getPath(filePath),
        data: jsonEncode(content),
        options: Options(headers: headers),
      );

      if (response.statusCode != 201) {
        throw 'Failed to upload image. Status code: ${response.statusCode}';
      }
    } catch (e) {
      throw 'Failed to upload image. Status code: $e';
    }
    return getDownloadUri(filePath);
  }

  /// Download bytes of a file to a specified filePath on gitHub repository
  /// using Dio HTTP client.
  ///
  /// Only Support when [domain == downloadDomain]
  Future<Uint8List> downloadByte(String url,
      {Function(int, int)? onReceiveProgress}) async {
    String filePath = downloadUrlToPath(url)!;
    try {
      final response = await _dio.get('$filePath?ref=$branch',
          options: Options(headers: headers),
          onReceiveProgress: onReceiveProgress);

      if (response.statusCode != 201) {
        throw 'Failed to upload image. Status code: ${response.statusCode}';
      }
      return bytesFromResponse(response.data);
    } catch (e) {
      throw 'Failed to upload image. Status code: $e';
    }
  }

  Future<Uint8List> bytesFromResponse(dynamic data,
      [Function(int, int)? onReceiveProgress]) async {
    var content = (data['content'] as String).replaceAll(RegExp(r'\s'), '');
    if (content.isEmpty) {
      var resp = await Dio().get<Uint8List>(data['download_url'] as String,
          options: Options(responseType: ResponseType.bytes),
          onReceiveProgress: onReceiveProgress);
      return resp.data!;
    }
    Uint8List base64decode = base64Decode(content);
    return base64decode;
  }

  String? downloadUrlToPath(String url) {
    if (url.startsWith(domain)) return url;
    if (url.startsWith(downloadDomain)) {
      return getPath(url.replaceFirst(getDownloadUri(), ''));
    }
    return null;
  }
}

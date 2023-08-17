import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';

/// pVault: Use personal vault to store user-encrypted data.\
/// gBoard: Used to store google board data such as gifs and stickers
class GitHubRepositorysApi {
  // Google Board
  final GitHubRepositoryService gBoard;

  // Personal Vault
  final GitHubRepositoryService pVault;

  GitHubRepositorysApi()
      : gBoard = GitHubRepositoryService(),
        pVault = GitHubRepositoryService();
}


class GitHubRepositoryService {
  final String domain, owner, repository, token, branch, downloadDomain;
  final Dio _dio;

  String getUri(String path) =>
      '$domain/repos/$owner/$repository/contents/$path';

  String getDownloadUri(String path) =>
      '$downloadDomain/$owner/$repository/$branch/$path';

  GitHubRepositoryService(
      [this.owner = 'goku-org',
      this.repository = 'g-board',
      this.token =
          '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',
      this.branch = 'main'])
      : domain = 'https://api.github.com',
        downloadDomain = 'https://raw.githubusercontent.com',
        _dio = Dio();

  /// Fetches the bytes of a file from a specified filePath from
  /// github repository using Dio HTTP client.
  Future<Uint8List?> getBytes(String filePath) async {
    try {
      final response = await _dio.get(
        getUri(filePath),
        options: Options(responseType: ResponseType.bytes),
      );
      return response.statusCode == 200 ? response.data : null;
    } catch (e) {
      return null;
    }
  }

  /// Checks if a file exists at the specified filePath in gitHub repository
  /// using a HEAD request with [Dio] HTTP client.
  Future<bool> isExist(String filePath) async {
    try {
      final response = await _dio.head(getUri(filePath));
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
    if (await isExist(filePath)) return getDownloadUri(filePath);

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final content = {
      'message': 'Upload image file',
      'branch': branch,
      'content': base64Encode(bytes), // bytes to string
    };

    try {
      final response = await _dio.put(
        getUri(filePath),
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
}

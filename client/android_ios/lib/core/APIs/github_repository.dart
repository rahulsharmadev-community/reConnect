import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';

/// pVault: Use personal vault to store user-encrypted data.\
/// gBoard: Used to store google board data such as gifs and stickers
class GitHubRepositorys {
  // Google Board
  final GitHubRepositoryService gBoard;

  // Personal Vault
  final GitHubRepositoryService pVault;

  GitHubRepositorys()
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

  Future<bool> isExist(String filePath) async {
    try {
      final response = await _dio.head(getUri(filePath));
      return response.statusCode == 200 ? true : false;
    } catch (e) {
      return false;
    }
  }

  Future<String> uploadBytes(String filePath, Uint8List bytes) async {
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

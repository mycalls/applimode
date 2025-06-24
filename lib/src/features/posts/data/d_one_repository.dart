import 'dart:convert';

// external
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:http/http.dart' as http;

// core
import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/src/core/constants/constants.dart';

// utils
import 'package:applimode_app/src/utils/custom_headers.dart';
import 'package:applimode_app/src/utils/string_converter.dart';
import 'package:applimode_app/src/utils/url_converter.dart';

part 'd_one_repository.g.dart';

class DOneRepository {
  const DOneRepository();

  // static const baseUrl = dOneBaseUrl;
  static const postsBasePath = '/api/posts';
  static const searchLimit = 20;

  String get baseUrl => UrlConverter.stripUrl(dOneBaseUrl);

  Future<List<String>> getPostsSearchPage(String search, [int? start]) async {
    final optimized = StringConverter.toSearch(search);
    final url = Uri.https(
      baseUrl,
      postsBasePath,
      <String, String>{
        'q': optimized,
        if (start != null) 's': start.toString(),
      },
    );
    final response = await http.get(
      url,
      headers: {
        ...rTwoSecureHeader,
        "Content-Type": contentJson,
      },
    );
    final data = (jsonDecode(response.body) as List<dynamic>)
        .map((e) => e['pid'] as String)
        .toList();
    return data;
  }

  Future<List<String>> getPostsSearchAll(String search) async {
    final optimized = StringConverter.toSearch(search);
    final url = Uri.https(
      baseUrl,
      '$postsBasePath/all',
      <String, String>{
        'q': optimized,
      },
    );
    final response = await http.get(
      url,
      headers: {
        ...rTwoSecureHeader,
        "Content-Type": contentJson,
      },
    );
    final data = (jsonDecode(response.body) as List<dynamic>)
        .map((e) => e['pid'] as String)
        .toList();
    return data;
  }

  Future<void> postPostsSearch(String postId, String search) async {
    final url = Uri.https(baseUrl, '$postsBasePath/$postId');
    http.post(
      url,
      headers: {
        ...rTwoSecureHeader,
        "Content-Type": "text/plain",
      },
      body: search,
    );
  }

  Future<void> putPostsSearch(String postId, String search) async {
    final url = Uri.https(baseUrl, '$postsBasePath/$postId');
    http.put(
      url,
      headers: {
        ...rTwoSecureHeader,
        "Content-Type": "text/plain",
      },
      body: search,
    );
  }

  Future<void> deletePostsSearch(String postId) async {
    final url = Uri.https(baseUrl, '$postsBasePath/$postId');
    http.delete(
      url,
      headers: rTwoSecureHeader,
    );
  }
}

@riverpod
DOneRepository dOneRepository(Ref ref) {
  return const DOneRepository();
}

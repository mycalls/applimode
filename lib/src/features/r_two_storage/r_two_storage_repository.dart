import 'dart:convert';

import 'package:applimode_app/src/utils/custom_headers.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:applimode_app/src/constants/constants.dart';
import 'package:applimode_app/custom_settings.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:applimode_app/src/utils/upload_progress_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'r_two_storage_repository.g.dart';

class RTwoStorageRepository {
  const RTwoStorageRepository(this._ref);

  final Ref _ref;

  static const baseUrl = rTwoBaseUrl;
  static const domainUrl = cfDomainUrl;

  Future<Uint8List> getBytes(XFile file) async {
    final bytes = await file.readAsBytes();
    debugPrint('uploadXfile: Bytes done');
    return bytes;
  }

  Future<String> uploadBytes({
    required Uint8List bytes,
    required String storagePathname,
    required String filename,
    String contentType = contentTypeJpeg,
    bool showPercentage = true,
    int index = 0,
  }) async {
    final url = Uri.https(baseUrl, '/$storagePathname/$filename');
    final dio = Dio();
    final response = await dio.put(
      url.toString(),
      data: bytes,
      options: Options(headers: {
        ...rTwoSecureHeader,
        'Content-Type': contentType,
      }),
      onSendProgress: (count, total) {
        if (showPercentage) {
          final percent = 100 * (count / total);
          _ref
              .read(uploadProgressStateProvider.notifier)
              .set(index, percent.toInt());
        }
      },
    );
    /*
    final response = await http.put(
      url,
      body: bytes,
      headers: {
        ...rTwoSecureHeader,
        'Content-Type': contentType,
      },
    );
    */
    final cdnStoragePathname = storagePathname.replaceAll('/', '%2F');
    debugPrint('${response.statusCode}');
    return useCfCdn
        ? 'https://$domainUrl/$cdnStoragePathname%2F$filename'
        : 'https://$baseUrl/$storagePathname/$filename';
  }

  Future<void> deleteAsset(String url) => http.delete(
        Uri.parse(url.replaceAll(domainUrl, baseUrl).replaceAll('%2F', '/')),
        headers: rTwoSecureHeader,
      );

  Future<void> deleteAssetsList(String prefix) async {
    final url = Uri.https(baseUrl, '/', {'prefix': prefix});

    final response = await http.get(
      url,
      headers: rTwoSecureHeader,
    );
    final data = (jsonDecode(response.body)['objects'] as List<dynamic>)
        .map((e) => e['key'] as String)
        .toList();
    if (data.isNotEmpty) {
      for (var item in data) {
        final url = Uri.https(baseUrl, '/$item');
        http.delete(
          url,
          headers: rTwoSecureHeader,
        );
      }
    }
  }
}

@riverpod
RTwoStorageRepository rTwoStorageRepository(RTwoStorageRepositoryRef ref) {
  return RTwoStorageRepository(ref);
}

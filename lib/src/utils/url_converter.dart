// flutter
import 'package:flutter/foundation.dart';

// core
import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/src/core/constants/constants.dart';

class UrlConverter {
  const UrlConverter();

  static String getIosWebVideoUrl(String videoUrl) {
    if (kIsWeb &&
        defaultTargetPlatform == TargetPlatform.iOS &&
        !videoUrl.startsWith(firebaseStorageUrlHead) &&
        !videoUrl.startsWith(gcpStorageUrlHead) &&
        !videoUrl.startsWith('https://${stripUrl(rTwoBaseUrl)}') &&
        !videoUrl.startsWith('https://${stripUrl(cfDomainUrl)}')) {
      return '$videoUrl#t=0.001';
    } else {
      return videoUrl;
    }
  }

  static String stripUrl(String url) {
    String newUrl = url.replaceAll('https://', '').replaceAll('http://', '');
    if (newUrl.endsWith('/')) {
      newUrl = newUrl.substring(0, newUrl.length - 1);
    }
    return newUrl;
  }
}

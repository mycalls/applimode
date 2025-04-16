import 'package:flutter/foundation.dart';
import 'package:applimode_app/src/utils/web_image_compress/wic_helper.dart'
    // if (dart.library.html) 'package:applimode_app/src/utils/web_image_compress/wic_web.dart'
    if (dart.library.js_interop) 'package:applimode_app/src/utils/web_image_compress/wic_web.dart'
    if (dart.library.io) 'package:applimode_app/src/utils/web_image_compress/wic_io.dart';

abstract class WicStub {
  Future<Uint8List> changeImageQuality({
    required String imageUrl,
    required int quality,
    int maxWidthThreshold = 1080,
    String outputMimeType = 'image/jpeg',
  });
  factory WicStub() => getInstance();
}

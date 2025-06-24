// flutter
import 'package:flutter/foundation.dart';

// utils
import 'package:applimode_app/src/utils/web_video_thumbnail/wvt_helper.dart'
    // if (dart.library.html) 'package:applimode_app/src/utils/web_video_thumbnail/wvt_web.dart'
    if (dart.library.js_interop) 'package:applimode_app/src/utils/web_video_thumbnail/wvt_web.dart'
    if (dart.library.io) 'package:applimode_app/src/utils/web_video_thumbnail/wvt_io.dart';

abstract class WvtStub {
  Future<Uint8List> getThumbnailData({
    required String video,
    required int maxWidth,
    required int maxHeight,
    required int quality,
    Map<String, String>? headers,
  });
  factory WvtStub() => getInstance();
}

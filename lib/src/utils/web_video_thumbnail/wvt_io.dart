// flutter
import 'package:flutter/foundation.dart';

// utils
import 'package:applimode_app/src/utils/web_video_thumbnail/wvt_stub.dart';

WvtStub getInstance() => const WvtIo();

class WvtIo implements WvtStub {
  const WvtIo();

  @override
  Future<Uint8List> getThumbnailData({
    required String video,
    required int maxHeight,
    required int maxWidth,
    required int quality,
    Map<String, String>? headers,
  }) async {
    return Uint8List(0);
  }
}

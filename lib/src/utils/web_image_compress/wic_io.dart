import 'package:applimode_app/src/utils/web_image_compress/wic_stub.dart';
import 'package:flutter/foundation.dart';

WicStub getInstance() => const WicIo();

class WicIo implements WicStub {
  const WicIo();

  @override
  Future<Uint8List> changeImageQuality({
    required String imageUrl,
    required int quality,
    int maxWidthThreshold = 1080,
    String outputMimeType = 'image/jpeg',
  }) async {
    return Uint8List(0);
  }
}

// external
import 'package:web/web.dart';

// utils
import 'package:applimode_app/src/utils/web_back/web_back_stub.dart';

WebBackStub getInstance() => WebBackWeb();

/// A web implementation of the VideoThumbnailPlatform of the VideoThumbnail plugin.
class WebBackWeb implements WebBackStub {
  WebBackWeb();

  @override
  void back() {
    window.history.back();
  }
}

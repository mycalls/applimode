// utils
import 'package:applimode_app/src/utils/web_back/web_back_helper.dart'
    // if (dart.library.html) 'package:applimode_app/src/utils/web_back/web_back_web.dart'
    if (dart.library.js_interop) 'package:applimode_app/src/utils/web_back/web_back_web.dart'
    if (dart.library.io) 'package:applimode_app/src/utils/web_back/web_back_io.dart';

abstract class WebBackStub {
  void back();
  factory WebBackStub() => getInstance();
}

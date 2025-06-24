// utils
import 'package:applimode_app/src/utils/web_back/web_back_stub.dart';

WebBackStub getInstance() => const WebBackIo();

class WebBackIo implements WebBackStub {
  const WebBackIo();

  @override
  void back() {}
}

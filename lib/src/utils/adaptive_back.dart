// flutter
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

// external
import 'package:go_router/go_router.dart';

// utils
import 'package:applimode_app/src/utils/web_back/web_back_stub.dart';

void adaptiveBack(BuildContext context) {
  try {
    if (kIsWeb) {
      WebBackStub().back();
    } else {
      if (context.canPop()) {
        context.pop();
      }
    }
  } catch (e) {
    debugPrint(e.toString());
  }
}

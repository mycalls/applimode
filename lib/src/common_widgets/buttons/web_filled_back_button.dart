// flutter
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// utils
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';
import 'package:applimode_app/src/utils/web_back/web_back_stub.dart';

class WebFilledBackButton extends StatelessWidget {
  const WebFilledBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: () {
        if (kIsWeb) {
          WebBackStub().back();
        }
      },
      child: Text(context.loc.goBack),
    );
  }
}

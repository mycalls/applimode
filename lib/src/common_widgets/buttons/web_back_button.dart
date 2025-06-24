// flutter
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// utils
import 'package:applimode_app/src/utils/web_back/web_back_stub.dart';

class WebBackButton extends StatelessWidget {
  const WebBackButton({super.key, this.color});

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        if (kIsWeb) {
          WebBackStub().back();
        }
      },
      icon: const Icon(Icons.chevron_left),
      color: color,
    );
  }
}

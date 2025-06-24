// flutter
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// common widgets
import 'package:applimode_app/src/common_widgets/responsive_widget.dart';
import 'package:applimode_app/src/common_widgets/buttons/filled_back_button.dart';
import 'package:applimode_app/src/common_widgets/buttons/filled_home_button.dart';
import 'package:applimode_app/src/common_widgets/buttons/web_filled_back_button.dart';
import 'package:applimode_app/src/common_widgets/error_widgets/error_message_text.dart';

class ErrorMessageButton extends StatelessWidget {
  const ErrorMessageButton({
    super.key,
    required this.errorMessage,
    this.isHome = false,
  });

  final String errorMessage;
  final bool isHome;

  @override
  Widget build(BuildContext context) {
    return ResponsiveCenterScrollView(
      child: Column(
        children: [
          ErrorMessageText(
            errorMessage: errorMessage,
          ),
          const SizedBox(height: 16),
          isHome
              ? const FilledHomeButton()
              : kIsWeb
                  ? const WebFilledBackButton()
                  : const FilledBackButton(),
        ],
      ),
    );
  }
}

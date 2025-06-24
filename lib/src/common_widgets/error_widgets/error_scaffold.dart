// flutter
import 'package:flutter/material.dart';

// utils
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';

// common widgets
import 'package:applimode_app/src/common_widgets/error_widgets/error_message_button.dart';

class ErrorScaffold extends StatelessWidget {
  const ErrorScaffold({
    super.key,
    required this.errorMessage,
    this.isHome = false,
  });

  final String errorMessage;
  final bool isHome;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.loc.error),
      ),
      body: ErrorMessageButton(
        errorMessage: errorMessage,
        isHome: isHome,
      ),
    );
  }
}

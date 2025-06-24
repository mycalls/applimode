import 'dart:developer' as dev;

// flutter
import 'package:flutter/material.dart';

// external
import 'package:flutter_riverpod/flutter_riverpod.dart';

// utils
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';
import 'package:applimode_app/src/utils/show_adaptive_alert_dialog.dart';
import 'package:applimode_app/src/utils/show_message_snack_bar.dart';

extension AsyncValueUI on AsyncValue {
  void showAlertDialogOnError(
    BuildContext context, {
    String? content,
  }) {
    dev.log('AsyncValueUi - isLoading: $isLoading, hasError: $hasError');
    if (!isLoading && hasError) {
      final message = error.toString();
      debugPrint('AsyncValueUIError: $message');
      showAdaptiveAlertDialog(
        context: context,
        title: context.loc.error,
        content: content ?? context.loc.tryLater,
      );
    }
  }

  void showMessageSnackBarOnError(
    BuildContext context, {
    String? content,
  }) {
    dev.log('AsyncValueUi - isLoading: $isLoading, hasError: $hasError');
    if (!isLoading && hasError) {
      final message = error.toString();
      debugPrint('AsyncValueUIError: $message');
      showMessageSnackBar(
        context,
        content ?? context.loc.tryLater,
      );
    }
  }
}

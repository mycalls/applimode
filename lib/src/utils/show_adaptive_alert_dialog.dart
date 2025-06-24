// flutter
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// utils
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';

Future<bool?> showAdaptiveAlertDialog({
  required BuildContext context,
  String? title,
  String? content,
  bool hasCancel = false,
  String? cancelActionText,
  String? defaultActionText,
  VoidCallback? cancelAction,
  VoidCallback? defaultAction,
}) async {
  Widget adaptiveAction({
    required BuildContext context,
    required VoidCallback onPressed,
    required Widget child,
  }) {
    final ThemeData theme = Theme.of(context);
    switch (theme.platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return TextButton(onPressed: onPressed, child: child);
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return CupertinoDialogAction(onPressed: onPressed, child: child);
    }
  }

  return showAdaptiveDialog(
    context: context,
    builder: (context) => AlertDialog.adaptive(
      title: title == null ? null : Text(title),
      content: content == null ? null : Text(content),
      actions: [
        if (hasCancel)
          adaptiveAction(
            context: context,
            onPressed: cancelAction ?? () => Navigator.of(context).pop(false),
            child: cancelActionText == null
                ? Text(context.loc.cancel)
                : Text(cancelActionText),
          ),
        adaptiveAction(
          context: context,
          onPressed: defaultAction ?? () => Navigator.of(context).pop(true),
          child: defaultActionText == null
              ? Text(context.loc.ok)
              : Text(defaultActionText),
        ),
      ],
    ),
  );
}

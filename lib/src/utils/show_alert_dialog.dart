// flutter
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Future<bool?> showAlertDialog({
  required BuildContext context,
  required String title,
  String? content,
  String? cancelActionText,
  required String defaultActionText,
}) async {
  if (kIsWeb || defaultTargetPlatform == TargetPlatform.android) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: content == null ? null : Text(content),
        actions: <Widget>[
          if (cancelActionText != null)
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(cancelActionText),
            ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(defaultActionText),
          ),
        ],
      ),
    );
  }
  return showCupertinoDialog<bool>(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      title: Text(title),
      content: content == null ? null : Text(content),
      actions: [
        if (cancelActionText != null)
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelActionText),
          ),
        CupertinoDialogAction(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(defaultActionText),
        ),
      ],
    ),
  );
}

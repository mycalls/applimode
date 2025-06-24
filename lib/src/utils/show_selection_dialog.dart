// flutter
import 'package:flutter/material.dart';

Future<T?> showSelectionDialog<T>({
  required BuildContext context,
  required String firstTitle,
  VoidCallback? firstTap,
  required String secondTitle,
  VoidCallback? secondTap,
  String? thirdTitle,
  VoidCallback? thirdTap,
}) async {
  return showDialog(
    context: context,
    builder: (context) => SimpleDialog(
      children: [
        TextButton(
          onPressed: firstTap,
          child: Text(firstTitle),
        ),
        const Divider(),
        TextButton(
          onPressed: secondTap,
          child: Text(secondTitle),
        ),
        if (thirdTitle != null) ...[
          const Divider(),
          TextButton(
            onPressed: thirdTap,
            child: Text(thirdTitle),
          ),
        ]
      ],
    ),
  );
}

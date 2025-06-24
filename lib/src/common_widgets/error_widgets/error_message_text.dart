// flutter
import 'package:flutter/material.dart';

class ErrorMessageText extends StatelessWidget {
  const ErrorMessageText({
    super.key,
    required this.errorMessage,
  });

  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      errorMessage,
      style:
          theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.error),
      textAlign: TextAlign.center,
    );
  }
}

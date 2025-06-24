// flutter
import 'package:flutter/material.dart';

class ProfileTextButton extends StatelessWidget {
  const ProfileTextButton({
    super.key,
    required this.label,
    this.padding =
        const EdgeInsets.only(top: 16, bottom: 16, left: 24, right: 8),
    this.onPressed,
  });

  final String label;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(padding: WidgetStatePropertyAll(padding)),
      onPressed: onPressed,
      child: Text(
        label,
        style: Theme.of(context)
            .textTheme
            .headlineSmall
            ?.copyWith(color: Colors.white),
      ),
    );
  }
}

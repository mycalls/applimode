// flutter
import 'package:flutter/material.dart';

class TitleTextWidget extends StatelessWidget {
  const TitleTextWidget({
    super.key,
    required this.title,
    this.textStyle,
    this.textAlign,
    this.maxLines,
  });

  final String title;
  final TextStyle? textStyle;
  final TextAlign? textAlign;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: textStyle ?? Theme.of(context).textTheme.titleMedium,
      textAlign: textAlign,
      overflow: TextOverflow.ellipsis,
      maxLines: maxLines ?? 1,
    );
  }
}

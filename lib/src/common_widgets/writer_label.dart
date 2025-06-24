// flutter
import 'package:flutter/material.dart';

// utils
import 'package:applimode_app/src/utils/format.dart';

class WriterLabel extends StatelessWidget {
  const WriterLabel({
    super.key,
    required this.color,
    this.count = 0,
    this.label,
    this.labelSize,
    this.iconData,
  });

  final Color color;
  final int count;
  final String? label;
  final double? labelSize;
  final IconData? iconData;

  @override
  Widget build(BuildContext context) {
    final formattedCount = Format.formatNumber(context, count);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(Radius.circular(4)),
      ),
      child: Row(
        children: [
          if (iconData != null)
            Icon(
              iconData,
              color: Colors.white,
              size: labelSize ?? 10,
            ),
          Text(
            '${label ?? ''} $formattedCount',
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Colors.white,
                  fontSize: labelSize ?? 10,
                ),
          ),
        ],
      ),
    );
  }
}

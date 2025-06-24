// flutter
import 'package:flutter/material.dart';

// external
import 'package:flutter_riverpod/flutter_riverpod.dart';

// core
import 'package:applimode_app/src/core/app_states/upload_progress_state.dart';

// utils
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';

class PercentCircularIndicator extends ConsumerWidget {
  const PercentCircularIndicator({
    super.key,
    this.showPercentage = true,
    this.showIndex = false,
    this.circleSize = 96.0,
    this.strokeWidth = 8.0,
    this.backgroundColor,
    this.customString,
  });

  final bool showPercentage;
  final bool showIndex;
  final double circleSize;
  final double strokeWidth;
  final Color? backgroundColor;
  final String? customString;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final primary = Theme.of(context).colorScheme.primary;
    // If not centered, padding left 28
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(48),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
          borderRadius: const BorderRadius.all(Radius.circular(24))),
      child: !showPercentage && !showIndex
          ? FabIndicatorContent(
              showPercentage: false,
              showIndex: false,
              circleSize: circleSize,
              strokeWidth: strokeWidth,
              backgroundColor: backgroundColor,
              customString: customString,
            )
          : Consumer(
              builder: (context, ref, child) {
                final uploadState = ref.watch(uploadProgressStateProvider);
                return FabIndicatorContent(
                  showPercentage: showPercentage,
                  showIndex: showIndex,
                  circleSize: circleSize,
                  strokeWidth: strokeWidth,
                  backgroundColor: backgroundColor,
                  percentage: uploadState.percentage,
                  index: uploadState.index,
                  customString: customString,
                );
              },
            ),
    );
  }
}

class FabIndicatorContent extends StatelessWidget {
  const FabIndicatorContent({
    super.key,
    this.showPercentage = true,
    this.showIndex = false,
    this.circleSize = 96.0,
    this.strokeWidth = 2.0,
    this.backgroundColor,
    this.percentage,
    this.index,
    this.customString,
  });

  final bool showPercentage;
  final bool showIndex;
  final double circleSize;
  final double strokeWidth;
  final Color? backgroundColor;
  final int? percentage;
  final int? index;
  final String? customString;

  @override
  Widget build(BuildContext context) {
    const defaultColor = Colors.white;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: circleSize,
              height: circleSize,
              child: CircularProgressIndicator(
                strokeWidth: strokeWidth,
                color: backgroundColor ?? defaultColor,
                // backgroundColor: backgroundColor,
              ),
            ),
            if (showPercentage && percentage != null)
              Text(
                '$percentage%',
                style: TextStyle(
                    fontSize: 16,
                    color: backgroundColor ?? defaultColor,
                    fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
          ],
        ),
        if (showIndex && index != null) ...[
          const SizedBox(height: 24),
          Text(
            '${context.loc.uploadingFile} ${index! + 1}',
            textAlign: TextAlign.center,
            style: TextStyle(color: backgroundColor ?? defaultColor),
            overflow: TextOverflow.ellipsis,
          )
        ],
        if (customString != null) ...[
          const SizedBox(height: 24),
          Text(
            customString!,
            textAlign: TextAlign.center,
            style: TextStyle(color: backgroundColor ?? defaultColor),
            overflow: TextOverflow.ellipsis,
          )
        ]
      ],
    );
  }
}

import 'dart:math';

// flutter
import 'package:flutter/material.dart';

// external
import 'package:flutter_riverpod/flutter_riverpod.dart';

// core
import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/src/core/constants/constants.dart';

// features
import 'package:applimode_app/src/features/admin_settings/application/admin_settings_service.dart';

class GradientColorBox extends ConsumerWidget {
  const GradientColorBox({
    super.key,
    this.index,
    this.child,
  });

  final int? index;
  final Widget? child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boxColorType = ref.watch(adminSettingsProvider).boxColorType;
    final hasIndex = index != null;
    final singleColorCount = hasIndex
        ? index! % boxSingleColors.length
        : Random().nextInt(boxSingleColors.length);
    final gradientColorCount = hasIndex
        ? index! % boxGradientColors.length
        : Random().nextInt(boxGradientColors.length);
    final singleColor = boxSingleColors[singleColorCount];
    final firstColor = boxGradientColors[gradientColorCount][0];
    final secondColor = boxGradientColors[gradientColorCount][1];

    return Container(
      decoration: BoxDecoration(
        color: singleColor,
        gradient: boxColorType == BoxColorType.gradient
            ? LinearGradient(
                // stops: const [0.2, 0.6],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [firstColor, secondColor],
              )
            : null,
      ),
      child: Center(child: child),
    );
  }
}

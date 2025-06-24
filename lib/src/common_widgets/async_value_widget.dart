// flutter
import 'package:flutter/material.dart';

// external
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AsyncValueWidget<T> extends StatelessWidget {
  const AsyncValueWidget({
    super.key,
    required this.value,
    required this.data,
    this.loadingWidget = const SizedBox.shrink(),
    this.errorwidget = const SizedBox.shrink(),
  });

  final AsyncValue<T> value;
  final Widget Function(T) data;
  final Widget loadingWidget;
  final Widget errorwidget;

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: data,
      loading: () => loadingWidget,
      error: (e, st) {
        debugPrint('AsyncError: ${e.toString()}');
        return errorwidget;
      },
    );
  }
}

import 'dart:developer' as dev;

// flutter
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

void safeBuildCall(VoidCallback callback) {
  if (SchedulerBinding.instance.schedulerPhase ==
      SchedulerPhase.persistentCallbacks) {
    dev.log('setState: persistentCallbacks');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback.call();
    });
  } else {
    callback.call();
  }
}

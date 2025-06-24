// lib/src/core/app_states/upload_progress_state.dart

// external
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'upload_progress_state.g.dart';

class UploadProgress {
  const UploadProgress(this.index, this.percentage);

  final int index;
  final int percentage;
}

@riverpod
class UploadProgressState extends _$UploadProgressState {
  @override
  UploadProgress build() {
    return const UploadProgress(0, 0);
  }

  void set(int index, int percentage) =>
      state = UploadProgress(index, percentage);
}

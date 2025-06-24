class ButtonProgressState {
  const ButtonProgressState({
    this.isLoading = true,
    this.progress = 0.0,
    this.currentState = '',
  });

  final bool isLoading;
  final double progress;
  final String currentState;
}

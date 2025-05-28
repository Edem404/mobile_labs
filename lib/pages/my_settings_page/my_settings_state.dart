class MySettingsState {
  final String? deviceId;
  final String? lastCommand;
  final String? errorMessage;
  final bool isConnected;
  final bool isPortClosed;
  final bool isLoading;

  const MySettingsState({
    this.deviceId,
    this.lastCommand,
    this.errorMessage,
    this.isConnected = false,
    this.isPortClosed = false,
    this.isLoading = false,
  });

  MySettingsState copyWith({
    String? deviceId,
    String? lastCommand,
    String? errorMessage,
    bool? isConnected,
    bool? isPortClosed,
    bool? isLoading,
  }) {
    return MySettingsState(
      deviceId: deviceId ?? this.deviceId,
      lastCommand: lastCommand ?? this.lastCommand,
      errorMessage: errorMessage,
      isConnected: isConnected ?? this.isConnected,
      isPortClosed: isPortClosed ?? this.isPortClosed,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

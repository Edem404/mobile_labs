class HomeState {
  final bool isConnected;

  const HomeState({required this.isConnected});

  HomeState copyWith({bool? isConnected}) {
    return HomeState(
      isConnected: isConnected ?? this.isConnected,
    );
  }
}

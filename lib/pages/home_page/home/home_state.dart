import 'package:equatable/equatable.dart';

class HomeState extends Equatable {
  final bool isConnected;

  const HomeState({required this.isConnected});

  HomeState copyWith({bool? isConnected}) {
    return HomeState(
      isConnected: isConnected ?? this.isConnected,
    );
  }

  @override
  List<Object> get props => [isConnected];
}

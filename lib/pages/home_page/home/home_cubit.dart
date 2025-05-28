import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_project/pages/home_page/home/home_state.dart';
import 'package:mobile_project/services/network_service.dart';

class HomeCubit extends Cubit<HomeState> {
  final NetworkService _networkService;

  HomeCubit(this._networkService)
      : super(HomeState(isConnected: _networkService.isConnected)) {
    _networkService.addListener(_handleConnectionChange);
  }

  void init() {
    emit(state.copyWith(isConnected: _networkService.isConnected));
  }

  void _handleConnectionChange() {
    emit(state.copyWith(isConnected: _networkService.isConnected));
  }

  @override
  Future<void> close() {
    _networkService.removeListener(_handleConnectionChange);
    return super.close();
  }
}

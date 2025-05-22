import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_project/pages/login_page/login_state.dart';
import 'package:mobile_project/services/login_service.dart';
import 'package:mobile_project/services/network_service.dart';
import 'package:mobile_project/services/user_service.dart';

class LoginCubit extends Cubit<LoginState> {
  final UserLoginService loginService;
  final UserService userService;
  final NetworkService networkService;

  LoginCubit({
    required this.loginService,
    required this.userService,
    required this.networkService,
  }) : super(LoginState.initial());

  Future<void> checkSavedSession() async {
    final sessionState = await userService.getSessionState();
    if (sessionState == true) {
      emit(state.copyWith(autoLoginSuccess: true));
    }
  }

  void updateEmail(String email) {
    emit(state.copyWith(email: email));
  }

  void updatePassword(String password) {
    emit(state.copyWith(password: password));
  }

  void clearError() {
    emit(state.copyWith());
  }

  Future<void> login() async {
    emit(state.copyWith(isLoading: true));

    if (!networkService.isConnected) {
      emit(state.copyWith(
        errorMessage: 'No internet connection',
        isLoading: false,
      ),
      );
      return;
    }

    final success = await loginService.doLogin(state.email, state.password);
    if (success) {
      await userService.saveUserSession();
      emit(state.copyWith(loginSuccess: true, isLoading: false));
    } else {
      emit(state.copyWith(
        errorMessage: 'Invalid e-mail or password',
        isLoading: false,
      ),
      );
    }
  }
}

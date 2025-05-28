import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_project/pages/registration_page/registration_state.dart';
import 'package:mobile_project/services/registration_service.dart';
import 'package:mobile_project/services/user_service.dart';

class RegistrationCubit extends Cubit<RegistrationState> {
  final UserRegistrationService registrationService;
  final UserService userService;

  RegistrationCubit({
    required this.registrationService,
    required this.userService,
  }) : super(const RegistrationState());

  void updateName(String value) {
    emit(state.copyWith(name: value));
  }

  void updateEmail(String value) {
    emit(state.copyWith(email: value));
  }

  void updatePassword(String value) {
    emit(state.copyWith(password: value));
  }

  void updateRepeatPassword(String value) {
    emit(state.copyWith(repeatPassword: value));
  }

  Future<void> register() async {
    if (state.password != state.repeatPassword) {
      emit(state.copyWith(errorMessage: 'Passwords do not match.'));
      return;
    }

    final success = await registrationService.doRegistration(
      state.name,
      state.email,
      state.password,
    );

    if (success) {
      await userService.saveUserSession();
      emit(state.copyWith(isSuccess: true));
    } else {
      emit(state.copyWith(errorMessage: 'Registration failed'));
    }
  }
}

class RegistrationState {
  final String name;
  final String email;
  final String password;
  final String repeatPassword;
  final bool isSuccess;
  final String? errorMessage;

  const RegistrationState({
    this.name = '',
    this.email = '',
    this.password = '',
    this.repeatPassword = '',
    this.isSuccess = false,
    this.errorMessage,
  });

  RegistrationState copyWith({
    String? name,
    String? email,
    String? password,
    String? repeatPassword,
    bool? isSuccess,
    String? errorMessage,
  }) {
    return RegistrationState(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      repeatPassword: repeatPassword ?? this.repeatPassword,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage,
    );
  }
}

class LoginState {
  final String email;
  final String password;
  final bool loginSuccess;
  final bool autoLoginSuccess;
  final String? errorMessage;
  final bool isLoading;

  const LoginState({
    required this.email,
    required this.password,
    required this.loginSuccess,
    required this.autoLoginSuccess,
    required this.isLoading,
    this.errorMessage,
  });

  factory LoginState.initial() {
    return const LoginState(
      email: '',
      password: '',
      loginSuccess: false,
      autoLoginSuccess: false,
      isLoading: false,
    );
  }

  LoginState copyWith({
    String? email,
    String? password,
    bool? loginSuccess,
    bool? autoLoginSuccess,
    String? errorMessage,
    bool? isLoading,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      loginSuccess: loginSuccess ?? this.loginSuccess,
      autoLoginSuccess: autoLoginSuccess ?? this.autoLoginSuccess,
      errorMessage: errorMessage,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

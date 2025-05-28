import 'package:equatable/equatable.dart';

class LoginState extends Equatable {
  final String email;
  final String password;
  final bool loginSuccess;
  final bool autoLoginSuccess;
  final String errorMessage;
  final bool isLoading;
  final bool hasConnection;

  const LoginState({
    required this.email,
    required this.password,
    required this.loginSuccess,
    required this.autoLoginSuccess,
    required this.isLoading,
    required this.errorMessage,
    required this.hasConnection,
  });

  factory LoginState.initial() {
    return const LoginState(
      email: '',
      password: '',
      loginSuccess: false,
      autoLoginSuccess: false,
      isLoading: false,
      errorMessage: '',
      hasConnection: true,
    );
  }

  LoginState copyWith({
    String? email,
    String? password,
    bool? loginSuccess,
    bool? autoLoginSuccess,
    String? errorMessage,
    bool? isLoading,
    bool? hasConnection,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      loginSuccess: loginSuccess ?? this.loginSuccess,
      autoLoginSuccess: autoLoginSuccess ?? this.autoLoginSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
      isLoading: isLoading ?? this.isLoading,
      hasConnection: hasConnection ?? this.hasConnection,
    );
  }

  @override
  List<Object> get props => [
    email,
    password,
    loginSuccess,
    autoLoginSuccess,
    errorMessage,
    isLoading,
    hasConnection,
  ];
}

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_project/custom_widget/common_widgets_lib.dart';
import 'package:mobile_project/pages/login_page/login_cubit.dart';
import 'package:mobile_project/pages/login_page/login_state.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginCubit>(
      create: (_) => LoginCubit(
        loginService: context.read(),
        userService: context.read(),
        networkService: context.read(),
      )..checkSavedSession(),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state.autoLoginSuccess || state.loginSuccess) {
            Navigator.pushReplacementNamed(context, '/home');
          }
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: Colors.red,
              ),
            );
            context.read<LoginCubit>().clearError();
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Login'),
              backgroundColor: const Color(0xFFD86FFF),
              titleTextStyle: const TextStyle(
                color: Colors.white,
                fontSize: 26,
              ),
            ),
            body: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (!context.read<LoginCubit>().networkService.isConnected)
                      const Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Text(
                          '⚠️ No internet connection',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                      ),
                      child: TextField(
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                          hintText: 'Enter your email',
                        ),
                        onChanged: (value) =>
                            context.read<LoginCubit>().updateEmail(value),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                      ),
                      child: TextField(
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                          hintText: 'Enter your password',
                        ),
                        onChanged: (value) =>
                            context.read<LoginCubit>().updatePassword(value),
                      ),
                    ),
                    if (state.isLoading)
                      const Padding(
                        padding: EdgeInsets.all(12),
                        child: CircularProgressIndicator(),
                      )
                    else
                      CustomButton(
                        text: 'Login',
                        onPressed: () =>
                            context.read<LoginCubit>().login(),
                        color: const Color(0xFFD86FFF),
                        textColor: Colors.white,
                        textFontSize: 16,
                      ),
                    Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(top: 20),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                          ),
                          children: [
                            const TextSpan(
                              text: 'Still don\'t have any account? \n'
                                  'Register new right ',
                            ),
                            TextSpan(
                              text: 'here',
                              style: const TextStyle(
                                color: Colors.pinkAccent,
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushNamed(context, '/registration');
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

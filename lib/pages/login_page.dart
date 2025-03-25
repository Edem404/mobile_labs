import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mobile_project/custom_widget/common_widgets_lib.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String loginEmail = '';
  String loginPassword = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Login'),
        backgroundColor: const Color(0xFFD86FFF),
          titleTextStyle: const TextStyle(color: Colors.white, fontSize: 26),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 8,),
                child: TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    hintText: 'Enter your email',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 8,),
                child: TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    hintText: 'Enter your password',
                  ),
                ),
              ),
              CustomButton(
                text: 'Login',
                onPressed: () {
                  Navigator.pushNamed(context, '/home');
                },
                color: const Color(0xFFD86FFF),
                textColor: Colors.white,
                textFontSize: 16,
              ),
              Container(
                alignment: Alignment.center,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(fontSize: 16, color: Colors.black),
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
    ),);
  }
}

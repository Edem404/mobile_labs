import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mobile_project/custom_widget/common_widgets_lib.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final String defaultLogin = 'root@gmail.com';
  final String defaultPassword = 'root';

  @override
  void initState() {
    super.initState();
    _checkSavedSession(context);
  }

  Future<void> _checkSavedSession(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? savedEmail = prefs.getString('auth_email');
    if(context.mounted) {
      if (savedEmail != null) {
        Navigator.pushNamed(context, '/home');
      }
    }
  }

  void _login(BuildContext context) async {
    final String enteredEmail = _emailController.text.trim();
    final String enteredPassword = _passwordController.text.trim();

    if (enteredEmail == defaultLogin && enteredPassword == defaultPassword) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_email', enteredEmail);

      if(context.mounted) {
        Navigator.pushNamed(context, '/home');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid email or password'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

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
                  _login(context);
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
    ),);
  }
}

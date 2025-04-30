import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mobile_project/custom_widget/common_widgets_lib.dart';
import 'package:mobile_project/services/login_service.dart';
import 'package:mobile_project/services/network_service.dart';
import 'package:mobile_project/services/user_service.dart';
import 'package:provider/provider.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late UserLoginService _userLoginService;
  late UserService _userService;
  late NetworkService _networkService;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _userLoginService = context.read<UserLoginService>();
      _userService = context.read<UserService>();
      _networkService = context.read<NetworkService>();
      _checkSavedSession();
    });
  }

  Future<void> _checkSavedSession() async {
    final bool? sessionState = await _userService.getSessionState();

    if (sessionState == true) {
      await Future<void>.delayed(const Duration(milliseconds: 100));

      if (mounted && !_networkService.isConnected) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No internet connection'),
            backgroundColor: Colors.orange,
          ),
        );
      }
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isConnected = context.watch<NetworkService>().isConnected;

    return Scaffold(
        appBar: AppBar(title: const Text('Login'),
        backgroundColor: const Color(0xFFD86FFF),
          titleTextStyle: const TextStyle(color: Colors.white, fontSize: 26),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!isConnected)
                const Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text(
                    '⚠️ No internet connection',
                    style: TextStyle(color: Colors.red,
                        fontWeight: FontWeight.bold,),
                  ),
                ),
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
                onPressed: () async {
                  final enteredEmail = _emailController.text;
                  final enteredPassword = _passwordController.text;

                  if(_networkService.isConnected) {
                    if(await _userLoginService.doLogin(
                      enteredEmail,
                      enteredPassword,)
                        && context.mounted
                    ) {
                      await _userService.saveUserSession();
                      if(!context.mounted) return;
                      Navigator.pushNamed(context, '/home');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Invalid email or password'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('No internet connection'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
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

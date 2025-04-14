import 'package:flutter/material.dart';
import 'package:mobile_project/custom_widget/common_widgets_lib.dart';
import 'package:mobile_project/services/registration_service.dart';
import 'package:mobile_project/services/user_service.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _rptPasswordController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();

  final UserRegistrationService _userRegistrationService =
  UserRegistrationService();

  UserService? _userService;

  @override
  void initState() {
    super.initState();
    _initUserService();
  }

  Future<void> _initUserService() async {
    _userService = await UserService.create();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _rptPasswordController.dispose();
    _userNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration'),
        backgroundColor: const Color(0xFFD86FFF),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 26),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushNamed(context, '/login');
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _userNameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _rptPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Repeat password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              CustomButton(
                text: 'Registration',
                onPressed: () async {
                  final String name = _userNameController.text;
                  final String email = _emailController.text;
                  final String password = _passwordController.text;
                  final String secondPassword = _rptPasswordController.text;

                  bool isRegisterSuccess = false;

                  if(_userRegistrationService.validateRptPassword(
                      password,
                      secondPassword,)
                  ) {
                    isRegisterSuccess =
                    await _userRegistrationService.doRegistration(
                      name,
                      email,
                      password,
                    );
                  }
                  if (isRegisterSuccess) {
                    await _userService?.saveUserSession();

                    if (!context.mounted) return;
                    Navigator.pushNamed(context, '/home');
                  }
                },
                color: const Color(0xFFD86FFF),
                textColor: Colors.white,
                textFontSize: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

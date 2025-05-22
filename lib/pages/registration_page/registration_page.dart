import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_project/custom_widget/common_widgets_lib.dart';
import 'package:mobile_project/pages/registration_page/registration_cubit.dart';
import 'package:mobile_project/pages/registration_page/registration_state.dart';
import 'package:mobile_project/services/registration_service.dart';
import 'package:mobile_project/services/user_service.dart';

class RegistrationPage extends StatelessWidget {
  const RegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RegistrationCubit(
        registrationService: context.read<UserRegistrationService>(),
        userService: context.read<UserService>(),
      ),
      child: BlocConsumer<RegistrationCubit, RegistrationState>(
        listener: (context, state) {
          if (state.isSuccess) {
            Navigator.pushReplacementNamed(context, '/home');
          }
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<RegistrationCubit>();

          return Scaffold(
            appBar: AppBar(
              title: const Text('Registration'),
              backgroundColor: const Color(0xFFD86FFF),
              titleTextStyle: const TextStyle(
                color: Colors.white,
                fontSize: 26,
              ),
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
                      onChanged: cubit.updateName,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      onChanged: cubit.updateEmail,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      obscureText: true,
                      onChanged: cubit.updatePassword,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      obscureText: true,
                      onChanged: cubit.updateRepeatPassword,
                      decoration: const InputDecoration(
                        labelText: 'Repeat password',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    CustomButton(
                      text: 'Registration',
                      onPressed: cubit.register,
                      color: const Color(0xFFD86FFF),
                      textColor: Colors.white,
                      textFontSize: 16,
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

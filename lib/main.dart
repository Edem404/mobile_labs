import 'package:flutter/material.dart';
import 'package:mobile_project/pages/home_page/home_page.dart';
import 'package:mobile_project/pages/login_page.dart';
import 'package:mobile_project/pages/my_settings_page/my_settings_page.dart';
import 'package:mobile_project/pages/profile_page/profile_page.dart';
import 'package:mobile_project/pages/registration_page.dart';
import 'package:mobile_project/services/login_service.dart';
import 'package:mobile_project/services/network_service.dart';
import 'package:mobile_project/services/registration_service.dart';
import 'package:mobile_project/services/user_service.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final userService = await UserService.create();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NetworkService()),
        Provider<UserLoginService>(
          create: (_) => UserLoginService(),
        ),
        Provider<UserService>.value(
          value: userService,
        ),
        Provider<UserRegistrationService>(
          create: (_) => UserRegistrationService(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(primaryColor: Colors.blueAccent),
        debugShowCheckedModeBanner: false,
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginPage(),
          '/registration': (context) => const RegistrationPage(),
          '/home': (context) => const HomePage(),
          '/profile': (context) => const ProfilePage(),
          '/my_settings': (context) => const MySettingsPage(),
        },
      ),
    ),
  );
}

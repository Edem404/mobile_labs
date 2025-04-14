import 'package:flutter/material.dart';
import 'package:mobile_project/pages/home_page/home_page.dart';
import 'package:mobile_project/pages/login_page.dart';
import 'package:mobile_project/pages/profile_page/profile_page.dart';
import 'package:mobile_project/pages/registration_page.dart';

void main() async {
  runApp(MaterialApp(
    theme: ThemeData(primaryColor: Colors.blueAccent),
    debugShowCheckedModeBanner: false,
    initialRoute: '/login',
    routes: {
      '/login': (context) => const LoginPage(),
      '/registration': (context) => const RegistrationPage(),
      '/home': (context) => const HomePage(),
      '/profile': (context) => const ProfilePage(),
    },
  ),);
}

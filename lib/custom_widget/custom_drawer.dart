import 'package:flutter/material.dart';
import 'package:mobile_project/services/user_service.dart';

class CustomDrawer extends StatelessWidget {
  CustomDrawer({super.key});
  final Future<UserService> _userService = UserService.create();

  @override
  Widget build(BuildContext context) {

    Future<void> logout(BuildContext context) async {
      final userService = await _userService;

      await userService.deleteSession();
      if(context.mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      }
    }

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(
            height: 89,
            child: DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFFD86FFF)),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/home', (route) => false,);
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('My settings'),
            onTap: () {
              Navigator.pushNamed(context, '/my_settings');
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () {
              logout(context);
            },
          ),
        ],
      ),
    );
  }
}

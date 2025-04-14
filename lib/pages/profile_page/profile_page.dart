import 'package:flutter/material.dart';
import 'package:mobile_project/custom_widget/custom_drawer.dart';
import 'package:mobile_project/pages/profile_page/edit_profile_dialog.dart';
import 'package:mobile_project/pages/profile_page/profile_page_nav.dart';
import 'package:mobile_project/services/user_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String userEmail = 'johndoe@example.com';
  String userName = 'User Name';
  UserService? userService;

  @override
  void initState() {
    super.initState();
    _initUserService();
  }

  Future<void> _initUserService() async {
    userService = await UserService.create();
    final name = await userService?.getUserName();
    final email = await userService?.getUserEmail();
    setState(() {
      userName = name ?? 'User Name';
      userEmail = email ?? 'johndoe@example.com';
    });
  }

  Future<void> _handleEditProfile() async {
    if (userService == null) return;
    final updated = await showEditProfileDialog(context, userService!);
    if (updated) {
      final updatedName = await userService!.getUserName();
      final updatedEmail = await userService!.getUserEmail();
      setState(() {
        userName = updatedName ?? userName;
        userEmail = updatedEmail ?? userEmail;
      });
    }
  }

  void _handleDeleteProfile() async {
    await userService?.dataReset();

    if(!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Delete profile successful')),
    );

    Navigator.pushNamed(context, '/registration');
  }

  final List<String> rooms = [];
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final avatarRadius = screenWidth * 0.15;
    final subtitleSize = screenWidth * 0.04;
    final spacing = screenHeight * 0.02;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: const Color(0xFFD86FFF),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 26),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(
                Icons.menu,
                color: Colors.white,
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      drawer: CustomDrawer(),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.03),
            CircleAvatar(
              radius: avatarRadius,
              backgroundColor: Colors.grey,
              child: Icon(
                Icons.person,
                size: avatarRadius,
                color: Colors.white,),
            ),
            SizedBox(height: spacing),
            Text(
              userName,
              style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,),
            ),
            SizedBox(height: spacing * 0.5),
            Text(
              userEmail,
              style: TextStyle(fontSize: subtitleSize, color: Colors.grey),
            ),
          ],
        ),
      ),
      floatingActionButton: ProfileBottomNav(
        onEdit: _handleEditProfile,
        onDelete: _handleDeleteProfile,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mobile_project/custom_widget/custom_drawer.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

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
      drawer: const CustomDrawer(),
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
            const Text(
              'John Doe',
              style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,),
            ),
            SizedBox(height: spacing * 0.5),
            Text(
              'johndoe@example.com',
              style: TextStyle(fontSize: subtitleSize, color: Colors.grey),
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton.extended(
            backgroundColor: Colors.red,
            onPressed: () {},
            tooltip: 'Delete',
            label: const Text(
              'Delete profile',
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
              ),
            ),
            icon: const Icon(Icons.delete, color: Colors.white),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

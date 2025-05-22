import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_project/custom_widget/custom_drawer.dart';
import 'package:mobile_project/pages/profile_page/edit_profile_dialog.dart';
import 'package:mobile_project/pages/profile_page/profile_cubit.dart';
import 'package:mobile_project/pages/profile_page/profile_page_nav.dart';
import 'package:mobile_project/pages/profile_page/profile_state.dart';
import 'package:mobile_project/services/user_service.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = ProfileCubit(context.read<UserService>());
        cubit.loadUserData();
        return cubit;
      },
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

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
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      drawer: CustomDrawer(),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          return Center(
            child: Column(
              children: [
                SizedBox(height: screenHeight * 0.03),
                CircleAvatar(
                  radius: avatarRadius,
                  backgroundColor: Colors.grey,
                  child: Icon(
                      Icons.person,
                      size: avatarRadius,
                      color: Colors.white,
                  ),
                ),
                SizedBox(height: spacing),
                Text(
                  state.userName,
                  style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: spacing * 0.5),
                Text(
                  state.userEmail,
                  style: TextStyle(fontSize: subtitleSize, color: Colors.grey),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: ProfileBottomNav(
        onEdit: () async {
          final cubit = context.read<ProfileCubit>();
          final updated = await showEditProfileDialog(context, cubit);
          if (updated) await cubit.loadUserData();
        },
        onDelete: () async {
          final cubit = context.read<ProfileCubit>();
          await cubit.resetProfile();
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Delete profile successful')),
            );
            Navigator.pushNamed(context, '/registration');
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mobile_project/pages/profile_page/profile_cubit.dart';

Future<bool> showEditProfileDialog(
    BuildContext context, ProfileCubit cubit,) async {
  final nameController = TextEditingController(text: cubit.state.userName);
  final emailController = TextEditingController(text: cubit.state.userEmail);

  if (!context.mounted) return false;

  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Edit Profile'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),),
          TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            await cubit.updateUserProfile(
                nameController.text,
                emailController.text,
            );
            if (!context.mounted) return;
            Navigator.of(context).pop(true);
          },
          child: const Text('Save'),
        ),
      ],
    ),
  );

  return result ?? false;
}

import 'package:flutter/material.dart';
import 'package:mobile_project/services/user_service.dart';

Future<bool> showEditProfileDialog(
    BuildContext context,
    UserService userService,
    ) async {

  final nameController =
  TextEditingController(text: await userService.getUserName());

  final emailController =
  TextEditingController(text: await userService.getUserEmail());

  if(!context.mounted) return false;
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Edit Profile'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          TextField(
            controller: emailController,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            await userService.editUserName(nameController.text);
            await userService.editUserEmail(emailController.text);
            if(!context.mounted) return;
            Navigator.of(context).pop(true);
          },
          child: const Text('Save'),
        ),
      ],
    ),
  );

  return result ?? false;
}

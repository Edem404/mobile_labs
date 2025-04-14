import 'package:flutter/material.dart';

class ProfileBottomNav extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ProfileBottomNav({
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton.extended(
          heroTag: 'editProfileBtn',
          backgroundColor: Colors.blue,
          onPressed: onEdit,
          tooltip: 'Edit',
          label: const Text(
            'Edit profile',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
            ),
          ),
          icon: const Icon(Icons.edit, color: Colors.white),
        ),
        const SizedBox(height: 16),
        FloatingActionButton.extended(
          heroTag: 'deleteProfileBtn',
          backgroundColor: Colors.red,
          onPressed: onDelete,
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
    );
  }
}

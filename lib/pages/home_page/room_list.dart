import 'package:flutter/material.dart';

class RoomList extends StatefulWidget {
  const RoomList({super.key});

  @override
  State<RoomList> createState() => _RoomListState();
}

class _RoomListState extends State<RoomList> {
  final List<String> rooms = [];

  void _addRoom() {
    setState(() {
      rooms.add('Room ${rooms.length + 1}');
    });
  }

  void _removeRoom(int index) {
    setState(() {
      rooms.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ...rooms.asMap().entries.map((entry) {
          final int index = entry.key;
          final String room = entry.value;
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              title: Text(room),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _removeRoom(index);
                    },
                  ),
                  const Icon(Icons.air),
                ],
              ),
              onTap: () {

              },
            ),
          );
        }),
        Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: const Icon(Icons.add, color: Colors.blue),
            title: const Text('Add Room', style: TextStyle(color: Colors.blue)),
            onTap: _addRoom,
          ),
        ),
      ],
    );
  }
}

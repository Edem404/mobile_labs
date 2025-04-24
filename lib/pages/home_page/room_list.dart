import 'package:flutter/material.dart';
import 'package:mobile_project/pages/home_page/room/room_item.dart';

class RoomList extends StatefulWidget {
  const RoomList({super.key});

  @override
  State<RoomList> createState() => _RoomListState();
}

class _RoomListState extends State<RoomList> {
  final List<Room> rooms = [];

  void _addRoom() {
    setState(() {
      rooms.add(Room(
        name: 'Room ${rooms.length + 1}',
      ),
      );
    });
  }

  void _removeRoom(int index) {
    setState(() {
      rooms[index].stopUpdatingValue();
      rooms.removeAt(index);
    });
  }

  void _toggleDetails(int index) {
    setState(() {
      rooms[index].showDetails = !rooms[index].showDetails;
    });
  }

  void _closeDetails(int index) {
    setState(() {
      rooms[index].showDetails = false;
    });
  }

  void _showRoomDialog(Room room) {
    room.stopUpdatingValue();
    room.startUpdatingValue();

    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(room.name),
          content: ValueListenableBuilder<int>(
            valueListenable: room.valueNotifier,
            builder: (context, value, child) {
              return Text('Temperature: $value°C');
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Exit'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    for (var room in rooms) {
      room.stopUpdatingValue();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ...rooms.asMap().entries.map((entry) {
          final int index = entry.key;
          final Room room = entry.value;

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: [
                ListTile(
                  title: Text(room.name),
                  onTap: () => _showRoomDialog(room),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _removeRoom(index),
                      ),
                      IconButton(
                        icon: const Icon(Icons.air),
                        onPressed: () => _toggleDetails(index),
                      ),
                    ],
                  ),
                ),
                if (room.showDetails)
                  Container(
                    color: Colors.grey[100],
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'temp: ${room.value}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.grey),
                          onPressed: () => _closeDetails(index),
                        ),
                      ],
                    ),
                  ),
              ],
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

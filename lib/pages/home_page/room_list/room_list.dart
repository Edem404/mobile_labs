import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_project/pages/home_page/room/room_item.dart';
import 'package:mobile_project/pages/home_page/room_list/room_list_cubit.dart';
import 'package:mobile_project/pages/home_page/room_list/room_list_state.dart';

class RoomList extends StatelessWidget {
  const RoomList({super.key});

  void _showRoomDialog(BuildContext context, Room room) {
    room.stopUpdatingValue();
    room.startUpdatingValue();

    showDialog<void>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(room.name),
          content: ValueListenableBuilder<double>(
            valueListenable: room.valueNotifier,
            builder: (_, value, __) =>
                Text('Temperature: ${value.toStringAsFixed(1)}°C'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                room.stopUpdatingValue();
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
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RoomListCubit(),
      child: BlocBuilder<RoomListCubit, RoomListState>(
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ...state.rooms.asMap().entries.map((entry) {
                final int index = entry.key;
                final room = entry.value;

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(room.name),
                        onTap: () => _showRoomDialog(context, room),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => context.read<RoomListCubit>()
                                  .removeRoom(index),
                            ),
                            IconButton(
                              icon: const Icon(Icons.air),
                              onPressed: () => context.read<RoomListCubit>()
                                  .toggleDetails(index),
                            ),
                          ],
                        ),
                      ),
                      if (room.showDetails)
                        Container(
                          color: Colors.grey[100],
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'temp: ${room.value}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                    Icons.close,
                                    color: Colors.grey,),
                                onPressed: () => context.read<RoomListCubit>()
                                    .closeDetails(index),
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
                  title: const Text(
                      'Add Room',
                      style: TextStyle(color: Colors.blue),
                  ),
                  onTap: () => context.read<RoomListCubit>().addRoom(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

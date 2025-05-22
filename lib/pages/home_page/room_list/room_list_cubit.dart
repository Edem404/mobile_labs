import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_project/pages/home_page/room/room_item.dart';
import 'package:mobile_project/pages/home_page/room_list/room_list_state.dart';

class RoomListCubit extends Cubit<RoomListState> {
  RoomListCubit() : super(const RoomListState(rooms: []));

  void addRoom() {
    final newRoom = Room(name: 'Room ${state.rooms.length + 1}');
    emit(RoomListState(rooms: [...state.rooms, newRoom]));
  }

  void removeRoom(int index) {
    final room = state.rooms[index];
    room.stopUpdatingValue();
    final updatedRooms = [...state.rooms]..removeAt(index);
    emit(RoomListState(rooms: updatedRooms));
  }

  void toggleDetails(int index) {
    final updatedRooms = [...state.rooms];
    updatedRooms[index].showDetails = !updatedRooms[index].showDetails;
    emit(RoomListState(rooms: updatedRooms));
  }

  void closeDetails(int index) {
    final updatedRooms = [...state.rooms];
    updatedRooms[index].showDetails = false;
    emit(RoomListState(rooms: updatedRooms));
  }

  @override
  Future<void> close() {
    for (final room in state.rooms) {
      room.stopUpdatingValue();
    }
    return super.close();
  }
}

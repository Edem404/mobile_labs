import 'package:equatable/equatable.dart';
import 'package:mobile_project/pages/home_page/room/room_item.dart';

class RoomListState extends Equatable {
  final List<Room> rooms;

  const RoomListState({required this.rooms});

  @override
  List<Object> get props => [rooms];
}

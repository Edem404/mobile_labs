import 'package:equatable/equatable.dart';

class ProfileState extends Equatable {
  final String userName;
  final String userEmail;

  const ProfileState({
    required this.userName,
    required this.userEmail,
  });

  ProfileState copyWith({String? userName, String? userEmail}) {
    return ProfileState(
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
    );
  }

  @override
  List<Object> get props => [userName, userEmail];
}

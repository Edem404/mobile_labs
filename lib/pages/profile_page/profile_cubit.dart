import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_project/pages/profile_page/profile_state.dart';
import 'package:mobile_project/services/user_service.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final UserService userService;

  ProfileCubit(this.userService)
      : super(const ProfileState(
      userName: 'User Name',
      userEmail: 'johndoe@example.com'),
  );

  Future<void> loadUserData() async {
    final name = await userService.getUserName();
    final email = await userService.getUserEmail();
    emit(state.copyWith(userName: name, userEmail: email));
  }

  Future<void> updateUserProfile(String name, String email) async {
    await userService.editUserName(name);
    await userService.editUserEmail(email);
    emit(state.copyWith(userName: name, userEmail: email));
  }

  Future<void> resetProfile() async {
    await userService.dataReset();
    emit(const ProfileState(
        userName: 'User Name',
        userEmail: 'johndoe@example.com',
    ),
    );
  }
}

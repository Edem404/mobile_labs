import 'package:mobile_project/storage/local_storage.dart';

class UserLoginService {
  late LocalStorage _localStorage;
  final String _emailKey = 'e-mail';
  final String _passwordKey = 'password';

  UserLoginService() {
    _initStorage();
  }

  Future<void> _initStorage() async {
    _localStorage = await LocalStorage.getInstance();
  }

  Future<bool> doLogin(String userEmail, String userPassword) async {
    return validateEnteredData(userEmail, userPassword);
  }

  Future<bool> validateEnteredData(String userEmail,
      String userPassword,) async {

    final String? emailInStorage = await _localStorage.getData(_emailKey);
    final String? passwordInStorage = await _localStorage.getData(_passwordKey);

    if(emailInStorage == userEmail && passwordInStorage == userPassword) {
      return true;
    }

    return false;
  }
}

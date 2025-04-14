import 'package:mobile_project/storage/local_storage.dart';

class UserRegistrationService {
  late LocalStorage _localStorage;
  final String _nameKey = 'user_name';
  final String _emailKey = 'e-mail';
  final String _passwordKey = 'password';

  UserRegistrationService() {
    _initStorage();
  }

  Future<void> _initStorage() async {
    _localStorage = await LocalStorage.getInstance();
  }

  Future<bool> doRegistration(
      String userName,
      String userEmail,
      String userPassword,
      )
  async {
    if(validateEmail(userEmail) && validateName(userName)) {
      _localStorage.saveData(_nameKey, userName);
      _localStorage.saveData(_emailKey, userEmail);
      _localStorage.saveData(_passwordKey, userPassword);

      if(await isDataSaved(userEmail)) {
        return true;
      } else {
        return false;
      }
    }

    return false;
  }

  bool validateName(String userName) {
    return !RegExp(r'\d').hasMatch(userName);
  }

  bool validateEmail(String userEmail) {
    bool isEmailValid = true;

    if(!userEmail.contains('@')) {
      isEmailValid = false;
    }

    return isEmailValid;
  }

  bool validateRptPassword(String firstPassword, String secondPassword) {
    if(firstPassword == secondPassword) {
      return true;
    }
    return false;
  }

  Future<bool> isDataSaved(String userEmail) async {
    final String? emailInStorage = await _localStorage.getData(_emailKey);

    if(userEmail == emailInStorage) {
      return true;
    }

    return false;
  }
}

import 'dart:async';
import 'package:mobile_project/storage/local_storage.dart';

class UserService {
  late final LocalStorage _localStorage;
  final String _nameKey = 'user_name';
  final String _emailKey = 'e-mail';
  final String _sessionKey = 'session';

  UserService(this._localStorage);

  static Future<UserService> create() async {
    final storage = await LocalStorage.getInstance();
    return UserService(storage);
  }

  Future<void> editUserName(String newName) async {
    _localStorage.saveData(_nameKey, newName);
  }

  Future<void> editUserEmail(String newEmail) async {
    _localStorage.saveData(_emailKey, newEmail);
  }

  Future<String?> getUserName() async {
    return _localStorage.getData(_nameKey);
  }

  Future<String?> getUserEmail() async {
    return _localStorage.getData(_emailKey);
  }

  Future<void> saveUserSession() async {
    await _localStorage.saveBool(_sessionKey, true);
  }

  Future<bool?> getSessionState() async {
    return _localStorage.getBool(_sessionKey);
  }

  Future<void> deleteSession() async {
    await _localStorage.saveBool(_sessionKey, false);
  }

  Future<void> dataReset() async {
    await _localStorage.clearStorage();
  }
}

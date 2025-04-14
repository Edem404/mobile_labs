import 'package:mobile_project/storage/general_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage implements GeneralStorage{
  late final SharedPreferences _storage;

  static Future<LocalStorage> getInstance() async {
    final instance = LocalStorage._();
    instance._storage = await SharedPreferences.getInstance();
    return instance;
  }

  LocalStorage._();

  @override
  Future<void> saveData(String key, String data) async {
    await _storage.setString(key, data);
  }

  @override
  Future<void> saveBool(String key, bool data) async {
    await _storage.setBool(key, data);
  }

  @override
  Future<String?> getData(String key) async {
    return _storage.getString(key);
  }

  @override
  Future<bool?> getBool(String key) async {
    return _storage.getBool(key);
  }

  @override
  Future<void> deleteData(String key) async {
    await _storage.remove(key);
  }

  @override
  Future<void> clearStorage() async {
    await _storage.clear();
  }
}

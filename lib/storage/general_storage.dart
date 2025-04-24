abstract class GeneralStorage {
  Future<void> saveData(String key, String data);
  Future<void> saveBool(String key, bool data);
  Future<String?> getData(String key);
  Future<bool?> getBool(String key);
  Future<void> deleteData(String key);
  Future<void> clearStorage();
}

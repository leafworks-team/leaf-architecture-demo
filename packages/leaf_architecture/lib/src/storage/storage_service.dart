import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_storage/get_storage.dart';
import 'package:injectable/injectable.dart';

@singleton
class StorageService {
  late final GetStorage _storage;
  late final FlutterSecureStorage _secureStorage;

  StorageService(this._storage, this._secureStorage);

  Future<void> init() async {
    await GetStorage.init();
  }

  Future<void> clear() async {
    await _storage.erase();
    await _secureStorage.deleteAll();
  }

  Future<void> writeSecure(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  Future<String?> readSecure(String key) async {
    return await _secureStorage.read(key: key);
  }

  Future<void> deleteSecure(String key) async {
    await _secureStorage.delete(key: key);
  }

  Future<void> write(String key, dynamic value) async {
    await _storage.write(key, value);
  }

  T? read<T>(String key) {
    return _storage.read<T>(key);
  }

  Future<void> delete(String key) async {
    await _storage.remove(key);
  }
}

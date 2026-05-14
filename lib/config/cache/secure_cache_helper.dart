import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

abstract class SecureCacheHelper {
  Future<void> writeData({required String key, required dynamic value});
  Future<String?> readData({required String key});
  Future<bool> containsKey({required String key});
  Future<void> deleteData({required String key});
  Future<void> clearAllData();
}

@LazySingleton(as: SecureCacheHelper)
class SecureCacheHelperImpl implements SecureCacheHelper {
  final FlutterSecureStorage _secureStorage;

  SecureCacheHelperImpl(this._secureStorage);

  @override
  Future<void> writeData({required String key, required dynamic value}) async {
    String valueToStore;
    if (value is String) {
      valueToStore = value;
    } else {
      valueToStore = value.toString();
    }
    await _secureStorage.write(key: key, value: valueToStore);
  }

  @override
  Future<String?> readData({required String key}) async {
    return await _secureStorage.read(key: key);
  }

  @override
  Future<bool> containsKey({required String key}) async {
    return await _secureStorage.containsKey(key: key);
  }

  @override
  Future<void> deleteData({required String key}) async {
    await _secureStorage.delete(key: key);
  }

  @override
  Future<void> clearAllData() async {
    await _secureStorage.deleteAll();
  }
}

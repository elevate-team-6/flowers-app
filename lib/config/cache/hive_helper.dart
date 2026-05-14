import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

abstract class HiveHelper {
  Future<void> init();
  Future<void> cacheData<T>({
    required String boxName,
    required String key,
    required T value,
  });
  Future<T?> getData<T>({required String boxName, required String key});
  Future<void> deleteData({required String boxName, required String key});
  Future<void> clearBox({required String boxName});
}

@LazySingleton(as: HiveHelper)
class HiveHelperImpl implements HiveHelper {
  @override
  Future<void> init() async {
    await Hive.initFlutter();
  }

  @override
  Future<void> cacheData<T>({
    required String boxName,
    required String key,
    required T value,
  }) async {
    var box = await Hive.openBox(boxName);
    await box.put(key, value);
  }

  @override
  Future<T?> getData<T>({required String boxName, required String key}) async {
    var box = await Hive.openBox(boxName);
    return box.get(key) as T?;
  }

  @override
  Future<void> deleteData({
    required String boxName,
    required String key,
  }) async {
    var box = await Hive.openBox(boxName);
    await box.delete(key);
  }

  @override
  Future<void> clearBox({required String boxName}) async {
    var box = await Hive.openBox(boxName);
    await box.clear();
  }
}

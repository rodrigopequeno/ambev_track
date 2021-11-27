import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../features/collect/data/models/collect_model.dart';
import 'database.dart';

class HiveDatabaseImpl extends Database {
  final HiveInterface hive;

  HiveDatabaseImpl({
    required this.hive,
  });

  @override
  Future<void> initialize() async {
    await hive.initFlutter();
    if (!hive.isAdapterRegistered(CollectModelAdapter().typeId)) {
      hive.registerAdapter<CollectModel>(CollectModelAdapter());
    }
  }

  Future<Box> _openBox(String key) async {
    final box = await hive.openBox(key);
    return box;
  }

  @override
  Future<V?> get<K, V>({
    required String boxName,
    required K key,
    V? defaultValue,
  }) async {
    final box = await _openBox(boxName);
    final value = box.get(key, defaultValue: defaultValue);
    return value;
  }

  @override
  Future<void> put<K, V>({
    required String boxName,
    required K key,
    required V value,
  }) async {
    final box = await _openBox(boxName);
    box.put(key, value);
  }

  @override
  Future<void> delete<K>({
    required String boxName,
    required K key,
  }) async {
    final box = await _openBox(boxName);
    box.delete(key);
  }
}

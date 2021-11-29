import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../features/collect/data/models/collect_model.dart';
import '../../features/collect/data/models/geographic_coordinate_model.dart';
import '../../features/collect/domain/entities/cardinal_point.dart';
import 'database.dart';

class HiveDatabaseImpl extends Database {
  final HiveInterface hive;

  HiveDatabaseImpl({
    required this.hive,
  });

  @override
  Future<Database> initialize() async {
    await hive.initFlutter();
    if (!hive.isAdapterRegistered(CollectModelAdapter().typeId)) {
      hive.registerAdapter<CollectModel>(CollectModelAdapter());
    }
    if (!hive.isAdapterRegistered(GeographicCoordinateModelAdapter().typeId)) {
      hive.registerAdapter<GeographicCoordinateModel>(
          GeographicCoordinateModelAdapter());
    }
    if (!hive.isAdapterRegistered(CardinalPointAdapter().typeId)) {
      hive.registerAdapter<CardinalPoint>(CardinalPointAdapter());
    }
    return this;
  }

  Future<Box<T>> _openBox<T>(String key) async {
    final box = await hive.openBox<T>(key);
    return box;
  }

  @override
  Future<V?> get<K, V>({
    required String boxName,
    required K key,
    V? defaultValue,
  }) async {
    final box = await _openBox<V>(boxName);
    final value = box.get(key, defaultValue: defaultValue);
    return value;
  }

  @override
  Future<void> put<K, V>({
    required String boxName,
    required K key,
    required V value,
  }) async {
    final box = await _openBox<V>(boxName);
    box.put(key, value);
  }

  @override
  Future<void> delete<K, V>({
    required String boxName,
    required K key,
  }) async {
    final box = await _openBox<V>(boxName);
    box.delete(key);
  }
}

abstract class Database {
  Future<Database> initialize();
  Future<V?> get<K, V>({
    required String boxName,
    required K key,
    V? defaultValue,
  });
  Future<void> put<K, V>({
    required String boxName,
    required K key,
    required V value,
  });
  Future<void> delete<K, V>({
    required String boxName,
    required K key,
  });
}

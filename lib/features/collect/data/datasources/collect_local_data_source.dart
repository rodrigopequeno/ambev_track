import '../../../../core/database/database.dart';

import '../models/collect_model.dart';

abstract class CollectLocalDataSource {
  Future<void> saveCacheNewCollect({required CollectModel collectModel});
  Future<void> saveUnsentCollect({required CollectModel collectModel});
}

const boxCacheCollect = "CACHED_COLLECT";
const boxUnsentCollect = "UNSENT_COLLECT";

class CollectLocalDataSourceImpl implements CollectLocalDataSource {
  final Database database;

  CollectLocalDataSourceImpl({
    required this.database,
  });

  @override
  Future<void> saveCacheNewCollect({
    required CollectModel collectModel,
  }) async {
    final values = await database.get<String, List>(
      boxName: boxCacheCollect,
      key: boxCacheCollect,
      defaultValue: <CollectModel>[],
    );
    final cacheCollect = List<CollectModel>.from(values ?? <CollectModel>[]);
    cacheCollect.add(collectModel);
    await database.put<String, List>(
      boxName: boxCacheCollect,
      key: boxCacheCollect,
      value: cacheCollect,
    );
  }

  @override
  Future<void> saveUnsentCollect({
    required CollectModel collectModel,
  }) async {
    final values = await database.get<String, List>(
      boxName: boxUnsentCollect,
      key: boxUnsentCollect,
      defaultValue: <CollectModel>[],
    );
    final unsentCollect = List<CollectModel>.from(values ?? <CollectModel>[]);
    unsentCollect.add(collectModel);
    await database.put<String, List>(
      boxName: boxUnsentCollect,
      key: boxUnsentCollect,
      value: unsentCollect,
    );
  }
}

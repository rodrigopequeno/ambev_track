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
    final values =
        await database.get(boxName: boxCacheCollect, key: boxCacheCollect);
    final cacheCollect = List<CollectModel>.from(values);
    cacheCollect.add(collectModel);
    await database.put(
      boxName: boxCacheCollect,
      key: boxCacheCollect,
      value: cacheCollect,
    );
  }

  @override
  Future<void> saveUnsentCollect({
    required CollectModel collectModel,
  }) async {
    final values =
        await database.get(boxName: boxUnsentCollect, key: boxUnsentCollect);
    final unsentCollect = List<CollectModel>.from(values);
    unsentCollect.add(collectModel);
    await database.put(
      boxName: boxUnsentCollect,
      key: boxUnsentCollect,
      value: unsentCollect,
    );
  }
}

import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/collect.dart';
import '../../domain/repositories/collect_repository.dart';
import '../datasources/collect_local_data_source.dart';
import '../datasources/collect_remote_data_source.dart';
import '../models/collect_model.dart';

class CollectRepositoryImpl implements CollectRepository {
  final NetworkInfo networkInfo;
  final CollectLocalDataSource collectLocalDataSource;
  final CollectRemoteDataSource collectRemoteDataSource;

  CollectRepositoryImpl({
    required this.networkInfo,
    required this.collectLocalDataSource,
    required this.collectRemoteDataSource,
  });

  @override
  Future<Either<Failure, Unit>> addCollect({
    required Collect collect,
  }) async {
    assert(collect is CollectModel);
    if (await networkInfo.isConnected) {
      try {
        await collectRemoteDataSource.insertNewCollect(
          collectModel: collect as CollectModel,
        );
        return await _saveCacheNewCollect(
          collect,
        );
      } catch (e) {
        return _saveUnsentNewCollect(
          collect,
        );
      }
    } else {
      return await _saveUnsentNewCollect(
        collect,
      );
    }
  }

  Future<Either<Failure, Unit>> _saveCacheNewCollect(
    Collect collect,
  ) async {
    await collectLocalDataSource.saveCacheNewCollect(
      collectModel: collect as CollectModel,
    );
    return const Right(unit);
  }

  Future<Either<Failure, Unit>> _saveUnsentNewCollect(
    Collect collect,
  ) async {
    await collectLocalDataSource.saveUnsentCollect(
      collectModel: collect as CollectModel,
    );
    return const Right(unit);
  }
}

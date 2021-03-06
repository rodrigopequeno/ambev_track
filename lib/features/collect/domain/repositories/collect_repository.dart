import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/collect.dart';

abstract class CollectRepository {
  Future<Either<Failure, Unit>> addCollect({
    required Collect collect,
  });
}

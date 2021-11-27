import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/collect.dart';
import '../repositories/add_collect_repository.dart';

class InsertNewCollect implements UseCase<void, InsertNewCollectParams> {
  final AddCollectRepository repository;

  InsertNewCollect({required this.repository});

  @override
  Future<Either<Failure, Unit>> call(InsertNewCollectParams params) async {
    return await repository.addCollect(collect: params.newCollect);
  }
}

class InsertNewCollectParams extends Equatable {
  final Collect newCollect;

  const InsertNewCollectParams({required this.newCollect});

  @override
  List<Object?> get props => [newCollect];
}

import 'package:dartz/dartz.dart';

import '../error/failure.dart';

mixin UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams {
  const NoParams();
}

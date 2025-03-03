import 'package:dartz/dartz.dart';
import 'package:drive_trust/core/error/failures.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

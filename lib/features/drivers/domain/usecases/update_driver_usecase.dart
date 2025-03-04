import 'package:dartz/dartz.dart';
import 'package:drive_trust/core/error/failures.dart';
import 'package:drive_trust/core/utils/use_cases.dart';
import 'package:drive_trust/features/drivers/domain/entities/driver.dart';
import 'package:drive_trust/features/drivers/domain/repositories/driver_repository.dart';
import 'package:equatable/equatable.dart';

class UpdateDriverUseCase implements UseCase<Driver, UpdateDriverParams> {
  final DriverRepository repository;

  UpdateDriverUseCase(this.repository);

  @override
  Future<Either<Failure, Driver>> call(UpdateDriverParams params) {
    return repository.updateDriver(params.driver);
  }
}

class UpdateDriverParams extends Equatable {
  final Driver driver;

  const UpdateDriverParams({
    required this.driver,
  });

  @override
  List<Object> get props => [driver];
}

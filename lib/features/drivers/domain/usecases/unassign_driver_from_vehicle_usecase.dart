import 'package:dartz/dartz.dart';
import 'package:drive_trust/core/error/failures.dart';
import 'package:drive_trust/core/utils/use_cases.dart';
import 'package:drive_trust/features/drivers/domain/entities/driver.dart';
import 'package:drive_trust/features/drivers/domain/repositories/driver_repository.dart';
import 'package:equatable/equatable.dart';

class UnassignDriverFromVehicleUseCase
    implements UseCase<Driver, UnassignDriverFromVehicleParams> {
  final DriverRepository repository;

  UnassignDriverFromVehicleUseCase(this.repository);

  @override
  Future<Either<Failure, Driver>> call(UnassignDriverFromVehicleParams params) {
    return repository.unassignDriverFromVehicle(params.driverId);
  }
}

class UnassignDriverFromVehicleParams extends Equatable {
  final String driverId;

  const UnassignDriverFromVehicleParams({
    required this.driverId,
  });

  @override
  List<Object> get props => [driverId];
}

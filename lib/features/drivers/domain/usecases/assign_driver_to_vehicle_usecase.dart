import 'package:dartz/dartz.dart';
import 'package:drive_trust/core/error/failures.dart';
import 'package:drive_trust/core/utils/use_cases.dart';
import 'package:drive_trust/features/drivers/domain/entities/driver.dart';
import 'package:drive_trust/features/drivers/domain/repositories/driver_repository.dart';
import 'package:equatable/equatable.dart';

class AssignDriverToVehicleUseCase implements UseCase<Driver, AssignDriverToVehicleParams> {
  final DriverRepository repository;

  AssignDriverToVehicleUseCase(this.repository);

  @override
  Future<Either<Failure, Driver>> call(AssignDriverToVehicleParams params) {
    return repository.assignDriverToVehicle(
      params.driverId,
      params.vehicleId,
      params.contractStatus,
    );
  }
}

class AssignDriverToVehicleParams extends Equatable {
  final String driverId;
  final String vehicleId;
  final ContractStatus contractStatus;

  const AssignDriverToVehicleParams({
    required this.driverId,
    required this.vehicleId,
    this.contractStatus = ContractStatus.active,
  });

  @override
  List<Object> get props => [driverId, vehicleId, contractStatus];
}

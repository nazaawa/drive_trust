import 'package:dartz/dartz.dart';
import 'package:drive_trust/core/error/failures.dart';
import 'package:drive_trust/core/utils/use_cases.dart';
import 'package:drive_trust/features/drivers/domain/entities/driver.dart';
import 'package:drive_trust/features/drivers/domain/repositories/driver_repository.dart';
import 'package:equatable/equatable.dart';

class GetDriversUseCase implements UseCase<List<Driver>, GetDriversParams> {
  final DriverRepository repository;

  GetDriversUseCase(this.repository);

  @override
  Future<Either<Failure, List<Driver>>> call(GetDriversParams params) {
    if (params.vehicleId != null) {
      return repository.getDriversByVehicleId(params.vehicleId!);
    } else {
      return repository.getDriversByOwnerId(params.ownerId);
    }
  }
}

class GetDriversParams extends Equatable {
  final String ownerId;
  final String? vehicleId;

  const GetDriversParams({
    required this.ownerId,
    this.vehicleId,
  });

  @override
  List<Object?> get props => [ownerId, vehicleId];
}

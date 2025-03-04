import 'package:dartz/dartz.dart';
import 'package:drive_trust/core/error/failures.dart';
import 'package:drive_trust/features/vehicles/domain/entities/vehicle.dart';
import 'package:drive_trust/features/vehicles/domain/repositories/vehicle_repository.dart';

class GetVehiclesUseCase {
  final VehicleRepository repository;

  GetVehiclesUseCase(this.repository);

  Future<Either<Failure, List<Vehicle>>> call(String ownerId) {
    return repository.getVehiclesByOwnerId(ownerId);
  }
}

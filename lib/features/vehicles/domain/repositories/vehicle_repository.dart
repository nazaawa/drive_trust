import 'package:dartz/dartz.dart';
import 'package:drive_trust/core/error/failures.dart';
import 'package:drive_trust/features/vehicles/domain/entities/vehicle.dart';

abstract class VehicleRepository {
  /// Get all vehicles for a specific owner
  Future<Either<Failure, List<Vehicle>>> getVehiclesByOwnerId(String ownerId);

  /// Get a vehicle by its ID
  Future<Either<Failure, Vehicle>> getVehicleById(String id);

  /// Add a new vehicle
  Future<Either<Failure, Vehicle>> addVehicle(
    String ownerId,
    String plateNumber,
    String brand,
    String model,
  );

  /// Update an existing vehicle
  Future<Either<Failure, Vehicle>> updateVehicle(Vehicle vehicle);

  /// Delete a vehicle
  Future<Either<Failure, void>> deleteVehicle(String id);
}

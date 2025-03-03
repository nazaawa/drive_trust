import 'package:dartz/dartz.dart';
import 'package:drive_trust/core/error/failures.dart';
import 'package:drive_trust/features/drivers/domain/entities/driver.dart';

abstract class DriverRepository {
  /// Get all drivers created by a specific owner
  Future<Either<Failure, List<Driver>>> getDriversByOwnerId(String ownerId);

  /// Get drivers assigned to a specific vehicle
  Future<Either<Failure, List<Driver>>> getDriversByVehicleId(String vehicleId);

  /// Get a driver by its ID
  Future<Either<Failure, Driver>> getDriverById(String id);

  /// Add a new driver
  Future<Either<Failure, Driver>> addDriver(
    String name,
    String email,
    String? vehicleId,
    ContractStatus contractStatus,
  );

  /// Update an existing driver
  Future<Either<Failure, Driver>> updateDriver(Driver driver);

  /// Delete a driver
  Future<Either<Failure, void>> deleteDriver(String id);

  /// Assign a driver to a vehicle
  Future<Either<Failure, Driver>> assignDriverToVehicle(
    String driverId,
    String vehicleId,
    ContractStatus contractStatus,
  );

  /// Unassign a driver from a vehicle
  Future<Either<Failure, Driver>> unassignDriverFromVehicle(String driverId);
}

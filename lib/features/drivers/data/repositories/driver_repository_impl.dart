import 'package:dartz/dartz.dart';
import 'package:drive_trust/core/error/exceptions.dart';
import 'package:drive_trust/core/error/failures.dart';
import 'package:drive_trust/features/drivers/data/datasources/driver_remote_datasource.dart';
import 'package:drive_trust/features/drivers/data/models/driver_model.dart';
import 'package:drive_trust/features/drivers/domain/entities/driver.dart';
import 'package:drive_trust/features/drivers/domain/repositories/driver_repository.dart';

class DriverRepositoryImpl implements DriverRepository {
  final DriverRemoteDataSource remoteDataSource;

  DriverRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Driver>>> getDriversByOwnerId(
      String ownerId) async {
    try {
      final drivers = await remoteDataSource.getDriversByOwnerId(ownerId);
      return Right(drivers);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Driver>>> getDriversByVehicleId(
      String vehicleId) async {
    try {
      final drivers = await remoteDataSource.getDriversByVehicleId(vehicleId);
      return Right(drivers);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Driver>> getDriverById(String id) async {
    try {
      final driver = await remoteDataSource.getDriverById(id);
      return Right(driver);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Driver>> addDriver(
    String name,
    String email,
    String? vehicleId,
    ContractStatus contractStatus,
  ) async {
    try {
      // We need to get the current user's ID to set as the owner
      // This would typically come from an auth repository or provider
      // For now, we'll pass it from the presentation layer
      final ownerId =
          "current_user_id"; // This will be replaced with the actual user ID

      final driver = await remoteDataSource.addDriver(
        ownerId,
        name,
        email,
        vehicleId,
        contractStatus,
      );
      return Right(driver);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Driver>> updateDriver(Driver driver) async {
    try {
      final driverModel = DriverModel(
        id: driver.id,
        name: driver.name,
        email: driver.email,
        vehicleId: driver.vehicleId,
        contractStatus: driver.contractStatus,
      );

      final updatedDriver = await remoteDataSource.updateDriver(driverModel);
      return Right(updatedDriver);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteDriver(String id) async {
    try {
      await remoteDataSource.deleteDriver(id);
      return const Right(null);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Driver>> assignDriverToVehicle(
    String driverId,
    String vehicleId,
    ContractStatus contractStatus,
  ) async {
    try {
      final driver = await remoteDataSource.assignDriverToVehicle(
        driverId,
        vehicleId,
        contractStatus,
      );
      return Right(driver);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Driver>> unassignDriverFromVehicle(
      String driverId) async {
    try {
      final driver = await remoteDataSource.unassignDriverFromVehicle(driverId);
      return Right(driver);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

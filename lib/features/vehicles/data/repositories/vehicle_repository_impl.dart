import 'package:dartz/dartz.dart';
import 'package:drive_trust/core/error/failures.dart';
import 'package:drive_trust/features/vehicles/data/datasources/vehicle_remote_datasource.dart';
import 'package:drive_trust/features/vehicles/data/models/vehicle_model.dart';
import 'package:drive_trust/features/vehicles/domain/entities/vehicle.dart';
import 'package:drive_trust/features/vehicles/domain/repositories/vehicle_repository.dart';

class VehicleRepositoryImpl implements VehicleRepository {
  final VehicleRemoteDataSource remoteDataSource;

  VehicleRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Vehicle>>> getVehiclesByOwnerId(String ownerId) async {
    try {
      final vehicles = await remoteDataSource.getVehiclesByOwnerId(ownerId);
      return Right(vehicles);
    } catch (e) {
      return Left(ServerFailure('Impossible de récupérer les véhicules'));
    }
  }

  @override
  Future<Either<Failure, Vehicle>> getVehicleById(String id) async {
    try {
      final vehicle = await remoteDataSource.getVehicleById(id);
      return Right(vehicle);
    } catch (e) {
      return Left(ServerFailure('Véhicule non trouvé'));
    }
  }

  @override
  Future<Either<Failure, Vehicle>> addVehicle(
    String ownerId,
    String plateNumber,
    String brand,
    String model,
  ) async {
    try {
      final vehicle = await remoteDataSource.addVehicle(
        ownerId,
        plateNumber,
        brand,
        model,
      );
      return Right(vehicle);
    } catch (e) {
      return Left(ServerFailure('Impossible d\'ajouter le véhicule'));
    }
  }

  @override
  Future<Either<Failure, Vehicle>> updateVehicle(Vehicle vehicle) async {
    try {
      final updatedVehicle = await remoteDataSource.updateVehicle(
        VehicleModel(
          id: vehicle.id,
          ownerId: vehicle.ownerId,
          plateNumber: vehicle.plateNumber,
          brand: vehicle.brand,
          model: vehicle.model,
        ),
      );
      return Right(updatedVehicle);
    } catch (e) {
      return Left(ServerFailure('Impossible de mettre à jour le véhicule'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteVehicle(String id) async {
    try {
      await remoteDataSource.deleteVehicle(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Impossible de supprimer le véhicule'));
    }
  }
}

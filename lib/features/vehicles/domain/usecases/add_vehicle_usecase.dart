import 'package:dartz/dartz.dart';
import 'package:drive_trust/core/error/failures.dart';
import 'package:drive_trust/features/vehicles/domain/entities/vehicle.dart';
import 'package:drive_trust/features/vehicles/domain/repositories/vehicle_repository.dart';
import 'package:equatable/equatable.dart';

class AddVehicleUseCase {
  final VehicleRepository repository;

  AddVehicleUseCase(this.repository);

  Future<Either<Failure, Vehicle>> call(AddVehicleParams params) {
    return repository.addVehicle(
      params.ownerId,
      params.plateNumber,
      params.brand,
      params.model,
    );
  }
}

class AddVehicleParams extends Equatable {
  final String ownerId;
  final String plateNumber;
  final String brand;
  final String model;

  const AddVehicleParams({
    required this.ownerId,
    required this.plateNumber,
    required this.brand,
    required this.model,
  });

  @override
  List<Object> get props => [ownerId, plateNumber, brand, model];
}

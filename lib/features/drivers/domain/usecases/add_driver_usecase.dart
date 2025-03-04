import 'package:dartz/dartz.dart';
import 'package:drive_trust/core/error/failures.dart';
import 'package:drive_trust/core/utils/use_cases.dart';
import 'package:drive_trust/features/drivers/domain/entities/driver.dart';
import 'package:drive_trust/features/drivers/domain/repositories/driver_repository.dart';
import 'package:equatable/equatable.dart';

class AddDriverUseCase implements UseCase<Driver, AddDriverParams> {
  final DriverRepository repository;

  AddDriverUseCase(this.repository);

  @override
  Future<Either<Failure, Driver>> call(AddDriverParams params) {
    return repository.addDriver(
      params.name,
      params.email,
      params.vehicleId,
      params.contractStatus,
    );
  }
}

class AddDriverParams extends Equatable {
  final String name;
  final String email;
  final String? vehicleId;
  final ContractStatus contractStatus;

  const AddDriverParams({
    required this.name,
    required this.email,
    this.vehicleId,
    this.contractStatus = ContractStatus.inactive,
  });

  @override
  List<Object?> get props => [name, email, vehicleId, contractStatus];
}

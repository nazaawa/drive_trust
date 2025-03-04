import 'package:dartz/dartz.dart';
import 'package:drive_trust/core/error/failures.dart';
import 'package:drive_trust/core/utils/use_cases.dart';
import 'package:drive_trust/features/drivers/domain/repositories/driver_repository.dart';
import 'package:equatable/equatable.dart';

class DeleteDriverUseCase implements UseCase<void, DeleteDriverParams> {
  final DriverRepository repository;

  DeleteDriverUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteDriverParams params) {
    return repository.deleteDriver(params.driverId);
  }
}

class DeleteDriverParams extends Equatable {
  final String driverId;

  const DeleteDriverParams({
    required this.driverId,
  });

  @override
  List<Object> get props => [driverId];
}

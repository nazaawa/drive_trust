import 'package:dartz/dartz.dart';
import 'package:drive_trust/core/error/failures.dart';
import 'package:drive_trust/features/transactions/domain/entities/transaction.dart';
import 'package:drive_trust/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:equatable/equatable.dart';

class WatchTransactionsByVehicleIdUseCase {
  final TransactionRepository repository;

  WatchTransactionsByVehicleIdUseCase(this.repository);

  Stream<Either<Failure, List<TransactionEntity>>> call(
      WatchTransactionsByVehicleIdParams params) {
    return repository.watchTransactionsByVehicleId(params.vehicleId);
  }
}

class WatchTransactionsByVehicleIdParams extends Equatable {
  final String vehicleId;

  const WatchTransactionsByVehicleIdParams({required this.vehicleId});

  @override
  List<Object> get props => [vehicleId];
}

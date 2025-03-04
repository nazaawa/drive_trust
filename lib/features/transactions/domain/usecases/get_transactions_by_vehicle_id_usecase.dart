import 'package:dartz/dartz.dart';
import 'package:drive_trust/core/error/failures.dart';
import 'package:drive_trust/features/transactions/domain/entities/transaction.dart';
import 'package:drive_trust/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:equatable/equatable.dart';

class GetTransactionsByVehicleIdUseCase {
  final TransactionRepository repository;

  GetTransactionsByVehicleIdUseCase(this.repository);

  Future<Either<Failure, List<TransactionEntity>>> call(
      GetTransactionsByVehicleIdParams params) async {
    return await repository.getTransactionsByVehicleId(params.vehicleId);
  }
}

class GetTransactionsByVehicleIdParams extends Equatable {
  final String vehicleId;

  const GetTransactionsByVehicleIdParams({required this.vehicleId});

  @override
  List<Object> get props => [vehicleId];
}

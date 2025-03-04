import 'package:dartz/dartz.dart';
import 'package:drive_trust/core/error/failures.dart';
import 'package:drive_trust/features/transactions/domain/entities/transaction.dart';
import 'package:drive_trust/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:equatable/equatable.dart';

class AddTransactionUseCase {
  final TransactionRepository repository;

  AddTransactionUseCase(this.repository);

  Future<Either<Failure, TransactionEntity>> call(
      AddTransactionParams params) async {
    return await repository.addTransaction(
      params.vehicleId,
      params.amount,
      params.category,
      params.description,
    );
  }
}

class AddTransactionParams extends Equatable {
  final String vehicleId;
  final double amount;
  final TransactionCategory category;
  final String description;

  const AddTransactionParams({
    required this.vehicleId,
    required this.amount,
    required this.category,
    required this.description,
  });

  @override
  List<Object> get props => [vehicleId, amount, category, description];
}

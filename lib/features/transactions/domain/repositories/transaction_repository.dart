import 'package:dartz/dartz.dart';
import 'package:drive_trust/core/error/failures.dart';
import 'package:drive_trust/features/transactions/domain/entities/transaction.dart';

abstract class TransactionRepository {
  /// Get all transactions for a specific vehicle
  Future<Either<Failure, List<TransactionEntity>>> getTransactionsByVehicleId(
    String vehicleId,
  );

  /// Get a transaction by its ID
  Future<Either<Failure, TransactionEntity>> getTransactionById(String id);

  /// Add a new transaction
  Future<Either<Failure, TransactionEntity>> addTransaction(
    String vehicleId,
    double amount,
    TransactionCategory category,
    String description,
  );

  /// Update an existing transaction
  Future<Either<Failure, TransactionEntity>> updateTransaction(
      TransactionEntity transaction);

  /// Delete a transaction
  Future<Either<Failure, void>> deleteTransaction(String id);

  /// Stream of transactions for a specific vehicle
  Stream<Either<Failure, List<TransactionEntity>>> watchTransactionsByVehicleId(
      String vehicleId);
}

import 'package:dartz/dartz.dart';
import 'package:drive_trust/core/error/failures.dart';
import 'package:drive_trust/features/transactions/domain/entities/transaction.dart';

abstract class TransactionRepository {
  /// Get all transactions for a specific vehicle
  Future<Either<Failure, List<Transaction>>> getTransactionsByVehicleId(
    String vehicleId,
  );

  /// Get a transaction by its ID
  Future<Either<Failure, Transaction>> getTransactionById(String id);

  /// Add a new transaction
  Future<Either<Failure, Transaction>> addTransaction(
    String vehicleId,
    double amount,
    TransactionCategory category,
    String description,
  );

  /// Update an existing transaction
  Future<Either<Failure, Transaction>> updateTransaction(Transaction transaction);

  /// Delete a transaction
  Future<Either<Failure, void>> deleteTransaction(String id);
}

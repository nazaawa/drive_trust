import 'package:dartz/dartz.dart';
import 'package:drive_trust/core/error/exceptions.dart';
import 'package:drive_trust/core/error/failures.dart';
import 'package:drive_trust/features/transactions/data/datasources/transaction_remote_datasource.dart';
import 'package:drive_trust/features/transactions/domain/entities/transaction.dart';
import 'package:drive_trust/features/transactions/domain/repositories/transaction_repository.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDataSource remoteDataSource;

  TransactionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<TransactionEntity>>> getTransactionsByVehicleId(
      String vehicleId) async {
    try {
      final transactions =
          await remoteDataSource.getTransactionsByVehicleId(vehicleId);
      return Right(transactions);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TransactionEntity>> getTransactionById(
      String id) async {
    try {
      final transaction = await remoteDataSource.getTransactionById(id);
      return Right(transaction);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TransactionEntity>> addTransaction(
    String vehicleId,
    double amount,
    TransactionCategory category,
    String description,
  ) async {
    try {
      final transaction = await remoteDataSource.addTransaction(
        vehicleId,
        amount,
        category,
        description,
      );
      return Right(transaction);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TransactionEntity>> updateTransaction(
      TransactionEntity transaction) async {
    try {
      final updatedTransaction =
          await remoteDataSource.updateTransaction(transaction);
      return Right(updatedTransaction);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTransaction(String id) async {
    try {
      await remoteDataSource.deleteTransaction(id);
      return const Right(null);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<Either<Failure, List<TransactionEntity>>> watchTransactionsByVehicleId(
      String vehicleId) {
    return remoteDataSource
        .watchTransactionsByVehicleId(vehicleId)
        .map((transactions) {
      return Right<Failure, List<TransactionEntity>>(transactions);
    }).handleError((error) {
      if (error is ServerException) {
        return Left<Failure, List<TransactionEntity>>(ServerFailure());
      }
      return Left<Failure, List<TransactionEntity>>(
          ServerFailure(error.toString()));
    });
  }
}

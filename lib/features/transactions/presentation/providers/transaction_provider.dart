import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_trust/features/transactions/data/datasources/transaction_remote_datasource.dart';
import 'package:drive_trust/features/transactions/data/repositories/transaction_repository_impl.dart';
import 'package:drive_trust/features/transactions/domain/entities/transaction.dart';
import 'package:drive_trust/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:drive_trust/features/transactions/domain/usecases/add_transaction_usecase.dart';
import 'package:drive_trust/features/transactions/domain/usecases/delete_transaction_usecase.dart';
import 'package:drive_trust/features/transactions/domain/usecases/get_transactions_by_vehicle_id_usecase.dart';
import 'package:drive_trust/features/transactions/domain/usecases/watch_transactions_by_vehicle_id_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Repository providers
final transactionRemoteDataSourceProvider =
    Provider<TransactionRemoteDataSource>((ref) {
  return TransactionRemoteDataSourceImpl(
    firestore: FirebaseFirestore.instance,
  );
});

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  final remoteDataSource = ref.watch(transactionRemoteDataSourceProvider);
  return TransactionRepositoryImpl(remoteDataSource: remoteDataSource);
});

// Use case providers
final addTransactionUseCaseProvider = Provider<AddTransactionUseCase>((ref) {
  final repository = ref.watch(transactionRepositoryProvider);
  return AddTransactionUseCase(repository);
});

final getTransactionsByVehicleIdUseCaseProvider =
    Provider<GetTransactionsByVehicleIdUseCase>((ref) {
  final repository = ref.watch(transactionRepositoryProvider);
  return GetTransactionsByVehicleIdUseCase(repository);
});

final watchTransactionsByVehicleIdUseCaseProvider =
    Provider<WatchTransactionsByVehicleIdUseCase>((ref) {
  final repository = ref.watch(transactionRepositoryProvider);
  return WatchTransactionsByVehicleIdUseCase(repository);
});

final deleteTransactionUseCaseProvider =
    Provider<DeleteTransactionUseCase>((ref) {
  final repository = ref.watch(transactionRepositoryProvider);
  return DeleteTransactionUseCase(repository);
});

// State providers
final transactionsStreamProvider =
    StreamProvider.family<List<TransactionEntity>, String>((ref, vehicleId) {
  final useCase = ref.watch(watchTransactionsByVehicleIdUseCaseProvider);
  return useCase(WatchTransactionsByVehicleIdParams(vehicleId: vehicleId))
      .map((result) {
    return result.fold(
      (failure) => <TransactionEntity>[],
      (transactions) => transactions,
    );
  });
});

// Selected transaction provider
final selectedVehicleIdForTransactionsProvider =
    StateProvider<String?>((ref) => null);

// Transaction category filter provider
final transactionCategoryFilterProvider =
    StateProvider<TransactionCategory?>((ref) => null);

// Transaction total amount provider
final transactionTotalProvider =
    Provider.family<double, String>((ref, vehicleId) {
  final transactionsAsyncValue =
      ref.watch(transactionsStreamProvider(vehicleId));
  final categoryFilter = ref.watch(transactionCategoryFilterProvider);

  return transactionsAsyncValue.when(
    data: (transactions) {
      if (categoryFilter != null) {
        final filteredTransactions =
            transactions.where((t) => t.category == categoryFilter).toList();
        return filteredTransactions.fold(
            0.0, (sum, transaction) => sum + transaction.amount);
      }
      return transactions.fold(
          0.0, (sum, transaction) => sum + transaction.amount);
    },
    loading: () => 0.0,
    error: (_, __) => 0.0,
  );
});

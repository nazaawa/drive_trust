import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_trust/core/error/exceptions.dart';
import 'package:drive_trust/features/transactions/data/models/transaction_model.dart';
import 'package:drive_trust/features/transactions/domain/entities/transaction.dart';

abstract class TransactionRemoteDataSource {
  /// Get all transactions for a specific vehicle
  Future<List<TransactionModel>> getTransactionsByVehicleId(String vehicleId);

  /// Get a transaction by its ID
  Future<TransactionEntity> getTransactionById(String id);

  /// Add a new transaction
  Future<TransactionEntity> addTransaction(
    String vehicleId,
    double amount,
    TransactionCategory category,
    String description,
  );

  /// Update an existing transaction
  Future<TransactionEntity> updateTransaction(TransactionEntity transaction);

  /// Delete a transaction
  Future<void> deleteTransaction(String id);

  /// Stream of transactions for a specific vehicle
  Stream<List<TransactionEntity>> watchTransactionsByVehicleId(String vehicleId);
}

class TransactionRemoteDataSourceImpl implements TransactionRemoteDataSource {
  final FirebaseFirestore firestore;

  TransactionRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<TransactionModel>> getTransactionsByVehicleId(String vehicleId) async {
    try {
      final transactionsSnapshot = await firestore
          .collection('transactions')
          .where('vehicleId', isEqualTo: vehicleId)
          .orderBy('timestamp', descending: true)
          .get();

      return transactionsSnapshot.docs
          .map((doc) => TransactionModel.fromJson({
                'id': doc.id,
                ...doc.data(),
              }))
          .toList();
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<TransactionEntity> getTransactionById(String id) async {
    try {
      final transactionDoc = await firestore.collection('transactions').doc(id).get();

      if (!transactionDoc.exists) {
        throw ServerException();
      }

      return TransactionModel.fromJson({
        'id': transactionDoc.id,
        ...transactionDoc.data()!,
      }).toEntity();
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<TransactionEntity> addTransaction(
    String vehicleId,
    double amount,
    TransactionCategory category,
    String description,
  ) async {
    try {
      final transactionData = {
        'vehicleId': vehicleId,
        'amount': amount,
        'category': category.toString().split('.').last,
        'description': description,
        'timestamp': DateTime.now().toIso8601String(),
      };

      final docRef = await firestore.collection('transactions').add(transactionData);
      final newTransaction = await docRef.get();

      return TransactionModel.fromJson({
        'id': docRef.id,
        ...newTransaction.data()!,
      }).toEntity();
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<TransactionEntity> updateTransaction(TransactionEntity transaction) async {
    try {
      await firestore.collection('transactions').doc(transaction.id).update({
        'vehicleId': transaction.vehicleId,
        'amount': transaction.amount,
        'category': transaction.category.toString().split('.').last,
        'description': transaction.description,
        'timestamp': transaction.timestamp.toIso8601String(),
      });

      return transaction;
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<void> deleteTransaction(String id) async {
    try {
      await firestore.collection('transactions').doc(id).delete();
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Stream<List<TransactionEntity>> watchTransactionsByVehicleId(String vehicleId) {
    return firestore
        .collection('transactions')
        .where('vehicleId', isEqualTo: vehicleId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TransactionModel.fromJson({
                  'id': doc.id,
                  ...doc.data(),
                }).toEntity())
            .toList());
  }
}

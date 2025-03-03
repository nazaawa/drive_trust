import 'package:drive_trust/features/transactions/domain/entities/transaction.dart';

class TransactionModel extends Transaction {
  const TransactionModel({
    required String id,
    required String vehicleId,
    required double amount,
    required TransactionCategory category,
    required String description,
    required DateTime timestamp,
  }) : super(
          id: id,
          vehicleId: vehicleId,
          amount: amount,
          category: category,
          description: description,
          timestamp: timestamp,
        );

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      vehicleId: json['vehicleId'],
      amount: (json['amount'] as num).toDouble(),
      category: _mapStringToTransactionCategory(json['category']),
      description: json['description'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vehicleId': vehicleId,
      'amount': amount,
      'category': category.toString().split('.').last,
      'description': description,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  static TransactionCategory _mapStringToTransactionCategory(String category) {
    switch (category) {
      case 'fuel':
        return TransactionCategory.fuel;
      case 'repair':
        return TransactionCategory.repair;
      case 'maintenance':
        return TransactionCategory.maintenance;
      case 'insurance':
        return TransactionCategory.insurance;
      case 'tax':
        return TransactionCategory.tax;
      case 'other':
        return TransactionCategory.other;
      default:
        return TransactionCategory.other;
    }
  }
}

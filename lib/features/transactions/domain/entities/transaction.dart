import 'package:equatable/equatable.dart';

enum TransactionCategory {
  fuel,
  repair,
  maintenance,
  insurance,
  tax,
  other,
}

class Transaction extends Equatable {
  final String id;
  final String vehicleId;
  final double amount;
  final TransactionCategory category;
  final String description;
  final DateTime timestamp;

  const Transaction({
    required this.id,
    required this.vehicleId,
    required this.amount,
    required this.category,
    required this.description,
    required this.timestamp,
  });

  @override
  List<Object> get props => [id, vehicleId, amount, category, description, timestamp];
}

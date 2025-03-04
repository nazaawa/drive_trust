import 'package:drive_trust/features/transactions/domain/entities/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionCard extends StatelessWidget {
  final TransactionEntity transaction;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const TransactionCard({
    super.key,
    required this.transaction,
    this.onDelete,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
    final currencyFormat = NumberFormat.currency(locale: 'fr_FR', symbol: '€');

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _getCategoryIcon(transaction.category),
                  color: _getCategoryColor(transaction.category),
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getCategoryDisplayName(transaction.category),
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        dateFormat.format(transaction.timestamp),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey,
                            ),
                      ),
                    ],
                  ),
                ),
                Text(
                  currencyFormat.format(transaction.amount),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ],
            ),
            if (transaction.description.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                transaction.description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
            if (onDelete != null || onEdit != null) ...[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (onEdit != null)
                    IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      onPressed: onEdit,
                      tooltip: 'Modifier',
                      constraints: const BoxConstraints(),
                      padding: EdgeInsets.zero,
                      iconSize: 20,
                      color: Colors.blue,
                    ),
                  if (onDelete != null) ...[
                    const SizedBox(width: 16),
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: onDelete,
                      tooltip: 'Supprimer',
                      constraints: const BoxConstraints(),
                      padding: EdgeInsets.zero,
                      iconSize: 20,
                      color: Colors.red,
                    ),
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getCategoryDisplayName(TransactionCategory category) {
    switch (category) {
      case TransactionCategory.fuel:
        return 'Carburant';
      case TransactionCategory.repair:
        return 'Réparation';
      case TransactionCategory.maintenance:
        return 'Entretien';
      case TransactionCategory.insurance:
        return 'Assurance';
      case TransactionCategory.tax:
        return 'Taxe';
      case TransactionCategory.other:
        return 'Autre';
    }
  }

  IconData _getCategoryIcon(TransactionCategory category) {
    switch (category) {
      case TransactionCategory.fuel:
        return Icons.local_gas_station;
      case TransactionCategory.repair:
        return Icons.build;
      case TransactionCategory.maintenance:
        return Icons.handyman;
      case TransactionCategory.insurance:
        return Icons.security;
      case TransactionCategory.tax:
        return Icons.receipt;
      case TransactionCategory.other:
        return Icons.more_horiz;
    }
  }

  Color _getCategoryColor(TransactionCategory category) {
    switch (category) {
      case TransactionCategory.fuel:
        return Colors.green;
      case TransactionCategory.repair:
        return Colors.red;
      case TransactionCategory.maintenance:
        return Colors.orange;
      case TransactionCategory.insurance:
        return Colors.blue;
      case TransactionCategory.tax:
        return Colors.purple;
      case TransactionCategory.other:
        return Colors.grey;
    }
  }
}

import 'package:drive_trust/features/transactions/domain/entities/transaction.dart';
import 'package:drive_trust/features/transactions/domain/usecases/add_transaction_usecase.dart';
import 'package:drive_trust/features/transactions/domain/usecases/delete_transaction_usecase.dart';
import 'package:drive_trust/features/transactions/presentation/providers/transaction_provider.dart';
import 'package:drive_trust/features/transactions/presentation/widgets/transaction_card.dart';
import 'package:drive_trust/features/vehicles/presentation/providers/vehicle_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class TransactionListScreen extends ConsumerStatefulWidget {
  final String vehicleId;

  const TransactionListScreen({
    super.key,
    required this.vehicleId,
  });

  @override
  ConsumerState<TransactionListScreen> createState() => _TransactionListScreenState();
}

class _TransactionListScreenState extends ConsumerState<TransactionListScreen> {
  @override
  void initState() {
    super.initState();
    // Use Future.microtask to update the state after the build is complete
    Future.microtask(() {
      ref.read(selectedVehicleIdForTransactionsProvider.notifier).state = widget.vehicleId;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Watch the vehicle details
    final vehicleAsyncValue = ref.watch(vehicleStreamProvider(widget.vehicleId));

    // Watch the transactions for this vehicle
    final transactionsAsyncValue =
        ref.watch(transactionsStreamProvider(widget.vehicleId));

    // Watch the category filter
    final categoryFilter = ref.watch(transactionCategoryFilterProvider);

    // Watch the total amount
    final totalAmount = ref.watch(transactionTotalProvider(widget.vehicleId));

    return Scaffold(
      appBar: AppBar(
        title: vehicleAsyncValue.when(
          data: (vehicle) =>
              Text('Transactions: ${vehicle.brand} ${vehicle.model}'),
          loading: () => const Text('Transactions'),
          error: (_, __) => const Text('Transactions'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(context, ref),
          ),
        ],
      ),
      body: Column(
        children: [
          // Summary card
          SummaryCard(totalAmount: totalAmount, categoryFilter: categoryFilter),

          // Transaction list
          Expanded(
            child: transactionsAsyncValue.when(
              data: (transactions) {
                // Apply category filter if selected
                final filteredTransactions = categoryFilter != null
                    ? transactions
                        .where((transaction) =>
                            transaction.category == categoryFilter)
                        .toList()
                    : transactions;

                if (filteredTransactions.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.receipt_long,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Aucune transaction',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Ajoutez votre première transaction en appuyant sur le bouton +',
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey,
                                  ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredTransactions.length,
                  itemBuilder: (context, index) {
                    final transaction = filteredTransactions[index];
                    return TransactionCard(
                      transaction: transaction,
                      onDelete: () =>
                          _confirmDeleteTransaction(context, ref, transaction),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Text('Erreur: $error'),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTransactionDialog(context, ref, widget.vehicleId),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class SummaryCard extends ConsumerWidget {
  final double totalAmount;
  final TransactionCategory? categoryFilter;

  const SummaryCard({
    super.key,
    required this.totalAmount,
    this.categoryFilter,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currencyFormat = NumberFormat.currency(locale: 'fr_FR', symbol: '€');

    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  categoryFilter != null
                      ? 'Total ${_getCategoryDisplayName(categoryFilter!)}'
                      : 'Total des transactions',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (categoryFilter != null)
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      // Reset the category filter
                      ref
                          .read(transactionCategoryFilterProvider.notifier)
                          .state = null;
                    },
                    iconSize: 20,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              currencyFormat.format(totalAmount),
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

void _showFilterDialog(BuildContext context, WidgetRef ref) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Filtrer par catégorie'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...TransactionCategory.values.map(
              (category) => ListTile(
                title: Text(_getCategoryDisplayName(category)),
                leading: Icon(_getCategoryIcon(category)),
                onTap: () {
                  ref.read(transactionCategoryFilterProvider.notifier).state =
                      category;
                  Navigator.pop(context);
                },
              ),
            ),
            const Divider(),
            ListTile(
              title: const Text('Toutes les catégories'),
              leading: const Icon(Icons.clear_all),
              onTap: () {
                ref.read(transactionCategoryFilterProvider.notifier).state =
                    null;
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    },
  );
}

void _showAddTransactionDialog(
    BuildContext context, WidgetRef ref, String vehicleId) {
  final formKey = GlobalKey<FormState>();
  double? amount;
  String description = '';
  TransactionCategory category = TransactionCategory.other;

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Ajouter une transaction'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Amount field
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Montant (€)',
                    prefixIcon: Icon(Icons.euro),
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un montant';
                    }
                    final parsedValue =
                        double.tryParse(value.replaceAll(',', '.'));
                    if (parsedValue == null) {
                      return 'Montant invalide';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    amount = double.parse(value!.replaceAll(',', '.'));
                  },
                ),
                const SizedBox(height: 16),

                // Category dropdown
                DropdownButtonFormField<TransactionCategory>(
                  decoration: const InputDecoration(
                    labelText: 'Catégorie',
                    prefixIcon: Icon(Icons.category),
                  ),
                  value: category,
                  items: TransactionCategory.values.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Row(
                        children: [
                          Icon(_getCategoryIcon(category), size: 20),
                          const SizedBox(width: 8),
                          Text(_getCategoryDisplayName(category)),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      category = value;
                    }
                  },
                ),
                const SizedBox(height: 16),

                // Description field
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    prefixIcon: Icon(Icons.description),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer une description';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    description = value!;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                formKey.currentState!.save();
                _addTransaction(ref, vehicleId, amount!, category, description);
                Navigator.pop(context);
              }
            },
            child: const Text('Ajouter'),
          ),
        ],
      );
    },
  );
}

void _addTransaction(
  WidgetRef ref,
  String vehicleId,
  double amount,
  TransactionCategory category,
  String description,
) async {
  final addTransactionUseCase = ref.read(addTransactionUseCaseProvider);
  final result = await addTransactionUseCase(
    AddTransactionParams(
      vehicleId: vehicleId,
      amount: amount,
      category: category,
      description: description,
    ),
  );

  result.fold(
    (failure) => print('Error adding transaction: $failure'),
    (transaction) => print('Transaction added: ${transaction.id}'),
  );
}

void _confirmDeleteTransaction(
    BuildContext context, WidgetRef ref, TransactionEntity transaction) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Supprimer la transaction'),
        content: const Text(
            'Êtes-vous sûr de vouloir supprimer cette transaction ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              _deleteTransaction(ref, transaction.id);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Supprimer'),
          ),
        ],
      );
    },
  );
}

void _deleteTransaction(WidgetRef ref, String transactionId) async {
  final deleteTransactionUseCase = ref.read(deleteTransactionUseCaseProvider);
  final result = await deleteTransactionUseCase(
    DeleteTransactionParams(id: transactionId),
  );

  result.fold(
    (failure) => print('Error deleting transaction: $failure'),
    (_) => print('Transaction deleted: $transactionId'),
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

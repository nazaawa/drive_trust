import 'package:drive_trust/features/auth/presentation/providers/auth_provider.dart';
import 'package:drive_trust/features/transactions/domain/entities/transaction.dart';
import 'package:drive_trust/features/transactions/presentation/providers/transaction_provider.dart';
import 'package:drive_trust/features/vehicles/presentation/providers/vehicle_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('DriveTrust'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authNotifierProvider.notifier).signOut();
              context.go('/login');
            },
          ),
        ],
      ),
      body: userState.when(
        data: (user) {
          if (user == null) {
            return const Center(
              child: Text('Vous n\'êtes pas connecté'),
            );
          }

          return _HomeContent(user: user);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Erreur: $error'),
        ),
      ),
    );
  }
}

class _HomeContent extends ConsumerWidget {
  final dynamic user;

  const _HomeContent({required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehiclesState = ref.watch(vehicleProvider);
    final vehicleCount = vehiclesState.maybeWhen(
      data: (vehicles) => vehicles.length,
      orElse: () => 0,
    );

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bonjour,',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  user.displayName?.isNotEmpty == true
                      ? user.displayName!
                      : user.email ?? 'Utilisateur',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Bienvenue sur DriveTrust, votre compagnon de confiance pour la gestion de vos véhicules.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                ),
              ],
            ),
          ),

          // Quick stats
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Aperçu',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),

          SizedBox(
            height: 120,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _StatCard(
                  title: 'Véhicules',
                  value: vehicleCount.toString(),
                  icon: Icons.directions_car,
                  color: Colors.blue,
                ),
                _TransactionStatCard(
                  title: 'Dépenses',
                  category: null,
                  icon: Icons.euro,
                  color: Colors.green,
                ),
                _TransactionStatCard(
                  title: 'Carburant',
                  category: TransactionCategory.fuel,
                  icon: Icons.local_gas_station,
                  color: Colors.orange,
                ),
                _TransactionStatCard(
                  title: 'Entretien',
                  category: TransactionCategory.maintenance,
                  icon: Icons.build,
                  color: Colors.purple,
                ),
              ],
            ),
          ),

          // Features section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Fonctionnalités',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Theme.of(context).cardColor
            : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: color,
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey,
                ),
          ),
        ],
      ),
    );
  }
}

class _TransactionStatCard extends ConsumerWidget {
  final String title;
  final TransactionCategory? category;
  final IconData icon;
  final Color color;

  const _TransactionStatCard({
    required this.title,
    required this.category,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehiclesState = ref.watch(vehicleProvider);

    return vehiclesState.when(
      data: (vehicles) {
        double totalAmount = 0;

        for (final vehicle in vehicles) {
          final amount =
              ref.watch(_getTransactionAmountProvider((vehicle.id, category)));
          totalAmount += amount;
        }

        final currencyFormat =
            NumberFormat.currency(locale: 'fr_FR', symbol: '€');

        return Container(
          width: 150,
          margin: const EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? Theme.of(context).cardColor
                : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: color,
                size: 32,
              ),
              const SizedBox(height: 8),
              Text(
                currencyFormat.format(totalAmount),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                    ),
              ),
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

// Provider to get transaction amount for a specific vehicle and category
final _getTransactionAmountProvider =
    Provider.family<double, (String, TransactionCategory?)>((ref, params) {
  final vehicleId = params.$1;
  final category = params.$2;

  final transactionsAsyncValue =
      ref.watch(transactionsStreamProvider(vehicleId));

  return transactionsAsyncValue.when(
    data: (transactions) {
      if (category != null) {
        final filteredTransactions =
            transactions.where((t) => t.category == category).toList();
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

import 'package:drive_trust/features/drivers/domain/entities/driver.dart';
import 'package:drive_trust/features/drivers/presentation/providers/driver_provider.dart';
import 'package:drive_trust/features/drivers/presentation/widgets/driver_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DriverListScreen extends ConsumerWidget {
  const DriverListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final driversState = ref.watch(driverNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Chauffeurs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(driverNotifierProvider.notifier).refreshDrivers();
            },
          ),
        ],
      ),
      body: driversState.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Center(
          child: Text('Erreur: ${error.toString()}'),
        ),
        data: (drivers) {
          if (drivers.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.person_off,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Aucun chauffeur',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Ajoutez des chauffeurs pour gérer vos véhicules',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      _showAddDriverDialog(context, ref);
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Ajouter un chauffeur'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await ref.read(driverNotifierProvider.notifier).refreshDrivers();
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: drivers.length,
              itemBuilder: (context, index) {
                final driver = drivers[index];
                return DriverCard(
                  driver: driver,
                  onEdit: () => _showEditDriverDialog(context, ref, driver),
                  onDelete: () => _showDeleteDriverDialog(context, ref, driver),
                  onAssign: driver.vehicleId == null
                      ? () => _showAssignVehicleDialog(context, ref, driver)
                      : null,
                  onUnassign: driver.vehicleId != null
                      ? () => _showUnassignVehicleDialog(context, ref, driver)
                      : null,
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddDriverDialog(context, ref);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddDriverDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ajouter un chauffeur'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nom',
                hintText: 'Entrez le nom du chauffeur',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'Entrez l\'email du chauffeur',
              ),
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  emailController.text.isNotEmpty) {
                ref.read(driverNotifierProvider.notifier).addDriver(
                      nameController.text,
                      emailController.text,
                    );
                Navigator.of(context).pop();
              }
            },
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );
  }

  void _showEditDriverDialog(BuildContext context, WidgetRef ref, Driver driver) {
    final nameController = TextEditingController(text: driver.name);
    final emailController = TextEditingController(text: driver.email);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Modifier le chauffeur'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nom',
                hintText: 'Entrez le nom du chauffeur',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'Entrez l\'email du chauffeur',
              ),
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  emailController.text.isNotEmpty) {
                final updatedDriver = Driver(
                  id: driver.id,
                  name: nameController.text,
                  email: emailController.text,
                  vehicleId: driver.vehicleId,
                  contractStatus: driver.contractStatus,
                );
                ref
                    .read(driverNotifierProvider.notifier)
                    .updateDriver(updatedDriver);
                Navigator.of(context).pop();
              }
            },
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDriverDialog(
      BuildContext context, WidgetRef ref, Driver driver) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer le chauffeur'),
        content: Text(
            'Êtes-vous sûr de vouloir supprimer le chauffeur ${driver.name} ?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              ref.read(driverNotifierProvider.notifier).deleteDriver(driver.id);
              Navigator.of(context).pop();
            },
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  void _showAssignVehicleDialog(
      BuildContext context, WidgetRef ref, Driver driver) {
    // TODO: Implement vehicle selection from a list of available vehicles
    // For now, we'll just show a placeholder
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Assigner à un véhicule'),
        content: const Text(
            'Cette fonctionnalité sera disponible prochainement.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showUnassignVehicleDialog(
      BuildContext context, WidgetRef ref, Driver driver) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Retirer du véhicule'),
        content: Text(
            'Êtes-vous sûr de vouloir retirer le chauffeur ${driver.name} du véhicule ?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              ref
                  .read(driverNotifierProvider.notifier)
                  .unassignDriverFromVehicle(driver.id);
              Navigator.of(context).pop();
            },
            child: const Text('Retirer'),
          ),
        ],
      ),
    );
  }
}

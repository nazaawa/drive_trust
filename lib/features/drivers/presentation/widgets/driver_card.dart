import 'package:drive_trust/core/theme/app_theme.dart';
import 'package:drive_trust/features/drivers/domain/entities/driver.dart';
import 'package:drive_trust/features/vehicles/presentation/providers/vehicle_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DriverCard extends ConsumerWidget {
  final Driver driver;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onAssign;
  final VoidCallback? onUnassign;

  const DriverCard({
    super.key,
    required this.driver,
    this.onEdit,
    this.onDelete,
    this.onAssign,
    this.onUnassign,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 6,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor:
                      AppTheme.primaryColor.withValues(alpha: 0.15),
                  child: Icon(Icons.person,
                      size: 28, color: AppTheme.primaryColor),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        driver.name,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        driver.email,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: [
                _buildStatusChip(context),
                if (driver.vehicleId != null) _buildVehicleChip(context, ref),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (onAssign != null)
                  _buildActionButton(
                    icon: Icons.add,
                    label: 'Assigner',
                    onPressed: onAssign!,
                    color: Colors.blue,
                  ),
                if (onUnassign != null)
                  _buildActionButton(
                    icon: Icons.remove,
                    label: 'Retirer',
                    onPressed: onUnassign!,
                    color: Colors.orange,
                  ),
                if (onEdit != null)
                  _buildActionButton(
                    icon: Icons.edit,
                    label: 'Modifier',
                    onPressed: onEdit!,
                    color: Colors.grey,
                  ),
                if (onDelete != null)
                  _buildActionButton(
                    icon: Icons.delete,
                    label: 'Supprimer',
                    onPressed: onDelete!,
                    color: Colors.red,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context) {
    final isActive = driver.contractStatus == ContractStatus.active;
    return Chip(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      backgroundColor: isActive
          ? Colors.green.withValues(alpha: 0.1)
          : Colors.grey.withValues(alpha: 0.1),
      label: Text(
        isActive ? 'Actif' : 'Inactif',
        style: TextStyle(
          color: isActive ? Colors.green : Colors.grey[700],
          fontWeight: FontWeight.w600,
        ),
      ),
      avatar: Icon(
        isActive ? Icons.check_circle : Icons.cancel,
        size: 18,
        color: isActive ? Colors.green : Colors.grey[700],
      ),
    );
  }

  Widget _buildVehicleChip(BuildContext context, WidgetRef ref) {
    final vehiclesState = ref.watch(vehicleProvider);
    return vehiclesState.when(
      loading: () => const Chip(label: Text('Chargement...')),
      error: (_, __) => const Chip(label: Text('Erreur')),
      data: (vehicles) {
        final vehicle = vehicles.firstWhere((v) => v.id == driver.vehicleId);
        return Chip(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          backgroundColor: Colors.blue.withValues(alpha: 0.1),
          label: Text(
            '${vehicle.brand} ${vehicle.model}',
            style: const TextStyle(
                color: Colors.blue, fontWeight: FontWeight.w600),
          ),
          avatar:
              const Icon(Icons.directions_car, size: 18, color: Colors.blue),
        );
      },
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: TextButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 18, color: color),
        label: Text(label, style: TextStyle(color: color)),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
      ),
    );
  }
}

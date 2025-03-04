import 'package:drive_trust/features/drivers/domain/entities/driver.dart';
import 'package:flutter/material.dart';

class DriverCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  child: Icon(
                    Icons.person,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        driver.name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        driver.email,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatusChip(context),
                ),
                if (onEdit != null)
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: onEdit,
                    tooltip: 'Modifier',
                  ),
                if (onDelete != null)
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: onDelete,
                    tooltip: 'Supprimer',
                  ),
              ],
            ),
            if (driver.vehicleId != null || onAssign != null || onUnassign != null)
              const Divider(height: 24),
            if (driver.vehicleId != null || onAssign != null || onUnassign != null)
              Row(
                children: [
                  Expanded(
                    child: driver.vehicleId != null
                        ? _buildVehicleInfo(context)
                        : const Text('Aucun véhicule assigné'),
                  ),
                  if (onAssign != null)
                    TextButton.icon(
                      onPressed: onAssign,
                      icon: const Icon(Icons.add),
                      label: const Text('Assigner'),
                    ),
                  if (onUnassign != null)
                    TextButton.icon(
                      onPressed: onUnassign,
                      icon: const Icon(Icons.remove),
                      label: const Text('Retirer'),
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
      backgroundColor: isActive
          ? Colors.green.withOpacity(0.1)
          : Colors.grey.withOpacity(0.1),
      label: Text(
        isActive ? 'Actif' : 'Inactif',
        style: TextStyle(
          color: isActive ? Colors.green : Colors.grey,
          fontWeight: FontWeight.bold,
        ),
      ),
      avatar: Icon(
        isActive ? Icons.check_circle : Icons.cancel,
        size: 16,
        color: isActive ? Colors.green : Colors.grey,
      ),
    );
  }

  Widget _buildVehicleInfo(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.directions_car,
          size: 16,
          color: Colors.blue,
        ),
        const SizedBox(width: 8),
        Text(
          'Véhicule assigné',
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

import 'package:drive_trust/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Le routeur s'occupera de la redirection en fonction de l'état d'authentification
    // Nous n'avons besoin que d'afficher un écran de chargement
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            const Icon(
              Icons.directions_car_rounded,
              size: 100,
              color: Colors.blue,
            ),
            const SizedBox(height: 24),

            // Nom de l'application
            Text(
              'DriveTrust',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: 16),

            // Indicateur de chargement
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

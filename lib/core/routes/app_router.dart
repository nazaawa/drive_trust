import 'dart:async';
import 'package:drive_trust/features/auth/presentation/providers/auth_provider.dart';
import 'package:drive_trust/features/auth/presentation/screens/login_screen.dart';
import 'package:drive_trust/features/auth/presentation/screens/signup_screen.dart';
import 'package:drive_trust/features/auth/presentation/screens/splash_screen.dart';
import 'package:drive_trust/features/home/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider<GoRouter>((ref) {
  // Écouter les changements d'état d'authentification via le StreamProvider
  final authState = ref.watch(authStateChangesProvider);

  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    refreshListenable:
        GoRouterRefreshStream(ref.read(authStateChangesProvider.stream)),
    redirect: (context, state) {
      // Obtenir l'état d'authentification actuel
      final isLoading = authState.isLoading;
      final isAuthenticated = authState.valueOrNull == AuthStatus.authenticated;
      final isAuthenticating = state.matchedLocation == '/login' ||
          state.matchedLocation == '/signup';

      // Si l'état est en cours de chargement, ne pas rediriger
      if (isLoading) {
        return null;
      }

      // Si l'utilisateur n'est pas authentifié et n'est pas sur une page d'authentification, rediriger vers login
      if (!isAuthenticated &&
          !isAuthenticating &&
          state.matchedLocation != '/') {
        return '/login';
      }

      // Si l'utilisateur est authentifié et sur une page d'authentification, rediriger vers home
      if (isAuthenticated && isAuthenticating) {
        return '/home';
      }

      // Pas de redirection nécessaire
      return null;
    },
    routes: [
      // Écran de démarrage (route initiale)
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),

      // Routes d'authentification
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),

      // Routes principales de l'application
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),

      // Routes placeholder pour implémentation future
      GoRoute(
        path: '/vehicles',
        builder: (context, state) => Scaffold(
          appBar: AppBar(title: Text('Véhicules')),
          body: Center(child: Text('Page des véhicules à implémenter')),
        ),
      ),
      GoRoute(
        path: '/drivers',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Page des chauffeurs à implémenter')),
        ),
      ),
      GoRoute(
        path: '/transactions',
        builder: (context, state) => Scaffold(
          appBar: AppBar(title: Text('Transactions')),
          body: Center(child: Text('Page des transactions à implémenter')),
        ),
      ),
      GoRoute(
        path: '/reports',
        builder: (context, state) => Scaffold(
          appBar: AppBar(title: Text('Rapports')),
          body: Center(child: Text('Page des rapports à implémenter')),
        ),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Erreur')),
      body: Center(
        child: Text('Page non trouvée: ${state.matchedLocation}'),
      ),
    ),
  );
});

// Classe utilitaire pour utiliser un Stream comme Listenable pour GoRouter
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
        );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

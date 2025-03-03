import 'package:drive_trust/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'routes.dart';

part 'app_router.g.dart';

final routerKey = GlobalKey<NavigatorState>();

@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  final user = ref.watch(currentUserNotifierProvider);

  return GoRouter(
    navigatorKey: routerKey,
    initialLocation: SplashRoute().location,
    routes: $appRoutes,
    redirect: (context, state) {
      final isAuthenticated = user.asyncValue.value != null;
      final isLoggingIn = state.uri.path == const SplashRoute().location;

      if (isLoggingIn) {
        if (isAuthenticated) {
          return const HomeRoute().location;
        }
        return null;
      }

      return null;
    },
    debugLogDiagnostics: true,
  );
}

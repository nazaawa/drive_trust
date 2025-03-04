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
  final userNotifier = ref.watch(currentUserNotifierProvider);

  return GoRouter(
    navigatorKey: routerKey,
    initialLocation: SplashRoute().location,
    routes: $appRoutes,
    redirect: (context, state) {
      // Get current auth state
      final isAuthenticated = userNotifier.asyncValue.value != null;
      
      // Get current location
      final location = state.uri.path;
      
      // Check if we're on an auth route
      final isOnSplashScreen = location == const SplashRoute().location;
      final isOnLoginScreen = location == const LoginRoute().location;
      final isOnSignUpScreen = location == const SignUpRoute().location;
      final isOnForgotPasswordScreen = location == const ForgotPasswordRoute().location;
      final isOnAuthRoute = isOnSplashScreen || isOnLoginScreen || isOnSignUpScreen || isOnForgotPasswordScreen;
      
      // Handle loading state
      final isLoading = userNotifier.asyncValue.isLoading;
      if (isLoading) {
        return null; // Don't redirect while loading
      }
      
      // Handle error state
      final hasError = userNotifier.asyncValue.hasError;
      if (hasError && !isOnAuthRoute) {
        return const LoginRoute().location;
      }
      
      // Redirect logic
      if (isAuthenticated) {
        // If user is authenticated but on an auth route, redirect to home
        if (isOnAuthRoute) {
          return const HomeRoute().location;
        }
        // Otherwise, allow access to the requested page
        return null;
      } else {
        // If user is not authenticated and not on an auth route, redirect to login
        if (!isOnAuthRoute) {
          return const LoginRoute().location;
        }
        // Allow access to auth routes
        return null;
      }
    },
    debugLogDiagnostics: true,
    refreshListenable: userNotifier,
  );
}

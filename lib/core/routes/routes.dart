import 'package:drive_trust/features/auth/presentation/screens/login_screen.dart';
import 'package:drive_trust/features/auth/presentation/screens/signup_screen.dart';
import 'package:drive_trust/features/auth/presentation/screens/splash_screen.dart';
import 'package:drive_trust/features/home/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'routes.g.dart';

@TypedGoRoute<SplashRoute>(
  path: '/',
  routes: [
    TypedGoRoute<LoginRoute>(
      path: 'login',
    ),
    TypedGoRoute<SignUpRoute>(
      path: 'sign-up',
      routes: [
        TypedGoRoute<MobileNumberRoute>(
          path: 'mobile-number',
        ),
        TypedGoRoute<OTPVerificationRoute>(
          path: 'otp-verification',
        )
      ],
    ),
    TypedGoRoute<ForgotPasswordRoute>(
      path: 'forgot-password',
    ),
  ],
)
class SplashRoute extends GoRouteData {
  const SplashRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SplashScreen();
  }
}

class LoginRoute extends GoRouteData {
  const LoginRoute();
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: const LoginScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-1, 0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
    );
  }
}

class SignUpRoute extends GoRouteData {
  const SignUpRoute();
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: const SignupScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
    );
  }
}

class OTPVerificationRoute extends GoRouteData {
  const OTPVerificationRoute();
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: Container(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
    );
  }
}

class MobileNumberRoute extends GoRouteData {
  const MobileNumberRoute();
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: Container(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-1, 0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
    );
  }
}

class ForgotPasswordRoute extends GoRouteData {
  const ForgotPasswordRoute();
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: Container(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
    );
  }
}

@TypedGoRoute<HomeRoute>(
  path: "/home",
)
class HomeRoute extends GoRouteData {
  const HomeRoute();
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: const HomeScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
    );
  }
}

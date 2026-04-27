import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pole_mobile/features/activities/pages/activity_detail_page.dart';
import 'package:pole_mobile/features/auth/pages/auth_landing_page.dart';
import 'package:pole_mobile/features/auth/pages/login_page.dart';
import 'package:pole_mobile/features/auth/pages/register_page.dart';
import 'package:pole_mobile/features/auth/providers/session_provider.dart';
import 'package:pole_mobile/features/discover/pages/discover_page.dart';
import 'package:pole_mobile/features/home/pages/home_page.dart';
import 'package:pole_mobile/features/notifications/pages/notifications_page.dart';
import 'package:pole_mobile/features/profile/pages/profile_page.dart';
import 'package:pole_mobile/features/shell/shell_page.dart';
import 'package:pole_mobile/features/splash/splash_page.dart';


final routerProvider = Provider<GoRouter>((ref) {
  final notifier = _RouterNotifier(ref);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: notifier,
    redirect: notifier.redirect,
    routes: [
      GoRoute(
        path: '/splash',
        builder: (_, _) => const SplashPage(),
      ),
      GoRoute(
        path: '/auth',
        builder: (_, _) => const AuthLandingPage(),
        routes: [
          GoRoute(
            path: 'login',
            builder: (_, _) => const LoginPage(),
          ),
          GoRoute(
            path: 'register',
            builder: (_, _) => const RegisterPage(),
          ),
        ],
      ),
      ShellRoute(
        builder: (_, _, child) => ShellPage(child: child),
        routes: [
          GoRoute(
            path: '/home',
            builder: (_, _) => const HomePage(),
          ),
          GoRoute(
            path: '/discover',
            builder: (_, _) => const DiscoverPage(),
          ),
          GoRoute(
            path: '/notifications',
            builder: (_, _) => const NotificationsPage(),
          ),
          GoRoute(
            path: '/profile',
            builder: (_, _) => const ProfilePage(),
          ),
        ],
      ),
      GoRoute(
        path: '/activity/:id',
        builder: (_, state) {
          final id = int.parse(state.pathParameters['id']!);
          return ActivityDetailPage(activityId: id);
        },
      ),
    ],
  );
});

class _RouterNotifier extends ChangeNotifier {
  _RouterNotifier(this._ref) {
    _ref.listen<String?>(tokenProvider, (_, _) => notifyListeners());
  }

  final Ref _ref;

  String? redirect(BuildContext context, GoRouterState state) {
    final token = _ref.read<String?>(tokenProvider);
    final isAuthenticated = token != null;
    final location = state.uri.toString();
    final isOnSplash = location == '/splash';
    final isOnAuth = location.startsWith('/auth');

    if (isOnSplash) return null;
    if (!isAuthenticated && !isOnAuth) return '/auth';
    if (isAuthenticated && isOnAuth) return '/home';
    return null;
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_theme.dart';
import '../../core/providers/auth_provider.dart';
import '../navigation/app_shell.dart';
import 'login_screen.dart';

class AuthGate extends ConsumerStatefulWidget {
  const AuthGate({
    super.key,
    required this.enableSessionRestore,
  });

  final bool enableSessionRestore;

  @override
  ConsumerState<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends ConsumerState<AuthGate> {
  @override
  void initState() {
    super.initState();
    if (widget.enableSessionRestore) {
      Future.microtask(
        () => ref.read(authControllerProvider.notifier).restoreSession(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    if (authState.isLoading && !authState.isAuthenticated) {
      return const _BootLoadingView();
    }

    if (authState.isAuthenticated) {
      return AppShell(user: authState.user!);
    }

    return const LoginScreen();
  }
}

class _BootLoadingView extends StatelessWidget {
  const _BootLoadingView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF5F3FF), Color(0xFFF8F7F4)],
          ),
        ),
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: AppTheme.primary),
              SizedBox(height: 14),
              Text(
                'Initialisation de votre espace...',
                style: TextStyle(
                  color: AppTheme.textMuted,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

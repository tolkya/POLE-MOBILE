import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pole_mobile/core/network/dio_provider.dart';
import 'package:pole_mobile/core/storage/secure_storage.dart';
import 'package:pole_mobile/features/auth/providers/session_provider.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkSession());
  }

  Future<void> _checkSession() async {
    final storage = ref.read<SecureStorage>(secureStorageProvider);
    final token = await storage.read(StorageKeys.token);

    if (!mounted) return;

    if (token != null) {
      ref.read(tokenProvider.notifier).token = token;
      GoRouter.of(context).go('/home');
    } else {
      GoRouter.of(context).go('/auth');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
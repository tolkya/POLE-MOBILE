import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pole_mobile/core/env/env.dart';
import 'package:pole_mobile/core/network/auth_interceptor.dart';
import 'package:pole_mobile/core/network/error_interceptor.dart';
import 'package:pole_mobile/core/storage/secure_storage.dart';
import 'package:pole_mobile/features/auth/providers/session_provider.dart';

/// Provider exposant le [SecureStorage] à toute l'app.
final secureStorageProvider = Provider<SecureStorage>(
  (_) => SecureStorage(),
);

/// Provider exposant l'instance [Dio] configurée.
/// Injecter ce provider dans tous les repositories HTTP.
final dioProvider = Provider<Dio>((ref) {
  final storage = ref.read(secureStorageProvider);

  final dio = Dio(
    BaseOptions(
      baseUrl: Env.apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  );

  dio.interceptors.addAll([
    AuthInterceptor(storage),
    ErrorInterceptor(
      onUnauthorized: () {
        // Supprime le token → le router redirige automatiquement vers /auth
        unawaited(storage.delete(StorageKeys.token));
        ref.invalidate(tokenProvider);
      },
    ),
    LogInterceptor(responseBody: true),
  ]);

  return dio;
});

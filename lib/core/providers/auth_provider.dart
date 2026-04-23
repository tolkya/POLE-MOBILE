import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/api_client.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/token_storage_service.dart';

class AuthState {
  const AuthState({
    required this.isLoading,
    required this.user,
    required this.error,
  });

  final bool isLoading;
  final UserModel? user;
  final String? error;

  bool get isAuthenticated => user != null;

  factory AuthState.initial() => const AuthState(
        isLoading: false,
        user: null,
        error: null,
      );

  AuthState copyWith({
    bool? isLoading,
    UserModel? user,
    String? error,
    bool clearError = false,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

final tokenStorageProvider = Provider<TokenStorageService>((ref) {
  return TokenStorageService();
});

final dioProvider = Provider<Dio>((ref) {
  final tokenStorage = ref.watch(tokenStorageProvider);
  return ApiClient(tokenStorage).build();
});

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(
    dio: ref.watch(dioProvider),
    tokenStorageService: ref.watch(tokenStorageProvider),
  );
});

final authControllerProvider = NotifierProvider<AuthController, AuthState>(
  AuthController.new,
);

class AuthController extends Notifier<AuthState> {
  @override
  AuthState build() {
    return AuthState.initial();
  }

  AuthService get _authService => ref.read(authServiceProvider);

  Future<void> restoreSession() async {
    state = state.copyWith(isLoading: true, clearError: true);

    final token = await _authService.tokenStorageService.getToken();
    if (token == null || token.isEmpty) {
      state = const AuthState(isLoading: false, user: null, error: null);
      return;
    }

    try {
      final me = await _authService.getMe();
      state = AuthState(isLoading: false, user: me, error: null);
    } on DioException catch (e) {
      await _authService.logout();
      state = AuthState(
        isLoading: false,
        user: null,
        error: 'Session invalide (${e.response?.statusCode ?? 'API'}).',
      );
    } catch (_) {
      await _authService.logout();
      state = const AuthState(
        isLoading: false,
        user: null,
        error: 'Session invalide.',
      );
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      await _authService.login(email: email, password: password);
      final me = await _authService.getMe();
      state = AuthState(isLoading: false, user: me, error: null);
    } on DioException catch (e) {
      state = AuthState(
        isLoading: false,
        user: null,
        error: 'Erreur API: ${e.response?.statusCode ?? 'inconnue'}',
      );
    } catch (e) {
      state = AuthState(
        isLoading: false,
        user: null,
        error: 'Erreur: $e',
      );
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true, clearError: true);
    await _authService.logout();
    state = const AuthState(isLoading: false, user: null, error: null);
  }
}

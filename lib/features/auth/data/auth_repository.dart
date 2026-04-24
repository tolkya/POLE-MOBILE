import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pole_mobile/core/network/dio_provider.dart';
import 'package:pole_mobile/core/storage/secure_storage.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(
    ref.read(dioProvider),
    ref.read(secureStorageProvider),
  ),
);

class AuthRepository {
  AuthRepository(this._dio, this._storage);

  final Dio _dio;
  final SecureStorage _storage;

  /// Connexion → retourne le token Bearer.
  Future<String> login({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/mobile/login',
      data: {'email': email, 'password': password},
    );
    final token = response.data?['token'] as String?;
    if (token == null) throw Exception('Token absent de la réponse');
    await _storage.write(StorageKeys.token, token);
    return token;
  }

  /// Inscription → login automatique → retourne le token Bearer.
  Future<String> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    String? phone,
  }) async {
    await _dio.post<void>(
      '/register/member',
      data: {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password,
        if (phone != null && phone.isNotEmpty) 'phone': phone,
      },
    );
    return login(email: email, password: password);
  }

  /// Supprime le token du stockage sécurisé.
  Future<void> logout() => _storage.deleteAll();
}
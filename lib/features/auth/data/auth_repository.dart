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
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/mobile/login',
        data: {'email': email, 'password': password},
      );
      final token = response.data?['token'] as String?;
      if (token == null) throw Exception('Token absent de la réponse');
      await _storage.write(StorageKeys.token, token);
      return token;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Email ou mot de passe incorrect');
      }
      throw Exception('Erreur réseau, réessaie plus tard');
    }
  }

  /// Inscription → login automatique → retourne le token Bearer.
  Future<String> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    String? phone,
  }) async {
    try {
      await _dio.post<void>(
        '/register',
        data: {
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'plainPassword': password,
          if (phone != null && phone.isNotEmpty) 'phone': phone,
        },
      );
      return login(email: email, password: password);
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      final data = e.response?.data;
      final detail = data is Map<String, dynamic>
          ? data['detail'] as String?
          : null;

      if (status == 429) {
        throw Exception(
          detail ?? "Trop de tentatives d'inscription. Veuillez patienter.",
        );
      }

      throw Exception(detail ?? 'Erreur réseau, réessaie plus tard');
    }
  }

  /// Supprime le token du stockage sécurisé.
  Future<void> logout() => _storage.deleteAll();
}

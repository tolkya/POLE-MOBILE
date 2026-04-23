// lib/core/services/auth_service.dart
import 'package:dio/dio.dart';
import '../models/user_model.dart';
import 'token_storage_service.dart';

class AuthService {
  final Dio dio;
  final TokenStorageService tokenStorageService;

  AuthService({
    required this.dio,
    required this.tokenStorageService,
  });

  Future<void> login({
    required String email,
    required String password,
  }) async {
    final response = await dio.post(
      '/mobile/login',
      data: {'email': email, 'password': password},
    );

    final token = response.data['token'] as String?;
    if (token == null || token.isEmpty) {
      throw Exception('Token manquant dans la reponse login mobile.');
    }

    await tokenStorageService.saveToken(token);
  }

  Future<UserModel> getMe() async {
    final response = await dio.get('/me');
    return UserModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> logout() => tokenStorageService.clearToken();
}
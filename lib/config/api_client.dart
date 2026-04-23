// lib/config/api_client.dart
import 'package:dio/dio.dart';
import '../core/services/token_storage_service.dart';
import 'environment.dart';

class ApiClient {
  final TokenStorageService tokenStorageService;

  ApiClient(this.tokenStorageService);

  Dio build() {
    final dio = Dio(
      BaseOptions(
        baseUrl: Environment.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await tokenStorageService.getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
      ),
    );

    return dio;
  }
}
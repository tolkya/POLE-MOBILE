import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pole_mobile/core/models/user.dart';
import 'package:pole_mobile/core/network/dio_provider.dart';

final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => ProfileRepository(ref.read(dioProvider)),
);

class ProfileRepository {
  ProfileRepository(this._dio);

  final Dio _dio;

  Future<User> getMe() async {
    final response = await _dio.get<Map<String, dynamic>>('/me');
    return User.fromJson(response.data!);
  }

  Future<User> updateProfile({
    required int userId,
    String? firstName,
    String? lastName,
    String? phone,
  }) async {
    final response = await _dio.patch<Map<String, dynamic>>(
      '/users/$userId',
      data: {
        'firstName': ?firstName,
        'lastName': ?lastName,
        'phone': ?phone,
      },
      options: Options(
        headers: {'Content-Type': 'application/merge-patch+json'},
      ),
    );
    return User.fromJson(response.data!);
  }

  Future<void> changePassword({
    required int userId,
    required String oldPassword,
    required String newPassword,
  }) async {
    await _dio.post<void>(
      '/users/$userId/change-password',
      data: {
        'currentPassword': oldPassword,
        'plainPassword': newPassword,
      },
    );
  }
}
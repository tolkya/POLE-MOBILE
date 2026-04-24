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
}
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pole_mobile/core/models/user_club.dart';
import 'package:pole_mobile/core/network/dio_provider.dart';

final clubsRepositoryProvider = Provider<ClubsRepository>(
  (ref) => ClubsRepository(ref.read(dioProvider)),
);

class ClubsRepository {
  ClubsRepository(this._dio);

  final Dio _dio;

  Future<List<UserClub>> getMyClubs() async {
    final response = await _dio.get<Map<String, dynamic>>('/me/clubs');
    final members = response.data?['member'] as List<dynamic>? ?? [];
    return members
        .cast<Map<String, dynamic>>()
        .map(UserClub.fromJson)
        .toList();
  }
}
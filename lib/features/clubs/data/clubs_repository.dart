import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pole_mobile/core/models/activity.dart';
import 'package:pole_mobile/core/models/club.dart';
import 'package:pole_mobile/core/models/user_club.dart';
import 'package:pole_mobile/core/network/dio_provider.dart';

final clubsRepositoryProvider = Provider<ClubsRepository>(
  (ref) => ClubsRepository(ref.read(dioProvider)),
);

class ClubsRepository {
  ClubsRepository(this._dio);

  final Dio _dio;

  Future<List<UserClub>> getMyClubs() async {
    final response = await _dio.get<List<dynamic>>('/me/clubs');
    final members = response.data ?? [];
    return members
        .cast<Map<String, dynamic>>()
        .map(UserClub.fromJson)
        .toList();
  }

  Future<List<Club>> search(String query) async {
    if (query.length < 2) return [];
    final response = await _dio.get<List<dynamic>>(
      '/clubs/search',
      queryParameters: {'name': query},
    );
    return (response.data ?? [])
        .cast<Map<String, dynamic>>()
        .map(Club.fromJson)
        .toList();
  }

  Future<void> joinByCode(String clubCode) async {
    await _dio.post<void>(
      '/user-clubs/join',
      data: {'clubCode': clubCode},
    );
  }

  Future<List<Activity>> getClubActivities(int clubId) async {
    final response = await _dio.get<List<dynamic>>(
      '/clubs/$clubId/activities',
    );
    return (response.data ?? [])
        .cast<Map<String, dynamic>>()
        .map(Activity.fromJson)
        .toList();
  }
}


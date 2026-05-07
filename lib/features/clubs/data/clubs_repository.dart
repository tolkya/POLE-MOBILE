import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pole_mobile/core/models/activity.dart';
import 'package:pole_mobile/core/models/club.dart';
import 'package:pole_mobile/core/models/club_member.dart';
import 'package:pole_mobile/core/models/club_stats.dart';
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
    return members.cast<Map<String, dynamic>>().map(UserClub.fromJson).toList();
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

  Future<Club> getClub(int clubId) async {
    final response = await _dio.get<Map<String, dynamic>>('/clubs/$clubId');
    return Club.fromJson(response.data!);
  }

  Future<void> cancelJoinRequest(int userClubId) async {
    await _dio.delete<void>('/user-clubs/$userClubId');
  }

  Future<void> leaveClub(int userClubId) async {
    await _dio.delete<void>('/user-clubs/$userClubId');
  }

  Future<ClubStats> getClubStats(int clubId) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/clubs/$clubId/stats',
    );
    return ClubStats.fromJson(response.data!);
  }

  Future<List<ClubMember>> getClubMembers(
    int clubId, {
    String? search,
    String? role,
    int? page,
    int? limit,
  }) async {
    final response = await _dio.get<dynamic>(
      '/clubs/$clubId/members',
      queryParameters: <String, dynamic>{
        'search': (search?.isNotEmpty ?? false) ? search : null,
        'role': (role?.isNotEmpty ?? false) ? role : null,
        'page': page,
        'limit': limit,
      }..removeWhere((_, value) => value == null),
    );

    final data = response.data;
    final rows = data is List<dynamic>
        ? data
        : (data is Map<String, dynamic>
              ? (data['member'] as List<dynamic>? ?? const <dynamic>[])
              : const <dynamic>[]);

    return rows
        .cast<Map<String, dynamic>>()
        .map(ClubMember.fromJson)
        .toList();
  }

  Future<void> validateClubMember(int userClubId) async {
    await _dio.patch<void>(
      '/user-clubs/$userClubId',
      data: {'validatedAt': DateTime.now().toIso8601String()},
      options: Options(contentType: 'application/merge-patch+json'),
    );
  }

  Future<void> rejectClubMember(int userClubId) async {
    await _dio.delete<void>('/user-clubs/$userClubId');
  }
}

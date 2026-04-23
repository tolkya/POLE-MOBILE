import 'package:dio/dio.dart';

import '../models/club_model.dart';

class ClubsService {
  ClubsService({required this.dio});

  final Dio dio;

  Future<List<UserClubModel>> fetchMyClubs() async {
    final response = await dio.get('/me/clubs');
    final data = response.data;

    if (data is Map<String, dynamic>) {
      final members = (data['member'] ?? data['hydra:member']) as List<dynamic>?;
      if (members != null) {
        return members
            .whereType<Map<String, dynamic>>()
            .map(UserClubModel.fromJson)
            .toList();
      }
    }

    if (data is List<dynamic>) {
      return data
          .whereType<Map<String, dynamic>>()
          .map(UserClubModel.fromJson)
          .toList();
    }

    return const <UserClubModel>[];
  }

  Future<void> joinClubByCode(String clubCode) async {
    await dio.post(
      '/user-clubs/join',
      data: {'clubCode': clubCode},
    );
  }

  Future<void> createClub(String name) async {
    await dio.post(
      '/clubs',
      data: {'name': name},
    );
  }
}

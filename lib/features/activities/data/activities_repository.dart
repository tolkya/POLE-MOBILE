import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pole_mobile/core/models/user_activity.dart';
import 'package:pole_mobile/core/network/dio_provider.dart';

final activitiesRepositoryProvider = Provider<ActivitiesRepository>(
  (ref) => ActivitiesRepository(ref.read(dioProvider)),
);

class ActivitiesRepository {
  ActivitiesRepository(this._dio);

  final Dio _dio;

  Future<List<UserActivity>> getMyActivities() async {
    final response = await _dio.get<List<dynamic>>('/me/activities');
    return (response.data ?? [])
        .cast<Map<String, dynamic>>()
        .map(UserActivity.fromJson)
        .toList();
  }

  Future<void> joinActivity(int activityId) async {
    await _dio.post<void>(
      '/activities/$activityId/join',
      data: <String, dynamic>{},
    );
  }

  Future<void> leaveActivity(int userActivityId) async {
    await _dio.patch<void>(
      '/user-activities/$userActivityId',
      data: {'status': 'LEFT'},
      options: Options(
        contentType: 'application/merge-patch+json',
      ),
    );
  }
}

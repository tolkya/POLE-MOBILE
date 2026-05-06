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

  Future<void> cancelRequest(int userActivityId) async {
    await _dio.delete<void>('/user-activities/$userActivityId');
  }

  Future<void> reRequestActivity(int userActivityId) async {
    await _dio.patch<void>(
      '/user-activities/$userActivityId',
      data: {'status': 'PENDING'},
      options: Options(
        contentType: 'application/merge-patch+json',
      ),
    );
  }

  Future<List<UserActivity>> getActivityMembers(int activityId) async {
    final response = await _dio.get<List<dynamic>>(
      '/activities/$activityId/members',
    );
    return (response.data ?? [])
        .cast<Map<String, dynamic>>()
        .map(UserActivity.fromJson)
        .toList();
  }

  Future<void> updateEnrollmentStatus(
    int userActivityId,
    String status,
  ) async {
    await _dio.patch<void>(
      '/user-activities/$userActivityId',
      data: {'status': status},
      options: Options(contentType: 'application/merge-patch+json'),
    );
  }

  Future<void> createLevel({
    required int activityId,
    required String name,
    String? description,
  }) async {
    await _dio.post<void>(
      '/activities/$activityId/levels',
      data: {
        'name': name,
        if (description != null && description.isNotEmpty)
          'description': description,
      },
    );
  }

  Future<void> createSkill({
    required int levelId,
    required String name,
    String? description,
  }) async {
    await _dio.post<void>(
      '/levels/$levelId/skills',
      data: {
        'name': name,
        if (description != null && description.isNotEmpty)
          'description': description,
      },
    );
  }

  Future<void> deleteMembership(int userActivityId) async {
    await _dio.delete<void>('/user-activities/$userActivityId');
  }

  Future<void> uploadTuto({
    required int skillId,
    required String filePath,
    required String mimeType,
    void Function(int sent, int total)? onProgress,
  }) async {
    await _dio.post<void>(
      '/skills/$skillId/tutos',
      data: FormData.fromMap({
        'file': await MultipartFile.fromFile(
          filePath,
          contentType: DioMediaType.parse(mimeType),
        ),
      }),
      options: Options(contentType: 'multipart/form-data'),
      onSendProgress: onProgress,
    );
  }

  Future<void> deleteMediaTuto(int tutoId) async {
    await _dio.delete<void>('/skill-media-tutos/$tutoId');
  }

  Future<void> updateSkill({
    required int skillId,
    required String name,
    String? description,
  }) async {
    await _dio.patch<void>(
      '/skills/$skillId',
      data: {
        'name': name,
        'description': description,
      },
      options: Options(contentType: 'application/merge-patch+json'),
    );
  }

  Future<void> deleteSkill(int skillId) async {
    await _dio.delete<void>('/skills/$skillId');
  }
}

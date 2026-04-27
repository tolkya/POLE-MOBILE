import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pole_mobile/core/models/user_activity.dart';
import 'package:pole_mobile/features/activities/data/activities_repository.dart';

final myActivitiesProvider =
    AsyncNotifierProvider<MyActivitiesNotifier, List<UserActivity>>(
  MyActivitiesNotifier.new,
);

class MyActivitiesNotifier extends AsyncNotifier<List<UserActivity>> {
  @override
  Future<List<UserActivity>> build() =>
      ref.read(activitiesRepositoryProvider).getMyActivities();
}
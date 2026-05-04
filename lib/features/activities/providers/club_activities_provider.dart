import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:pole_mobile/core/models/activity.dart';
import 'package:pole_mobile/features/clubs/data/clubs_repository.dart';

final FutureProviderFamily<List<Activity>, int> clubActivitiesProvider =
    FutureProvider.autoDispose.family<List<Activity>, int>((ref, clubId) {
      return ref.read(clubsRepositoryProvider).getClubActivities(clubId);
    });

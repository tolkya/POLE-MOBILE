import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:pole_mobile/core/models/activity_type.dart';
import 'package:pole_mobile/core/models/enums.dart';

part 'activity.freezed.dart';
part 'activity.g.dart';

@freezed
class Activity with _$Activity {
  const factory Activity({
    required int id,
    required String name,
    String? description,
    ActivityType? activityType,
    ActivityStatus? status,
    String? mediaUrl,
  }) = _Activity;

  factory Activity.fromJson(Map<String, dynamic> json) =>
      _$ActivityFromJson(json);
}
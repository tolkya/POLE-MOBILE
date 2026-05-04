import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:pole_mobile/core/models/activity.dart';
import 'package:pole_mobile/core/models/enums.dart';
import 'package:pole_mobile/core/models/user.dart';

part 'user_activity.freezed.dart';
part 'user_activity.g.dart';

@freezed
abstract class UserActivity with _$UserActivity {
  const factory UserActivity({
    required int id,
    required User member,
    required Activity activity,
    ActivityRole? role,
    UserActivityStatus? status,
    DateTime? createdAt,
  }) = _UserActivity;

  factory UserActivity.fromJson(Map<String, dynamic> json) =>
      _$UserActivityFromJson(json);
}

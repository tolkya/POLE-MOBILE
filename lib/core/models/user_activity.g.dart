// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_activity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserActivity _$UserActivityFromJson(Map<String, dynamic> json) =>
    _UserActivity(
      id: (json['id'] as num).toInt(),
      member: User.fromJson(json['member'] as Map<String, dynamic>),
      activity: Activity.fromJson(json['activity'] as Map<String, dynamic>),
      role: $enumDecodeNullable(_$ActivityRoleEnumMap, json['role']),
      status: $enumDecodeNullable(_$UserActivityStatusEnumMap, json['status']),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$UserActivityToJson(_UserActivity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'member': instance.member,
      'activity': instance.activity,
      'role': _$ActivityRoleEnumMap[instance.role],
      'status': _$UserActivityStatusEnumMap[instance.status],
      'createdAt': instance.createdAt?.toIso8601String(),
    };

const _$ActivityRoleEnumMap = {
  ActivityRole.teacher: 'TEACHER',
  ActivityRole.student: 'STUDENT',
};

const _$UserActivityStatusEnumMap = {
  UserActivityStatus.pending: 'PENDING',
  UserActivityStatus.approved: 'APPROVED',
  UserActivityStatus.rejected: 'REJECTED',
  UserActivityStatus.left: 'LEFT',
};

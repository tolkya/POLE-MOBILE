// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Activity _$ActivityFromJson(Map<String, dynamic> json) => _Activity(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  description: json['description'] as String?,
  activityType: json['activityType'] == null
      ? null
      : ActivityType.fromJson(json['activityType'] as Map<String, dynamic>),
  status: $enumDecodeNullable(_$ActivityStatusEnumMap, json['status']),
  mediaUrl: json['mediaUrl'] as String?,
);

Map<String, dynamic> _$ActivityToJson(_Activity instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'activityType': instance.activityType,
  'status': _$ActivityStatusEnumMap[instance.status],
  'mediaUrl': instance.mediaUrl,
};

const _$ActivityStatusEnumMap = {
  ActivityStatus.active: 'ACTIVE',
  ActivityStatus.suspended: 'SUSPENDED',
};

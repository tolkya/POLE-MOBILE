// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ActivityType _$ActivityTypeFromJson(Map<String, dynamic> json) =>
    _ActivityType(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$ActivityTypeToJson(_ActivityType instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
    };

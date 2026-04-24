// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'level.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Level _$LevelFromJson(Map<String, dynamic> json) => _Level(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  position: (json['position'] as num).toInt(),
  description: json['description'] as String?,
);

Map<String, dynamic> _$LevelToJson(_Level instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'position': instance.position,
  'description': instance.description,
};

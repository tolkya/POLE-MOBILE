// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'skill.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Skill _$SkillFromJson(Map<String, dynamic> json) => _Skill(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  description: json['description'] as String?,
  skillMediaTutos:
      (json['skillMediaTutos'] as List<dynamic>?)
          ?.map((e) => SkillMediaTuto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  createdById: _createdByIdFromJson(json['createdBy']),
);

Map<String, dynamic> _$SkillToJson(_Skill instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'skillMediaTutos': instance.skillMediaTutos,
  'createdBy': instance.createdById,
};

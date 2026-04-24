// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'skill_media_tuto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SkillMediaTuto _$SkillMediaTutoFromJson(Map<String, dynamic> json) =>
    _SkillMediaTuto(
      id: (json['id'] as num).toInt(),
      mediaUrl: json['mediaUrl'] as String?,
      mimetype: json['mimetype'] as String?,
      originalName: json['originalName'] as String?,
    );

Map<String, dynamic> _$SkillMediaTutoToJson(_SkillMediaTuto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'mediaUrl': instance.mediaUrl,
      'mimetype': instance.mimetype,
      'originalName': instance.originalName,
    };

import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:pole_mobile/core/models/skill_media_tuto.dart';

part 'skill.freezed.dart';
part 'skill.g.dart';

@freezed
abstract class Skill with _$Skill {
  const factory Skill({
    required int id,
    required String name,
    String? description,
    @Default([]) List<SkillMediaTuto> skillMediaTutos,
    @JsonKey(
      name: 'createdBy',
      fromJson: _createdByIdFromJson,
    )
    int? createdById,
  }) = _Skill;

  factory Skill.fromJson(Map<String, dynamic> json) => _$SkillFromJson(json);
}

int? _createdByIdFromJson(dynamic json) {
  if (json == null) return null;
  if (json is int) return json;
  if (json is Map<String, dynamic>) return json['id'] as int?;
  return null;
}

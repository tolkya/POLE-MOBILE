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
  }) = _Skill;

  factory Skill.fromJson(Map<String, dynamic> json) => _$SkillFromJson(json);
}
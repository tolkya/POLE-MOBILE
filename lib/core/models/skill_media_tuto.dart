import 'package:freezed_annotation/freezed_annotation.dart';

part 'skill_media_tuto.freezed.dart';
part 'skill_media_tuto.g.dart';

@freezed
abstract class SkillMediaTuto with _$SkillMediaTuto {
  const factory SkillMediaTuto({
    required int id,
    String? mediaUrl,
    String? mimetype,
    String? originalName,
    @JsonKey(
      name: 'createdBy',
      fromJson: _createdByIdFromJson,
    )
    int? createdById,
  }) = _SkillMediaTuto;

  factory SkillMediaTuto.fromJson(Map<String, dynamic> json) =>
      _$SkillMediaTutoFromJson(json);
}

int? _createdByIdFromJson(dynamic json) {
  if (json == null) return null;
  if (json is int) return json;
  if (json is Map<String, dynamic>) return json['id'] as int?;
  return null;
}

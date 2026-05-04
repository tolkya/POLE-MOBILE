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
  }) = _SkillMediaTuto;

  factory SkillMediaTuto.fromJson(Map<String, dynamic> json) =>
      _$SkillMediaTutoFromJson(json);
}

import 'package:freezed_annotation/freezed_annotation.dart';

part 'level.freezed.dart';
part 'level.g.dart';

@freezed
abstract class Level with _$Level {
  const factory Level({
    required int id,
    required String name,
    required int position,
    String? description,
  }) = _Level;

  factory Level.fromJson(Map<String, dynamic> json) => _$LevelFromJson(json);
}

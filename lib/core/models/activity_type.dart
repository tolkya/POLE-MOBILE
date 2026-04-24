import 'package:freezed_annotation/freezed_annotation.dart';

part 'activity_type.freezed.dart';
part 'activity_type.g.dart';

@freezed
class ActivityType with _$ActivityType {
  const factory ActivityType({
    required int id,
    required String name,
    String? description,
  }) = _ActivityType;

  factory ActivityType.fromJson(Map<String, dynamic> json) =>
      _$ActivityTypeFromJson(json);
}
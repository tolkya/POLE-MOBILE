import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:pole_mobile/core/models/enums.dart';

part 'club.freezed.dart';
part 'club.g.dart';

@freezed
abstract class Club with _$Club {
  const factory Club({
    required int id,
    required String name,
    String? phone,
    String? email,
    String? description,
    String? street,
    String? postalCode,
    String? city,
    String? country,
    JoinPolicy? joinPolicy,
    String? themeColor,
    String? clubCode,
    String? logoUrl,
  }) = _Club;

  factory Club.fromJson(Map<String, dynamic> json) => _$ClubFromJson(json);
}

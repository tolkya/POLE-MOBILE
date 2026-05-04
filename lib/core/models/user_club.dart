import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:pole_mobile/core/models/club.dart';
import 'package:pole_mobile/core/models/enums.dart';

part 'user_club.freezed.dart';
part 'user_club.g.dart';

@freezed
abstract class UserClub with _$UserClub {
  const factory UserClub({
    required int id,
    required Club club,
    @Default([]) List<ClubRole> roles,
    DateTime? validatedAt,
    DateTime? createdAt,
  }) = _UserClub;

  factory UserClub.fromJson(Map<String, dynamic> json) =>
      _$UserClubFromJson(json);
}

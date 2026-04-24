import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:pole_mobile/core/models/club.dart';
import 'package:pole_mobile/core/models/enums.dart';
import 'package:pole_mobile/core/models/user.dart';

part 'user_club.freezed.dart';
part 'user_club.g.dart';

@freezed
abstract class UserClub with _$UserClub {
  const factory UserClub({
    required int id,
    required Club club,
    required User member,
    @Default([]) List<ClubRole> roles,
    DateTime? validatedAt,
    DateTime? createdAt,
  }) = _UserClub;

  factory UserClub.fromJson(Map<String, dynamic> json) =>
      _$UserClubFromJson(json);
}
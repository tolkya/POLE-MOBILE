// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_club.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserClub _$UserClubFromJson(Map<String, dynamic> json) => _UserClub(
  id: (json['id'] as num).toInt(),
  club: Club.fromJson(json['club'] as Map<String, dynamic>),
  roles:
      (json['roles'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$ClubRoleEnumMap, e))
          .toList() ??
      const [],
  validatedAt: json['validatedAt'] == null
      ? null
      : DateTime.parse(json['validatedAt'] as String),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$UserClubToJson(_UserClub instance) => <String, dynamic>{
  'id': instance.id,
  'club': instance.club,
  'roles': instance.roles.map((e) => _$ClubRoleEnumMap[e]!).toList(),
  'validatedAt': instance.validatedAt?.toIso8601String(),
  'createdAt': instance.createdAt?.toIso8601String(),
};

const _$ClubRoleEnumMap = {
  ClubRole.admin: 'ADMIN',
  ClubRole.teacher: 'TEACHER',
  ClubRole.secretary: 'SECRETARY',
  ClubRole.member: 'MEMBER',
  ClubRole.user: 'USER',
};

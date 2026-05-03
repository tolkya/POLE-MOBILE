// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'club.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Club _$ClubFromJson(Map<String, dynamic> json) => _Club(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  phone: json['phone'] as String?,
  email: json['email'] as String?,
  description: json['description'] as String?,
  street: json['street'] as String?,
  postalCode: json['postalCode'] as String?,
  city: json['city'] as String?,
  country: json['country'] as String?,
  joinPolicy: $enumDecodeNullable(_$JoinPolicyEnumMap, json['joinPolicy']),
  themeColor: json['themeColor'] as String?,
  clubCode: json['clubCode'] as String?,
  logoUrl: json['logoUrl'] as String?,
);

Map<String, dynamic> _$ClubToJson(_Club instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'phone': instance.phone,
  'email': instance.email,
  'description': instance.description,
  'street': instance.street,
  'postalCode': instance.postalCode,
  'city': instance.city,
  'country': instance.country,
  'joinPolicy': _$JoinPolicyEnumMap[instance.joinPolicy],
  'themeColor': instance.themeColor,
  'clubCode': instance.clubCode,
  'logoUrl': instance.logoUrl,
};

const _$JoinPolicyEnumMap = {
  JoinPolicy.autoAccept: 'AUTO_ACCEPT',
  JoinPolicy.manualValidation: 'MANUAL_VALIDATION',
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_receipt.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NotificationEvent _$NotificationEventFromJson(Map<String, dynamic> json) =>
    _NotificationEvent(
      id: (json['id'] as num).toInt(),
      notifType: json['notifType'] as String?,
      subjectType: json['subjectType'] as String?,
      subjectId: (json['subjectId'] as num?)?.toInt(),
      context: json['context'] as Map<String, dynamic>? ?? const {},
      triggeredBy: json['triggeredBy'] == null
          ? null
          : User.fromJson(json['triggeredBy'] as Map<String, dynamic>),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$NotificationEventToJson(_NotificationEvent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'notifType': instance.notifType,
      'subjectType': instance.subjectType,
      'subjectId': instance.subjectId,
      'context': instance.context,
      'triggeredBy': instance.triggeredBy,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

_NotificationReceipt _$NotificationReceiptFromJson(Map<String, dynamic> json) =>
    _NotificationReceipt(
      id: (json['id'] as num).toInt(),
      event: NotificationEvent.fromJson(json['event'] as Map<String, dynamic>),
      isRead: json['isRead'] as bool? ?? false,
      readAt: json['readAt'] == null
          ? null
          : DateTime.parse(json['readAt'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$NotificationReceiptToJson(
  _NotificationReceipt instance,
) => <String, dynamic>{
  'id': instance.id,
  'event': instance.event,
  'isRead': instance.isRead,
  'readAt': instance.readAt?.toIso8601String(),
  'createdAt': instance.createdAt?.toIso8601String(),
};

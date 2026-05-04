import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:pole_mobile/core/models/user.dart';

part 'notification_receipt.freezed.dart';
part 'notification_receipt.g.dart';

@freezed
abstract class NotificationEvent with _$NotificationEvent {
  const factory NotificationEvent({
    required int id,
    String? notifType,
    String? subjectType,
    int? subjectId,
    @Default({}) Map<String, dynamic> context,
    User? triggeredBy,
    DateTime? createdAt,
  }) = _NotificationEvent;

  factory NotificationEvent.fromJson(Map<String, dynamic> json) =>
      _$NotificationEventFromJson(json);
}

@freezed
abstract class NotificationReceipt with _$NotificationReceipt {
  const factory NotificationReceipt({
    required int id,
    required NotificationEvent event,
    @Default(false) bool isRead,
    DateTime? readAt,
    DateTime? createdAt,
  }) = _NotificationReceipt;

  factory NotificationReceipt.fromJson(Map<String, dynamic> json) =>
      _$NotificationReceiptFromJson(json);
}

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pole_mobile/core/models/notification_receipt.dart';
import 'package:pole_mobile/core/network/dio_provider.dart';

final notificationsRepositoryProvider = Provider<NotificationsRepository>(
  (ref) => NotificationsRepository(ref.read(dioProvider)),
);

class NotificationsRepository {
  NotificationsRepository(this._dio);

  final Dio _dio;

  Future<List<NotificationReceipt>> getReceipts() async {
    final response = await _dio.get<List<dynamic>>('/notification-receipts');
    final rawList = response.data ?? [];
    final result = <NotificationReceipt>[];

    for (final raw in rawList) {
      if (raw is! Map<String, dynamic>) continue;
      final event = raw['event'];
      if (raw['id'] is! num) continue;
      if (event is! Map<String, dynamic>) continue;
      if (event['id'] is! num) continue;

      // Some notification rows may contain a partial triggeredBy object.
      // User.fromJson requires id/email/firstName/lastName, so strip invalid payloads.
      final triggeredBy = event['triggeredBy'];
      if (triggeredBy is Map<String, dynamic>) {
        final hasRequiredUserShape =
            triggeredBy['id'] is num &&
            triggeredBy['email'] is String &&
            triggeredBy['firstName'] is String &&
            triggeredBy['lastName'] is String;

        if (!hasRequiredUserShape) {
          event['triggeredBy'] = null;
        }
      }

      try {
        result.add(NotificationReceipt.fromJson(raw));
      } on FormatException {
        // Skip malformed notification rows instead of crashing the app.
      } on Exception {
        // Skip malformed notification rows instead of crashing the app.
      }
    }

    return result;
  }

  Future<void> markAsRead(int receiptId) async {
    await _dio.patch<void>(
      '/notification-receipts/$receiptId',
      data: {'isRead': true},
      options: Options(
        headers: {'Content-Type': 'application/merge-patch+json'},
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pole_mobile/core/models/notification_receipt.dart';
import 'package:pole_mobile/features/notifications/data/notifications_repository.dart';

final notificationsProvider =
    AsyncNotifierProvider<NotificationsNotifier, List<NotificationReceipt>>(
  NotificationsNotifier.new,
);

final unreadCountProvider = Provider<int>((ref) {
  final receipts = ref.watch(notificationsProvider).asData?.value ?? [];
  return receipts.where((r) => !r.isRead).length;
});

class NotificationsNotifier
    extends AsyncNotifier<List<NotificationReceipt>> {
  @override
  Future<List<NotificationReceipt>> build() async {
     // Polling toutes les 30 minutes en foreground
    final timer = Timer.periodic(const Duration(minutes: 30), (_) => refresh());
    ref.onDispose(timer.cancel);
    return ref.read(notificationsRepositoryProvider).getReceipts();
  }

  Future<void> markAsRead(int receiptId) async {
    await ref.read(notificationsRepositoryProvider).markAsRead(receiptId);
    state = AsyncData(
      (state.asData?.value ?? []).map((r) {
        return r.id == receiptId ? r.copyWith(isRead: true) : r;
      }).toList(),
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(notificationsRepositoryProvider).getReceipts(),
    );
  }
}
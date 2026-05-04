import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pole_mobile/core/models/notification_receipt.dart';
import 'package:pole_mobile/features/notifications/providers/notifications_provider.dart';
import 'package:pole_mobile/shared/widgets/empty_state.dart';
import 'package:pole_mobile/shared/widgets/error_view.dart';
import 'package:pole_mobile/shared/widgets/skeleton_loader.dart';

class NotificationsPage extends ConsumerWidget {
  const NotificationsPage({super.key});

  String _label(NotificationReceipt receipt) {
    final ctx = receipt.event.context;
    return switch (receipt.event.notifType) {
      'MEMBER_VALIDATED' =>
        'Votre adhésion au club '
            '"${ctx['clubName'] ?? ''}" a été validée.',
      'MEMBER_JOIN_REQUEST' =>
        '${ctx['memberName'] ?? 'Un membre'} '
            'demande à rejoindre '
            '"${ctx['clubName'] ?? ''}".',
      'MEMBER_JOIN_APPROVED' =>
        'Votre demande pour "${ctx['clubName'] ?? ''}" a été acceptée.',
      'MEMBER_EXCLUDED' =>
        'Vous avez été exclu du club "${ctx['clubName'] ?? ''}".',
      'ACTIVITY_JOIN_REQUEST' =>
        '${ctx['memberName'] ?? 'Un membre'} '
            "demande à rejoindre l'activité "
            '"${ctx['activityName'] ?? ''}".',
      'ACTIVITY_JOIN_APPROVED' =>
        'Votre inscription à '
            '"${ctx['activityName'] ?? ''}" a été approuvée.',
      'ACTIVITY_JOIN_REJECTED' =>
        'Votre inscription à '
            '"${ctx['activityName'] ?? ''}" a été refusée.',
      'CLUB_VALIDATED' =>
        'Votre club '
            '"${ctx['clubName'] ?? ''}" a été validé par la plateforme.',
      'CLUB_REJECTED' => 'Votre club "${ctx['clubName'] ?? ''}" a été refusé.',
      _ => receipt.event.notifType ?? 'Notification',
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: notificationsAsync.when(
        loading: () => ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: 6,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) => const ListTile(
            leading: SkeletonBox(width: 36, height: 36, borderRadius: 18),
            title: SkeletonBox(height: 14),
            subtitle: Padding(
              padding: EdgeInsets.only(top: 8),
              child: SkeletonBox(height: 12, width: 220),
            ),
          ),
        ),
        error: (e, _) => ErrorView(
          message: 'Impossible de charger les notifications.',
          onRetry: () => ref.read(notificationsProvider.notifier).refresh(),
        ),
        data: (receipts) {
          if (receipts.isEmpty) {
            return const EmptyState(
              message: 'Aucune notification pour le moment.',
              icon: Icons.notifications_none_outlined,
            );
          }

          return RefreshIndicator(
            onRefresh: () => ref.read(notificationsProvider.notifier).refresh(),
            child: ListView.separated(
              itemCount: receipts.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final receipt = receipts[index];
                return Dismissible(
                  key: ValueKey(receipt.id),
                  direction: receipt.isRead
                      ? DismissDirection.none
                      : DismissDirection.endToStart,
                  background: ColoredBox(
                    color: theme.colorScheme.primaryContainer,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: Icon(
                          Icons.done,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ),
                  confirmDismiss: (_) async {
                    await ref
                        .read(notificationsProvider.notifier)
                        .markAsRead(receipt.id);
                    return false;
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: receipt.isRead
                          ? theme.colorScheme.surfaceContainerHighest
                          : theme.colorScheme.primaryContainer,
                      child: Icon(
                        receipt.isRead
                            ? Icons.notifications_none
                            : Icons.notifications,
                        color: receipt.isRead
                            ? theme.colorScheme.onSurfaceVariant
                            : theme.colorScheme.onPrimaryContainer,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      _label(receipt),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: receipt.isRead
                            ? FontWeight.normal
                            : FontWeight.bold,
                      ),
                    ),
                    subtitle: receipt.event.createdAt != null
                        ? Text(
                            _formatDate(receipt.event.createdAt!),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          )
                        : null,
                    tileColor: receipt.isRead
                        ? null
                        : theme.colorScheme.primaryContainer.withValues(
                            alpha: 0.15,
                          ),
                    onTap: receipt.isRead
                        ? null
                        : () => ref
                              .read(notificationsProvider.notifier)
                              .markAsRead(receipt.id),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inMinutes < 1) return "À l'instant";
    if (diff.inHours < 1) return 'Il y a ${diff.inMinutes} min';
    if (diff.inDays < 1) return 'Il y a ${diff.inHours} h';
    if (diff.inDays < 7) return 'Il y a ${diff.inDays} j';
    return '${date.day}/${date.month}/${date.year}';
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pole_mobile/core/models/user_club.dart';
import 'package:pole_mobile/core/theme/club_theme.dart';
import 'package:pole_mobile/core/theme/club_theme_provider.dart';

class StatusBanner extends ConsumerWidget {
  const StatusBanner({required this.userClub, super.key});

  final UserClub userClub;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ct = ref.watch(clubThemeProvider);
    final theme = Theme.of(context);
    final isPending = userClub.validatedAt == null;

    if (isPending) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: ct.subtle,
          border: Border.all(color: ct.border),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.hourglass_top, color: ct.dark),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Adhésion en attente de validation',
                style: theme.textTheme.bodyMedium?.copyWith(color: ct.dark),
              ),
            ),
          ],
        ),
      );
    }

    final roles = userClub.roles;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: ct.subtle,
        border: Border.all(color: ct.border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.verified_user, color: ct.dark),
          const SizedBox(width: 12),
          Expanded(
            child: roles.isEmpty
                ? Text(
                    'Rôle non défini',
                    style: theme.textTheme.bodyMedium?.copyWith(color: ct.dark),
                  )
                : Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: roles
                        .map((role) => _RoleChip(label: role.name, ct: ct))
                        .toList(),
                  ),
          ),
        ],
      ),
    );
  }
}

class _RoleChip extends StatelessWidget {
  const _RoleChip({required this.label, required this.ct});

  final String label;
  final ClubTheme ct;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: ct.border,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: ct.dark,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

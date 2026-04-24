import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pole_mobile/core/models/user_club.dart';
import 'package:pole_mobile/features/clubs/providers/active_club_provider.dart';
import 'package:pole_mobile/features/clubs/providers/my_clubs_provider.dart';

/// Hauteur d'un ListTile standard Material 3
const double _tileHeight = 72;

/// Header : handle (4px) + paddings + titre
const double _headerHeight = 80;

/// Maximum de clubs visibles sans scroller
const int _maxVisibleClubs = 5;

class ClubSwitcherSheet extends ConsumerWidget {
  const ClubSwitcherSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clubs = ref.watch(myClubsProvider).asData?.value ?? [];
    final activeId = ref.watch(activeUserClubProvider)?.club.id;

    final visibleCount = clubs.length.clamp(1, _maxVisibleClubs);
    final sheetHeight = _headerHeight + visibleCount * _tileHeight;

    return SizedBox(
      height: sheetHeight,
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.outlineVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Mes clubs',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: clubs.length,
              itemExtent: _tileHeight,
              itemBuilder: (_, index) {
                final userClub = clubs[index];
                final isActive = userClub.club.id == activeId;
                return _ClubTile(
                  userClub: userClub,
                  isActive: isActive,
                  onTap: () async {
                    await ref
                        .read(activeClubIdProvider.notifier)
                        .setActiveClub(userClub.club.id);
                    if (context.mounted) Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ClubTile extends StatelessWidget {
  const _ClubTile({
    required this.userClub,
    required this.isActive,
    required this.onTap,
  });

  final UserClub userClub;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: theme.colorScheme.primaryContainer,
        child: Text(
          userClub.club.name.substring(0, 1).toUpperCase(),
          style: TextStyle(color: theme.colorScheme.onPrimaryContainer),
        ),
      ),
      title: Text(userClub.club.name),
      subtitle: Text(userClub.roles.map((r) => r.name).join(', ')),
      trailing: isActive
          ? Icon(Icons.check_circle, color: theme.colorScheme.primary)
          : null,
      onTap: onTap,
    );
  }
}
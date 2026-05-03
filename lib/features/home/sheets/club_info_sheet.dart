import 'package:flutter/material.dart';
import 'package:pole_mobile/core/models/activity.dart';
import 'package:pole_mobile/core/models/club.dart';
import 'package:pole_mobile/core/models/club_stats.dart';

class ClubInfoSheet extends StatelessWidget {
  const ClubInfoSheet({
    required this.club,
    this.stats,
    this.activities = const [],
    super.key,
  });

  final Club club;
  final ClubStats? stats;
  final List<Activity> activities;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: FractionallySizedBox(
        heightFactor: 0.9,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            // Poignée
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.outlineVariant,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

              // Nom du club
              Text(club.name, style: theme.textTheme.titleLarge),
              const SizedBox(height: 16),

                // Stats
                if (stats != null) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _StatItem(
                        label: 'Membres',
                        value: stats!.membersCount,
                        icon: Icons.people_outline,
                      ),
                      _StatItem(
                        label: 'Activités',
                        value: stats!.activitiesCount,
                        icon: Icons.sports_gymnastics,
                      ),
                      _StatItem(
                        label: 'Profs',
                        value: stats!.teachersCount,
                        icon: Icons.school_outlined,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 8),
                ],

                // Infos de contact
                if (club.email != null && club.email!.isNotEmpty)
                  _InfoRow(
                    icon: Icons.email_outlined,
                    text: club.email!,
                    theme: theme,
                  ),
                if (club.phone != null && club.phone!.isNotEmpty)
                  _InfoRow(
                    icon: Icons.phone_outlined,
                    text: club.phone!,
                    theme: theme,
                  ),
                if (_addressLine.isNotEmpty)
                  _InfoRow(
                    icon: Icons.location_on_outlined,
                    text: _addressLine,
                    theme: theme,
                  ),
                if (club.clubCode != null && club.clubCode!.isNotEmpty)
                  _InfoRow(
                    icon: Icons.vpn_key_outlined,
                    text: club.clubCode!,
                    theme: theme,
                  ),
                if (club.description != null &&
                    club.description!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    'Description',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    club.description!,
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
                if (_disciplineNames.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    'Disciplines principales',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _disciplineNames
                        .map((name) => Chip(label: Text(name)))
                        .toList(),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<String> get _disciplineNames => activities
      .map((activity) => activity.activityType?.name)
      .whereType<String>()
      .toSet()
      .toList()
    ..sort();

  String get _addressLine {
    final parts = <String>[
      if (club.street != null && club.street!.isNotEmpty) club.street!,
      if (club.postalCode != null && club.postalCode!.isNotEmpty)
        club.postalCode!,
      if (club.city != null && club.city!.isNotEmpty) club.city!,
      if (club.country != null && club.country!.isNotEmpty) club.country!,
    ];
    return parts.join(', ');
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final int value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Icon(icon, color: theme.colorScheme.primary),
        const SizedBox(height: 4),
        Text(
          '$value',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.text,
    required this.theme,
  });

  final IconData icon;
  final String text;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon,
              size: 18, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

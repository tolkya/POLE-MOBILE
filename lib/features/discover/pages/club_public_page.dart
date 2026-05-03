import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:go_router/go_router.dart';
import 'package:pole_mobile/core/models/activity.dart';
import 'package:pole_mobile/core/models/club.dart';
import 'package:pole_mobile/core/models/club_stats.dart';
import 'package:pole_mobile/core/models/enums.dart';
import 'package:pole_mobile/core/models/user_club.dart';
import 'package:pole_mobile/features/clubs/data/clubs_repository.dart';
import 'package:pole_mobile/features/clubs/providers/active_club_provider.dart';
import 'package:pole_mobile/features/clubs/providers/my_clubs_provider.dart';
import 'package:pole_mobile/features/home/widgets/club_hero.dart';

final FutureProviderFamily<Club, int> _clubPublicProvider =
    FutureProvider.autoDispose.family<Club, int>((ref, clubId) async {
  return ref.read(clubsRepositoryProvider).getClub(clubId);
});

final FutureProviderFamily<ClubStats, int> _clubStatsProvider =
    FutureProvider.autoDispose.family<ClubStats, int>((ref, clubId) async {
  return ref.read(clubsRepositoryProvider).getClubStats(clubId);
});

final FutureProviderFamily<List<Activity>, int> _clubActivitiesProvider =
    FutureProvider.autoDispose.family<List<Activity>, int>((ref, clubId) async {
  return ref.read(clubsRepositoryProvider).getClubActivities(clubId);
});

class ClubPublicPage extends ConsumerStatefulWidget {
  const ClubPublicPage({required this.clubId, super.key});

  final int clubId;

  @override
  ConsumerState<ClubPublicPage> createState() => _ClubPublicPageState();
}

class _ClubPublicPageState extends ConsumerState<ClubPublicPage> {
  bool _loading = false;

  Future<void> _joinClub(Club club) async {
    if (club.clubCode == null || club.clubCode!.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Code club indisponible.')),
      );
      return;
    }

    setState(() => _loading = true);
    try {
      await ref.read(clubsRepositoryProvider).joinByCode(club.clubCode!);
      ref.invalidate(myClubsProvider);

      if (!mounted) return;
      final isManual = club.joinPolicy == JoinPolicy.manualValidation;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isManual
                ? 'Demande envoyée, en attente de validation.'
                : 'Vous avez rejoint le club !',
          ),
        ),
      );
      if (!isManual) context.go('/home');
    } on Exception catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _cancelRequest(UserClub userClub) async {
    setState(() => _loading = true);
    try {
      await ref
          .read(clubsRepositoryProvider)
          .cancelJoinRequest(userClub.id);
      ref
        ..invalidate(myClubsProvider)
        ..invalidate(activeClubIdProvider);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Demande d'adhésion annulée.")),
      );
      context.go('/home');
    } on Exception catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final clubAsync = ref.watch(_clubPublicProvider(widget.clubId));
    final statsAsync = ref.watch(_clubStatsProvider(widget.clubId));
    final activitiesAsync = ref.watch(_clubActivitiesProvider(widget.clubId));
    final myClubs = ref.watch(myClubsProvider).asData?.value ?? [];
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Club')),
      body: clubAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erreur : $e')),
        data: (club) {
          // Trouver si l'utilisateur est déjà lié à ce club
          final userClub = myClubs
              .where((uc) => uc.club.id == club.id)
              .firstOrNull;

          final isPending =
              userClub != null && userClub.validatedAt == null;
          final isMember =
              userClub != null && userClub.validatedAt != null;
          final isPrivate =
              club.joinPolicy == JoinPolicy.manualValidation;
            final activities =
              activitiesAsync.asData?.value ?? const <Activity>[];
          final disciplineNames = activities
              .map((activity) => activity.activityType?.name)
              .whereType<String>()
              .toSet()
              .toList()
            ..sort();
          final groupedActivities = <String, List<Activity>>{};
          for (final activity in activities) {
            final discipline = activity.activityType?.name ?? 'Autres';
            groupedActivities.putIfAbsent(discipline, () => []).add(activity);
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ClubHero(club: club),
              const SizedBox(height: 16),

              // Stats
              statsAsync.maybeWhen(
                data: (stats) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceAround,
                    children: [
                      _StatChip(
                        label: 'Membres',
                        value: stats.membersCount,
                        icon: Icons.people_outline,
                      ),
                      _StatChip(
                        label: 'Activités',
                        value: stats.activitiesCount,
                        icon: Icons.sports_gymnastics,
                      ),
                      _StatChip(
                        label: 'Profs',
                        value: stats.teachersCount,
                        icon: Icons.school_outlined,
                      ),
                    ],
                  ),
                ),
                orElse: () => const SizedBox.shrink(),
              ),
              if (disciplineNames.isNotEmpty) ...[
                Text(
                  'Disciplines principales',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: disciplineNames
                      .map((name) => Chip(label: Text(name)))
                      .toList(),
                ),
                const SizedBox(height: 16),
              ],
              if (_cityCountryLine(club).isNotEmpty) ...[
                _InfoRow(
                  icon: Icons.location_on_outlined,
                  text: _cityCountryLine(club),
                ),
                const SizedBox(height: 8),
              ],
              if (club.email != null && club.email!.isNotEmpty) ...[
                _InfoRow(
                  icon: Icons.email_outlined,
                  text: club.email!,
                ),
                const SizedBox(height: 8),
              ],
              if (club.phone != null && club.phone!.isNotEmpty) ...[
                _InfoRow(
                  icon: Icons.phone_outlined,
                  text: club.phone!,
                ),
                const SizedBox(height: 8),
              ],
              if (club.description != null && club.description!.isNotEmpty) ...[
                Text(
                  'Description',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  club.description!,
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
              ] else
                const SizedBox(height: 24),

              // Cas 1 : déjà membre validé
              if (isMember) ...[
                _Notice(
                  icon: Icons.check_circle_outline,
                  text: 'Vous êtes membre de ce club.',
                  color: theme.colorScheme.primaryContainer,
                  textColor: theme.colorScheme.onPrimaryContainer,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () {
                      unawaited(
                        ref
                            .read(activeClubIdProvider.notifier)
                            .setActiveClub(club.id),
                      );
                      context.go('/home');
                    },
                    icon: const Icon(Icons.home_outlined),
                    label: const Text('Accéder à mon club'),
                  ),
                ),

              // Cas 2 : demande en attente
              ] else if (isPending) ...[
                _Notice(
                  icon: Icons.hourglass_top,
                  text:
                      "Votre demande d'adhésion est en attente de validation.",
                  color: theme.colorScheme.tertiaryContainer,
                  textColor: theme.colorScheme.onTertiaryContainer,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed:
                        _loading ? null : () => _cancelRequest(userClub),
                    icon: _loading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child:
                                CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.close),
                    label: const Text('Annuler ma demande'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: theme.colorScheme.error,
                      side:
                          BorderSide(color: theme.colorScheme.error),
                    ),
                  ),
                ),

              // Cas 3 : club privé, non membre
              ] else if (isPrivate) ...[
                _Notice(
                  icon: Icons.lock_outline,
                  text:
                      'Ce club partage ses informations principales, '
                      'mais le détail des activités reste réservé '
                      'aux membres.',
                  color: theme.colorScheme.surfaceContainerHighest,
                  textColor: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: 16),
                _JoinButton(
                  loading: _loading,
                  onPressed: () => _joinClub(club),
                ),

              // Cas 4 : club public, non membre
              ] else ...[
                if (groupedActivities.isNotEmpty) ...[
                  Text(
                    'Activités par discipline',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  ...groupedActivities.entries.map(
                    (entry) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry.key,
                            style: theme.textTheme.titleSmall,
                          ),
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: entry.value
                                .take(4)
                                .map(
                                  (activity) => Chip(
                                    label: Text(activity.name),
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                _Notice(
                  icon: Icons.lock_open_outlined,
                  text:
                      'Club public — vous pouvez rejoindre immédiatement '
                      'et explorer davantage son contenu.',
                  color: theme.colorScheme.primaryContainer,
                  textColor: theme.colorScheme.onPrimaryContainer,
                ),
                const SizedBox(height: 16),
                _JoinButton(
                  loading: _loading,
                  onPressed: () => _joinClub(club),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

String _cityCountryLine(Club club) {
  final parts = <String>[
    if (club.city != null && club.city!.isNotEmpty) club.city!,
    if (club.country != null && club.country!.isNotEmpty) club.country!,
  ];
  return parts.join(', ');
}

class _JoinButton extends StatelessWidget {
  const _JoinButton({required this.loading, required this.onPressed});

  final bool loading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: loading ? null : onPressed,
        icon: loading
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.group_add_outlined),
        label: Text(loading ? 'Chargement...' : 'Rejoindre ce club'),
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          textStyle: Theme.of(context).textTheme.labelLarge,
        ),
      ),
    );
  }
}

class _Notice extends StatelessWidget {
  const _Notice({
    required this.icon,
    required this.text,
    required this.color,
    required this.textColor,
  });

  final IconData icon;
  final String text;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: textColor),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: textColor,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(icon, size: 18, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
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
          style: theme.textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
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
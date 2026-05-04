import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pole_mobile/core/models/activity.dart';
import 'package:pole_mobile/core/theme/club_theme_provider.dart';
import 'package:pole_mobile/features/activities/providers/club_activities_provider.dart';
import 'package:pole_mobile/features/activities/providers/my_activities_provider.dart';
import 'package:pole_mobile/features/clubs/providers/active_club_provider.dart';
import 'package:pole_mobile/features/home/widgets/activity_card.dart';

class ClubActivitiesGrid extends ConsumerWidget {
  const ClubActivitiesGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeClub = ref.watch(activeUserClubProvider);
    if (activeClub == null) return const SizedBox.shrink();
    final activitiesAsync = ref.watch(
      clubActivitiesProvider(activeClub.club.id),
    );
    final myActivities = ref.watch(myActivitiesProvider).asData?.value ?? [];
    final ct = ref.watch(clubThemeProvider);

    return activitiesAsync.when(
      loading: () => Center(
        child: CircularProgressIndicator(color: ct.primary),
      ),
      error: (e, _) => Center(
        child: Text(
          'Erreur : $e',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: ct.dark,
          ),
        ),
      ),
      data: (activities) {
        if (activities.isEmpty) {
          return Center(
            child: Text(
              'Aucune activité dans ce club',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: ct.dark.withValues(alpha: 0.7),
              ),
            ),
          );
        }
        final groupedEntries = _groupedActivities(activities);
        return Column(
          children: List.generate(groupedEntries.length, (index) {
            final entry = groupedEntries[index];
            return Container(
              margin: EdgeInsets.only(
                bottom: index == groupedEntries.length - 1 ? 0 : 16,
              ),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: ct.subtle,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: ct.border, width: 2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          entry.name,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: ct.dark,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.2,
                              ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      IconButton(
                        tooltip: 'Infos discipline',
                        icon: Icon(
                          Icons.info_outline,
                          color: ct.dark,
                          size: 20,
                        ),
                        onPressed: () => _showDisciplineInfo(
                          context,
                          entry.name,
                          entry.description,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: entry.activities.length,
                    separatorBuilder: (_, index) => const SizedBox(height: 8),
                    itemBuilder: (_, index) {
                      final activity = entry.activities[index];
                      final userActivity = myActivities
                          .where((ua) => ua.activity.id == activity.id)
                          .firstOrNull;
                      return DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: ct.border),
                        ),
                        child: ActivityCard(
                          activity: activity,
                          userActivity: userActivity,
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          }),
        );
      },
    );
  }

  List<_DisciplineGroup> _groupedActivities(List<Activity> activities) {
    final grouped = <String, _DisciplineGroup>{};
    for (final activity in activities) {
      final discipline = activity.activityType?.name ?? 'Autres';
      final group = grouped.putIfAbsent(
        discipline,
        () => _DisciplineGroup(
          name: discipline,
          description: activity.activityType?.description,
          activities: <Activity>[],
        ),
      );
      group.activities.add(activity);
    }
    return grouped.values.toList();
  }

  void _showDisciplineInfo(
    BuildContext context,
    String disciplineName,
    String? description,
  ) {
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        builder: (_) => Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                disciplineName,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              Text(
                (description != null && description.isNotEmpty)
                    ? description
                    : 'Aucune description disponible pour cette discipline.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DisciplineGroup {
  _DisciplineGroup({
    required this.name,
    required this.description,
    required this.activities,
  });

  final String name;
  final String? description;
  final List<Activity> activities;
}

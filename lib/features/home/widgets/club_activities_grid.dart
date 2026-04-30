import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    final activitiesAsync =
        ref.watch(clubActivitiesProvider(activeClub.club.id));
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
        return Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: ct.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: ct.border),
          ),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.1,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: activities.length,
            itemBuilder: (_, index) {
              final activity = activities[index];
              final userActivity = myActivities
                  .where((ua) => ua.activity.id == activity.id)
                  .firstOrNull;
              return ActivityCard(
                activity: activity,
                userActivity: userActivity,
              );
            },
          ),
        );
      },
    );
  }
}
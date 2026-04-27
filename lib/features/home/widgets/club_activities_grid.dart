import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
    final joinedIds = myActivities.map((ua) => ua.activity.id).toSet();
    
    return activitiesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Erreur : $e')),
      data: (activities) {
        if (activities.isEmpty) {
          return Center(
            child: Text(
              'Aucune activité dans ce club',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          );
        }
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: activities.length,
          itemBuilder: (_, index) {
            final activity = activities[index];
            return ActivityCard(
              activity: activity,
              isJoined: joinedIds.contains(activity.id),
              onTap: () => context.push('/activity/${activity.id}'),
            );
          },
        );
      },
    );
  }
}
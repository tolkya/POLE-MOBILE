import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pole_mobile/features/activities/providers/club_activities_provider.dart';
import 'package:pole_mobile/features/activities/providers/my_activities_provider.dart';
import 'package:pole_mobile/features/clubs/providers/active_club_provider.dart';

class MyActivitiesStrip extends ConsumerWidget {
  const MyActivitiesStrip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myActivitiesAsync = ref.watch(myActivitiesProvider);
    final activeClub = ref.watch(activeUserClubProvider);
    final theme = Theme.of(context);

    if (activeClub == null) return const SizedBox.shrink();

    final clubActivityIds = ref
            .watch(clubActivitiesProvider(activeClub.club.id))
            .asData
            ?.value
            .map((a) => a.id)
            .toSet() ??
        {};

    return myActivitiesAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (e, _) => const SizedBox.shrink(),
      data: (activities) {
        final filtered = activities
            .where((ua) => clubActivityIds.contains(ua.activity.id))
            .toList();
        if (filtered.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Mes activités', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            SizedBox(
              height: 80,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: filtered.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(width: 8),
                itemBuilder: (_, index) {
                  final ua = filtered[index];
                  return InkWell(
                    onTap: () =>
                        context.push('/activity/${ua.activity.id}'),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 120,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            ua.activity.name,
                            style: theme.textTheme.labelMedium?.copyWith(
                              color:
                                  theme.colorScheme.onSecondaryContainer,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
          ],
        );
      },
    );
  }
}
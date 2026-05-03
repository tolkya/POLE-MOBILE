import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:pole_mobile/core/models/activity.dart';
import 'package:pole_mobile/core/models/club.dart';
import 'package:pole_mobile/core/models/club_stats.dart';
import 'package:pole_mobile/features/activities/providers/my_activities_provider.dart';
import 'package:pole_mobile/features/club_switcher/club_switcher_sheet.dart';
import 'package:pole_mobile/features/clubs/data/clubs_repository.dart';
import 'package:pole_mobile/features/clubs/providers/active_club_provider.dart';
import 'package:pole_mobile/features/clubs/providers/my_clubs_provider.dart';
import 'package:pole_mobile/features/home/sheets/club_info_sheet.dart';
import 'package:pole_mobile/features/home/widgets/club_activities_grid.dart';
import 'package:pole_mobile/features/home/widgets/club_hero.dart';
import 'package:pole_mobile/features/home/widgets/my_activities_strip.dart';
import 'package:pole_mobile/features/home/widgets/status_banner.dart';

final FutureProviderFamily<ClubStats, int> clubStatsProvider =
    FutureProvider.autoDispose.family<ClubStats, int>((ref, clubId) async {
  return ref.read(clubsRepositoryProvider).getClubStats(clubId);
});

final FutureProviderFamily<List<Activity>, int> clubInfoActivitiesProvider =
    FutureProvider.autoDispose.family<List<Activity>, int>((ref, clubId) async {
  return ref.read(clubsRepositoryProvider).getClubActivities(clubId);
});

final FutureProviderFamily<Club, int> clubInfoProvider =
    FutureProvider.autoDispose.family<Club, int>((ref, clubId) async {
  return ref.read(clubsRepositoryProvider).getClub(clubId);
});

class HomeClubPage extends ConsumerWidget {
  const HomeClubPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userClub = ref.watch(activeUserClubProvider);
    final clubs = ref.watch(myClubsProvider).asData?.value ?? [];
    final hasMultipleClubs = clubs.length > 1;

    if (userClub == null) return const SizedBox.shrink();

    final isPending = userClub.validatedAt == null;
    final clubInfoAsync = ref.watch(clubInfoProvider(userClub.club.id));
    final statsAsync = ref.watch(clubStatsProvider(userClub.club.id));
    final infoActivitiesAsync = ref.watch(
      clubInfoActivitiesProvider(userClub.club.id),
    );
    final fullClub = clubInfoAsync.asData?.value ?? userClub.club;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          ref
            ..invalidate(myClubsProvider)
            ..invalidate(myActivitiesProvider);
          await Future.wait([
            ref.read(myClubsProvider.future),
            ref.read(myActivitiesProvider.future),
          ]);
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverAppBar(
              floating: true,
              snap: true,
              title: GestureDetector(
                onTap: hasMultipleClubs
                    ? () => showModalBottomSheet<void>(
                          context: context,
                          isScrollControlled: true,
                          builder: (_) => const ClubSwitcherSheet(),
                        )
                    : null,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        userClub.club.name,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (hasMultipleClubs) ...[
                      const SizedBox(width: 4),
                      const Icon(Icons.expand_more, size: 20),
                    ],
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClubHero(
                      club: userClub.club,
                      onInfo: () => showModalBottomSheet<void>(
                        context: context,
                        isScrollControlled: true,
                        builder: (_) => ClubInfoSheet(
                          club: fullClub,
                          stats: statsAsync.asData?.value,
                          activities:
                              infoActivitiesAsync.asData?.value ?? const [],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    StatusBanner(userClub: userClub),
                    const SizedBox(height: 24),
                    if (isPending) ...[
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            await ref
                                .read(clubsRepositoryProvider)
                                .cancelJoinRequest(userClub.id);
                            ref
                              ..invalidate(myClubsProvider)
                              ..invalidate(activeClubIdProvider)
                              ..invalidate(myActivitiesProvider);
                          },
                          icon: const Icon(Icons.close),
                          label:
                              const Text("Annuler ma demande d'adhésion"),
                          style: OutlinedButton.styleFrom(
                            foregroundColor:
                                Theme.of(context).colorScheme.error,
                            side: BorderSide(
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                        ),
                      ),
                    ] else ...[
                      const MyActivitiesStrip(),
                      Text(
                        'Toutes les activités',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      const ClubActivitiesGrid(),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

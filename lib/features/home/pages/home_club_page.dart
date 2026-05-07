import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:go_router/go_router.dart';
import 'package:pole_mobile/core/models/activity.dart';
import 'package:pole_mobile/core/models/club.dart';
import 'package:pole_mobile/core/models/club_stats.dart';
import 'package:pole_mobile/core/models/enums.dart';
import 'package:pole_mobile/features/activities/providers/my_activities_provider.dart';
import 'package:pole_mobile/features/club_switcher/club_switcher_sheet.dart';
import 'package:pole_mobile/features/clubs/data/clubs_repository.dart';
import 'package:pole_mobile/features/clubs/pages/pending_club_members_page.dart';
import 'package:pole_mobile/features/clubs/providers/active_club_provider.dart';
import 'package:pole_mobile/features/clubs/providers/my_clubs_provider.dart';
import 'package:pole_mobile/features/home/sheets/club_info_sheet.dart';
import 'package:pole_mobile/features/home/widgets/club_activities_grid.dart';
import 'package:pole_mobile/features/home/widgets/club_hero.dart';
import 'package:pole_mobile/features/home/widgets/my_activities_strip.dart';

final FutureProviderFamily<ClubStats, int> clubStatsProvider = FutureProvider
    .autoDispose
    .family<ClubStats, int>((ref, clubId) async {
      return ref.read(clubsRepositoryProvider).getClubStats(clubId);
    });

final FutureProviderFamily<List<Activity>, int> clubInfoActivitiesProvider =
    FutureProvider.autoDispose.family<List<Activity>, int>((ref, clubId) async {
      return ref.read(clubsRepositoryProvider).getClubActivities(clubId);
    });

final FutureProviderFamily<Club, int> clubInfoProvider = FutureProvider
    .autoDispose
    .family<Club, int>((ref, clubId) async {
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
    final isAdmin = userClub.roles.contains(ClubRole.admin);
    final isManualJoin = fullClub.joinPolicy == JoinPolicy.manualValidation;
    final pendingCountAsync = (isAdmin && isManualJoin)
        ? ref.watch(clubMembersProvider(userClub.club.id))
        : null;
    final pendingCount = pendingCountAsync?.asData?.value
        .where((m) => m.isPending)
        .length ?? 0;

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
                    Badge(
                      isLabelVisible: pendingCount > 0,
                      label: Text('$pendingCount'),
                      child: SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: () => context.push(
                            '/clubs/${userClub.club.id}/pending-members',
                          ),
                          icon: const Icon(Icons.verified_user_outlined),
                          label: const Text('Gérer les demandes du club'),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (isPending) ...[
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            final confirmed = await showDialog<bool>(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Annuler la demande ?'),
                                content: const Text(
                                  "Votre demande d'adhésion "
                                  'à ce club sera annulée.',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(ctx, false),
                                    child: const Text('Non'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(ctx, true),
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.red,
                                    ),
                                    child: const Text('Annuler la demande'),
                                  ),
                                ],
                              ),
                            );
                            if (confirmed != true) return;
                            await ref
                                .read(clubsRepositoryProvider)
                                .cancelJoinRequest(userClub.id);
                            ref
                              ..invalidate(myClubsProvider)
                              ..invalidate(activeClubIdProvider)
                              ..invalidate(myActivitiesProvider);
                          },
                          icon: const Icon(Icons.close),
                          label: const Text("Annuler ma demande d'adhésion"),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Theme.of(
                              context,
                            ).colorScheme.error,
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pole_mobile/features/activities/providers/my_activities_provider.dart';
import 'package:pole_mobile/features/club_switcher/club_switcher_sheet.dart';
import 'package:pole_mobile/features/clubs/providers/active_club_provider.dart';
import 'package:pole_mobile/features/clubs/providers/my_clubs_provider.dart';
import 'package:pole_mobile/features/home/widgets/club_activities_grid.dart';
import 'package:pole_mobile/features/home/widgets/club_hero.dart';
import 'package:pole_mobile/features/home/widgets/my_activities_strip.dart';
import 'package:pole_mobile/features/home/widgets/status_banner.dart';

class HomeClubPage extends ConsumerWidget {
  const HomeClubPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userClub = ref.watch(activeUserClubProvider);
    final clubs = ref.watch(myClubsProvider).asData?.value ?? [];
    final hasMultipleClubs = clubs.length > 1;

    if (userClub == null) return const SizedBox.shrink();

    return Scaffold(
      appBar: AppBar(
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
        child: ListView(
          padding: const EdgeInsets.all(16),
                    children: [
            ClubHero(club: userClub.club),
            const SizedBox(height: 16),
            StatusBanner(userClub: userClub),
            const SizedBox(height: 24),
            const MyActivitiesStrip(),
            Text(
              'Toutes les activités',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            const ClubActivitiesGrid(),
          ],
        ),
      ),
    );
  }
}

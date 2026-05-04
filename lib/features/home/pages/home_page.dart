import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pole_mobile/features/clubs/providers/my_clubs_provider.dart';
import 'package:pole_mobile/features/home/pages/home_club_page.dart';
import 'package:pole_mobile/features/home/pages/home_empty_page.dart';
import 'package:pole_mobile/shared/widgets/skeleton_loader.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clubsAsync = ref.watch(myClubsProvider);

    return clubsAsync.when(
      loading: () => const Scaffold(
        body: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              SkeletonBox(height: 56, borderRadius: 16),
              SizedBox(height: 16),
              SkeletonBox(height: 120, borderRadius: 16),
              SizedBox(height: 16),
              SkeletonBox(height: 20, width: 180),
              SizedBox(height: 12),
              SkeletonBox(height: 96, borderRadius: 16),
              SizedBox(height: 12),
              SkeletonBox(height: 96, borderRadius: 16),
            ],
          ),
        ),
      ),
      error: (e, _) => Scaffold(
        body: Center(child: Text('Erreur : $e')),
      ),
      data: (clubs) =>
          clubs.isEmpty ? const HomeEmptyPage() : const HomeClubPage(),
    );
  }
}

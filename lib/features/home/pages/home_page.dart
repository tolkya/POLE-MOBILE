import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pole_mobile/features/clubs/providers/my_clubs_provider.dart';
import 'package:pole_mobile/features/home/pages/home_club_page.dart';
import 'package:pole_mobile/features/home/pages/home_empty_page.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clubsAsync = ref.watch(myClubsProvider);

    return clubsAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        body: Center(child: Text('Erreur : $e')),
      ),
      data: (clubs) =>
          clubs.isEmpty ? const HomeEmptyPage() : const HomeClubPage(),
    );
  }
}
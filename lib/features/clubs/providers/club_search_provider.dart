import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:pole_mobile/core/models/club.dart';
import 'package:pole_mobile/features/clubs/data/clubs_repository.dart';

/// La query saisie par l'utilisateur.
final clubSearchQueryProvider = StateProvider<String>((ref) => '');

/// Résultats de recherche — se relance quand la query change.
final clubSearchResultsProvider =
    AsyncNotifierProvider<ClubSearchNotifier, List<Club>>(
      ClubSearchNotifier.new,
    );

class ClubSearchNotifier extends AsyncNotifier<List<Club>> {
  @override
  Future<List<Club>> build() async {
    final query = ref.watch(clubSearchQueryProvider);
    if (query.length < 2) return [];

    // Debounce 300ms
    await Future<void>.delayed(const Duration(milliseconds: 300));

    // Si la query a changé pendant le délai → annule
    final currentQuery = ref.read(clubSearchQueryProvider);
    if (currentQuery != query) return state.asData?.value ?? [];

    return ref.read(clubsRepositoryProvider).search(query);
  }
}

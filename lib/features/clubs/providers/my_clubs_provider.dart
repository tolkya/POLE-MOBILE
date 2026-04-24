import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pole_mobile/core/models/user_club.dart';
import 'package:pole_mobile/features/clubs/data/clubs_repository.dart';

final myClubsProvider =
    AsyncNotifierProvider<MyClubsNotifier, List<UserClub>>(
  MyClubsNotifier.new,
);

class MyClubsNotifier extends AsyncNotifier<List<UserClub>> {
  @override
  Future<List<UserClub>> build() =>
      ref.read(clubsRepositoryProvider).getMyClubs();
}
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pole_mobile/core/models/user_club.dart';
import 'package:pole_mobile/core/network/dio_provider.dart';
import 'package:pole_mobile/core/storage/secure_storage.dart';
import 'package:pole_mobile/features/clubs/providers/my_clubs_provider.dart';

/// ID du club actif persisté en storage.
/// null = pas encore choisi ou aucun club.
final activeClubIdProvider =
    AsyncNotifierProvider<ActiveClubIdNotifier, int?>(
  ActiveClubIdNotifier.new,
);

class ActiveClubIdNotifier extends AsyncNotifier<int?> {
  @override
  Future<int?> build() async {
    final storage = ref.read(secureStorageProvider);
    final raw = await storage.read(StorageKeys.activeClubId);
    return raw != null ? int.tryParse(raw) : null;
  }

  Future<void> setActiveClub(int clubId) async {
    final storage = ref.read(secureStorageProvider);
    await storage.write(StorageKeys.activeClubId, clubId.toString());
    state = AsyncData(clubId);
  }

  Future<void> clear() async {
    final storage = ref.read(secureStorageProvider);
    await storage.delete(StorageKeys.activeClubId);
    state = const AsyncData(null);
  }
}

/// Le UserClub actif complet (dérivé de activeClubId + myClubs).
final activeUserClubProvider = Provider<UserClub?>((ref) {
  final clubs = ref.watch(myClubsProvider).asData?.value ?? [];
  final activeId = ref.watch(activeClubIdProvider).asData?.value;

  if (clubs.isEmpty) return null;
  if (activeId == null) return clubs.first;

  return clubs.firstWhere(
    (uc) => uc.club.id == activeId,
    orElse: () => clubs.first,
  );
});
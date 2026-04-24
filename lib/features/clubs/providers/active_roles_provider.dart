import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pole_mobile/core/models/enums.dart';
import 'package:pole_mobile/features/clubs/providers/active_club_provider.dart';

/// Rôles du membre connecté dans le club actif.
final activeRolesProvider = Provider<List<ClubRole>>((ref) {
  return ref.watch(activeUserClubProvider)?.roles ?? [];
});

/// Vrai si le membre est admin du club actif.
final isClubAdminProvider = Provider<bool>((ref) {
  return ref.watch(activeRolesProvider).contains(ClubRole.admin);
});

/// Vrai si le membre est teacher du club actif.
final isClubTeacherProvider = Provider<bool>((ref) {
  return ref.watch(activeRolesProvider).contains(ClubRole.teacher);
});
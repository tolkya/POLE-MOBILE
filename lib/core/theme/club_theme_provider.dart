import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pole_mobile/core/theme/club_theme.dart';
import 'package:pole_mobile/features/clubs/providers/active_club_provider.dart';

final clubThemeProvider = Provider<ClubTheme>((ref) {
  final userClub = ref.watch(activeUserClubProvider);
  return ClubTheme.fromHex(userClub?.club.themeColor);
});

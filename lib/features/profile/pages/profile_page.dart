import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pole_mobile/features/auth/data/auth_repository.dart';
import 'package:pole_mobile/features/auth/providers/session_provider.dart';
import 'package:pole_mobile/features/clubs/providers/active_club_provider.dart';
import 'package:pole_mobile/features/clubs/providers/my_clubs_provider.dart';
import 'package:pole_mobile/features/profile/providers/me_provider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final meAsync = ref.watch(meProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: meAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erreur : $e')),
        data: (user) => ListView(
          padding: const EdgeInsets.all(24),
          children: [
            ListTile(
              leading: const Icon(Icons.person),
              title: Text('${user.firstName} ${user.lastName}'),
              subtitle: Text(user.email),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                'Se déconnecter',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () => _logout(ref, context),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _logout(WidgetRef ref, BuildContext context) async {
    await ref.read(authRepositoryProvider).logout();
    ref.read(tokenProvider.notifier).clearToken();
      ref
        ..invalidate(meProvider)
        ..invalidate(myClubsProvider)
        ..invalidate(activeClubIdProvider);
    if (context.mounted) context.go('/auth');
  }
}
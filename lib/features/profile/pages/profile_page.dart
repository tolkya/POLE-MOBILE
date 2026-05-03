import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pole_mobile/core/models/user_club.dart';
import 'package:pole_mobile/features/activities/providers/my_activities_provider.dart';
import 'package:pole_mobile/features/auth/data/auth_repository.dart';
import 'package:pole_mobile/features/auth/providers/session_provider.dart';
import 'package:pole_mobile/features/clubs/data/clubs_repository.dart';
import 'package:pole_mobile/features/clubs/providers/active_club_provider.dart';
import 'package:pole_mobile/features/clubs/providers/my_clubs_provider.dart';
import 'package:pole_mobile/features/profile/pages/change_password_page.dart';
import 'package:pole_mobile/features/profile/pages/edit_profile_page.dart';
import 'package:pole_mobile/features/profile/providers/me_provider.dart';
import 'package:pole_mobile/features/profile/providers/theme_mode_provider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final meAsync = ref.watch(meProvider);
    final clubs = ref.watch(myClubsProvider).asData?.value ?? [];
    final isDark = ref.watch(themeModeProvider) == ThemeMode.dark;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: meAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erreur : $e')),
        data: (user) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Avatar + nom
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 36,
                    child: Text(
                      user.firstName.substring(0, 1).toUpperCase(),
                      style: theme.textTheme.headlineMedium,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${user.firstName} ${user.lastName}',
                    style: theme.textTheme.titleLarge,
                  ),
                  Text(
                    user.email,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Mes clubs
            if (clubs.isNotEmpty) ...[
              Text(
                'Mes clubs',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              ...clubs.map(
                (uc) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.groups_outlined),
                  title: Text(uc.club.name),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...uc.roles.map(
                        (r) => Chip(
                          label: Text(
                            r.name.toUpperCase(),
                            style: theme.textTheme.labelSmall,
                          ),
                          padding: EdgeInsets.zero,
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.exit_to_app,
                          color: Colors.red,
                        ),
                        tooltip: 'Quitter ce club',
                        onPressed: () =>
                            _confirmLeave(ref, context, uc),
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(),
            ],

            // Actions
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.edit_outlined),
              title: const Text('Modifier le profil'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const EditProfilePage(),
                ),
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.lock_outline),
              title: const Text('Changer le mot de passe'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const ChangePasswordPage(),
                ),
              ),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              secondary: const Icon(Icons.dark_mode_outlined),
              title: const Text('Mode sombre'),
              value: isDark,
              onChanged: (v) => ref
                  .read(themeModeProvider.notifier)
                  .setMode(v ? ThemeMode.dark : ThemeMode.light),
            ),

            const Divider(),

            ListTile(
              contentPadding: EdgeInsets.zero,
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

  Future<void> _confirmLeave(
    WidgetRef ref,
    BuildContext context,
    UserClub uc,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Quitter ce club ?'),
        content: Text(
          'Voulez-vous vraiment quitter "${uc.club.name}" ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Quitter'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    if (!context.mounted) return;
    await ref.read(clubsRepositoryProvider).leaveClub(uc.id);
    ref
      ..invalidate(myClubsProvider)
      ..invalidate(activeClubIdProvider)
      ..invalidate(myActivitiesProvider);
  }

  Future<void> _logout(WidgetRef ref, BuildContext context) async {
    await ref.read(authRepositoryProvider).logout();
    ref.read(tokenProvider.notifier).clearToken();
    ref
      ..invalidate(meProvider)
      ..invalidate(myClubsProvider)
      ..invalidate(activeClubIdProvider)
      ..invalidate(myActivitiesProvider);
    if (context.mounted) context.go('/auth');
  }
}
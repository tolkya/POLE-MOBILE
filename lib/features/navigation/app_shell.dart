import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_theme.dart';
import '../../core/models/club_model.dart';
import '../../core/models/user_model.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/providers/clubs_provider.dart';
import '../home/home_screen.dart';
import '../profile/profile_screen.dart';

class AppShell extends ConsumerStatefulWidget {
  const AppShell({
    super.key,
    required this.user,
  });

  final UserModel user;

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  int _index = 0;

  final _createClubCtrl = TextEditingController();
  final _joinCodeCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(clubsControllerProvider.notifier).loadMyClubs());
  }

  @override
  void dispose() {
    _createClubCtrl.dispose();
    _joinCodeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final clubsState = ref.watch(clubsControllerProvider);

    final pages = <Widget>[
      HomeTab(user: widget.user),
      _CreateClubTab(
        controller: _createClubCtrl,
        isLoading: clubsState.isLoading,
        onCreate: () => ref.read(clubsControllerProvider.notifier).createClub(_createClubCtrl.text),
      ),
      _ClubsTab(
        state: clubsState,
        onRefresh: () => ref.read(clubsControllerProvider.notifier).loadMyClubs(),
      ),
      _JoinClubTab(
        controller: _joinCodeCtrl,
        isLoading: clubsState.isLoading,
        onJoin: () => ref.read(clubsControllerProvider.notifier).joinClubByCode(_joinCodeCtrl.text),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _titleForIndex(_index),
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: [
          PopupMenuButton<_SettingsAction>(
            tooltip: 'Parametres',
            icon: const Icon(Icons.settings_outlined),
            onSelected: (action) {
              if (action == _SettingsAction.profile) {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => ProfileScreen(user: widget.user),
                  ),
                );
                return;
              }

              ref.read(authControllerProvider.notifier).logout();
            },
            itemBuilder: (context) => const [
              PopupMenuItem<_SettingsAction>(
                value: _SettingsAction.profile,
                child: Row(
                  children: [
                    Icon(Icons.person_outline, size: 20),
                    SizedBox(width: 10),
                    Text('Profil'),
                  ],
                ),
              ),
              PopupMenuItem<_SettingsAction>(
                value: _SettingsAction.logout,
                child: Row(
                  children: [
                    Icon(Icons.logout, size: 20),
                    SizedBox(width: 10),
                    Text('Logout'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF8F7F4), Color(0xFFF2F5FB)],
          ),
        ),
        child: SafeArea(child: pages[_index]),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        indicatorColor: const Color(0xFFEDE9FE),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Accueil'),
          NavigationDestination(icon: Icon(Icons.add_circle_outline), selectedIcon: Icon(Icons.add_circle), label: 'Creer'),
          NavigationDestination(icon: Icon(Icons.apartment_outlined), selectedIcon: Icon(Icons.apartment), label: 'Clubs'),
          NavigationDestination(icon: Icon(Icons.group_add_outlined), selectedIcon: Icon(Icons.group_add), label: 'Rejoindre'),
        ],
      ),
    );
  }

  String _titleForIndex(int index) {
    return switch (index) {
      0 => 'Espace Sparklib',
      1 => 'Creer un club',
      2 => 'Mes clubs',
      3 => 'Rejoindre un club',
      _ => 'Espace Sparklib',
    };
  }
}

enum _SettingsAction {
  profile,
  logout,
}

class _CreateClubTab extends StatelessWidget {
  const _CreateClubTab({
    required this.controller,
    required this.isLoading,
    required this.onCreate,
  });

  final TextEditingController controller;
  final bool isLoading;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 18),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Lancez votre nouveau club',
                  style: TextStyle(
                    color: AppTheme.text,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Donnez un nom clair a votre structure. Vous pourrez completer les details ensuite.',
                  style: TextStyle(color: AppTheme.textMuted, height: 1.4),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: controller,
                  decoration: const InputDecoration(labelText: 'Nom du club'),
                ),
                const SizedBox(height: 14),
                ElevatedButton(
                  onPressed: isLoading ? null : onCreate,
                  child: Text(isLoading ? 'Creation...' : 'Creer le club'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _JoinClubTab extends StatelessWidget {
  const _JoinClubTab({
    required this.controller,
    required this.isLoading,
    required this.onJoin,
  });

  final TextEditingController controller;
  final bool isLoading;
  final VoidCallback onJoin;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 18),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Rejoindre un club',
                  style: TextStyle(
                    color: AppTheme.text,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Entrez votre code invitation (ex: cde_15).',
                  style: TextStyle(color: AppTheme.textMuted, height: 1.4),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: controller,
                  decoration: const InputDecoration(labelText: 'Code club'),
                ),
                const SizedBox(height: 14),
                ElevatedButton(
                  onPressed: isLoading ? null : onJoin,
                  child: Text(isLoading ? 'Inscription...' : 'Rejoindre ce club'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ClubsTab extends StatelessWidget {
  const _ClubsTab({
    required this.state,
    required this.onRefresh,
  });

  final ClubsState state;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    if (state.isLoading && state.clubs.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: AppTheme.primary),
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 18),
      children: [
        if (state.error != null)
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFFEE2E2),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFFCA5A5)),
            ),
            child: Text(
              state.error!,
              style: const TextStyle(color: AppTheme.error),
            ),
          ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Synchroniser vos clubs',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                TextButton(onPressed: onRefresh, child: const Text('Rafraichir')),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        if (state.clubs.isEmpty)
          const _EmptyClubsView()
        else if (state.clubs.length == 1)
          _SingleClubView(club: state.clubs.first)
        else
          _MultipleClubsView(state: state),
      ],
    );
  }
}

class _EmptyClubsView extends StatelessWidget {
  const _EmptyClubsView();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Aucun club pour le moment',
              style: TextStyle(
                color: AppTheme.text,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Utilisez les onglets Creer ou Rejoindre pour constituer votre espace clubs.',
              style: TextStyle(color: AppTheme.textMuted, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}

class _SingleClubView extends StatelessWidget {
  const _SingleClubView({required this.club});

  final UserClubModel club;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Votre club principal',
              style: TextStyle(
                color: AppTheme.text,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10),
            Text(club.clubName, style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text('Code: ${club.clubCode}', style: const TextStyle(color: AppTheme.textMuted)),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: null,
              child: const Text('Ouverture club (etape suivante)'),
            ),
          ],
        ),
      ),
    );
  }
}

class _MultipleClubsView extends StatelessWidget {
  const _MultipleClubsView({required this.state});

  final ClubsState state;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: state.clubs
          .map(
            (club) => Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(999),
                        color: _colorFromHex(club.themeColor),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(club.clubName, style: const TextStyle(fontWeight: FontWeight.w700)),
                          const SizedBox(height: 4),
                          Text('Code: ${club.clubCode}', style: const TextStyle(color: AppTheme.textMuted)),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: AppTheme.textMuted),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  static Color _colorFromHex(String? hex) {
    if (hex == null || hex.isEmpty) {
      return AppTheme.primary;
    }

    final safe = hex.replaceFirst('#', '');
    if (safe.length != 6) {
      return AppTheme.primary;
    }

    final value = int.tryParse('FF$safe', radix: 16);
    if (value == null) {
      return AppTheme.primary;
    }

    return Color(value);
  }
}


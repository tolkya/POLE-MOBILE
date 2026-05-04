import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pole_mobile/core/models/user_club.dart';
import 'package:pole_mobile/features/clubs/providers/club_search_provider.dart';
import 'package:pole_mobile/features/clubs/providers/my_clubs_provider.dart';
import 'package:pole_mobile/features/discover/sheets/join_by_code_sheet.dart';
import 'package:pole_mobile/shared/widgets/empty_state.dart';
import 'package:pole_mobile/shared/widgets/error_view.dart';
import 'package:pole_mobile/shared/widgets/skeleton_loader.dart';

class DiscoverPage extends ConsumerStatefulWidget {
  const DiscoverPage({super.key});

  @override
  ConsumerState<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends ConsumerState<DiscoverPage> {
  final _searchCtrl = SearchController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final query = ref.watch(clubSearchQueryProvider);
    final resultsAsync = ref.watch(clubSearchResultsProvider);
    final myClubs = ref.watch(myClubsProvider).asData?.value ?? [];

    return Scaffold(
      appBar: AppBar(title: const Text('Découvrir')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: SearchBar(
              controller: _searchCtrl,
              hintText: 'Rechercher un club...',
              leading: const Icon(Icons.search),
              trailing: [
                if (query.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      _searchCtrl.clear();
                      ref.read(clubSearchQueryProvider.notifier).state = '';
                    },
                  ),
              ],
              onChanged: (value) {
                ref.read(clubSearchQueryProvider.notifier).state = value;
              },
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: query.length < 2
                ? _DefaultContent(
                    myClubs: myClubs,
                    theme: theme,
                    onJoinByCode: () => showModalBottomSheet<void>(
                      context: context,
                      isScrollControlled: true,
                      builder: (_) => const JoinByCodeSheet(),
                    ),
                  )
                : resultsAsync.when(
                    loading: () => ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      itemCount: 6,
                      itemBuilder: (context, index) => const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            SkeletonBox(
                              width: 40,
                              height: 40,
                              borderRadius: 20,
                            ),
                            SizedBox(width: 12),
                            Expanded(child: SkeletonBox(height: 16)),
                            SizedBox(width: 12),
                            SkeletonBox(width: 16, height: 16, borderRadius: 4),
                          ],
                        ),
                      ),
                    ),
                    error: (e, _) => ErrorView(
                      message: 'Impossible de charger les résultats.',
                      onRetry: () => ref.invalidate(clubSearchResultsProvider),
                    ),
                    data: (clubs) => clubs.isEmpty
                        ? EmptyState(
                            message: 'Aucun club trouvé pour "$query".',
                            icon: Icons.search_off_outlined,
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                            itemCount: clubs.length,
                            itemBuilder: (_, index) {
                              final club = clubs[index];
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor:
                                      theme.colorScheme.primaryContainer,
                                  child: Text(
                                    club.name.substring(0, 1).toUpperCase(),
                                    style: TextStyle(
                                      color:
                                          theme.colorScheme.onPrimaryContainer,
                                    ),
                                  ),
                                ),
                                title: Text(club.name),
                                trailing: const Icon(Icons.chevron_right),
                                onTap: () => context.push('/clubs/${club.id}'),
                              );
                            },
                          ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _DefaultContent extends StatelessWidget {
  const _DefaultContent({
    required this.myClubs,
    required this.theme,
    required this.onJoinByCode,
  });

  final List<UserClub> myClubs;
  final ThemeData theme;
  final VoidCallback onJoinByCode;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        FilledButton.tonalIcon(
          onPressed: onJoinByCode,
          icon: const Icon(Icons.vpn_key_outlined),
          label: const Text('Rejoindre avec un code'),
        ),
        if (myClubs.isNotEmpty) ...[
          const SizedBox(height: 24),
          Text('Mes clubs', style: theme.textTheme.titleSmall),
          const SizedBox(height: 8),
          ...myClubs.map(
            (uc) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                backgroundColor: theme.colorScheme.primaryContainer,
                child: Text(
                  uc.club.name.substring(0, 1).toUpperCase(),
                  style: TextStyle(
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
              title: Text(uc.club.name),
            ),
          ),
        ],
      ],
    );
  }
}

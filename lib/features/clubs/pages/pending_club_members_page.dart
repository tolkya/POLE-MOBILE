import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:pole_mobile/core/models/club_member.dart';
import 'package:pole_mobile/features/clubs/data/clubs_repository.dart';
import 'package:pole_mobile/shared/widgets/empty_state.dart';
import 'package:pole_mobile/shared/widgets/error_view.dart';

final FutureProviderFamily<List<ClubMember>, int> clubMembersProvider =
    FutureProvider.autoDispose.family<List<ClubMember>, int>(
  (ref, clubId) => ref.read(clubsRepositoryProvider).getClubMembers(clubId),
);

class PendingClubMembersPage extends ConsumerWidget {
  const PendingClubMembersPage({
    required this.clubId,
    super.key,
  });

  final int clubId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final membersAsync = ref.watch(clubMembersProvider(clubId));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Demandes d'adhésion"),
      ),
      body: membersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => ErrorView(
          message: 'Impossible de charger les demandes du club.',
          onRetry: () => ref.invalidate(clubMembersProvider(clubId)),
        ),
        data: (members) {
          final pending = members.where((m) => m.isPending).toList();

          if (pending.isEmpty) {
            return const EmptyState(
              message: 'Aucune demande en attente.',
              icon: Icons.how_to_reg_outlined,
            );
          }

          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(clubMembersProvider(clubId)),
            child: ListView.separated(
              itemCount: pending.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final member = pending[index];

                return Dismissible(
                  key: ValueKey(member.id),
                  background: const _SwipeBackground(
                    color: Colors.green,
                    icon: Icons.check,
                    alignment: Alignment.centerLeft,
                  ),
                  secondaryBackground: const _SwipeBackground(
                    color: Colors.red,
                    icon: Icons.close,
                    alignment: Alignment.centerRight,
                  ),
                  confirmDismiss: (direction) async {
                    if (direction == DismissDirection.startToEnd) {
                      await ref
                          .read(clubsRepositoryProvider)
                          .validateClubMember(member.id);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Membre validé.'),
                          ),
                        );
                      }
                    } else {
                      await ref
                          .read(clubsRepositoryProvider)
                          .rejectClubMember(member.id);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Demande refusée.'),
                          ),
                        );
                      }
                    }

                    ref.invalidate(clubMembersProvider(clubId));
                    return false;
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(
                        member.member.firstName.substring(0, 1).toUpperCase(),
                      ),
                    ),
                    title: Text(
                      '${member.member.firstName} ${member.member.lastName}',
                    ),
                    subtitle: Text(member.member.email),
                    trailing: Wrap(
                      spacing: 4,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.check_circle_outline,
                            color: Colors.green,
                          ),
                          tooltip: 'Valider',
                          onPressed: () async {
                            await ref
                                .read(clubsRepositoryProvider)
                                .validateClubMember(member.id);
                            ref.invalidate(clubMembersProvider(clubId));
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Membre validé.')),
                              );
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.cancel_outlined,
                            color: Colors.red,
                          ),
                          tooltip: 'Refuser',
                          onPressed: () async {
                            final confirmed = await showDialog<bool>(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Refuser la demande ?'),
                                content: Text(
                                  'La demande de '
                                  '${member.member.firstName} '
                                  '${member.member.lastName} '
                                  'sera définitivement refusée.',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(ctx, false),
                                    child: const Text('Non'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(ctx, true),
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.red,
                                    ),
                                    child: const Text('Refuser'),
                                  ),
                                ],
                              ),
                            );
                            if (confirmed != true) return;
                            await ref
                                .read(clubsRepositoryProvider)
                                .rejectClubMember(member.id);
                            ref.invalidate(clubMembersProvider(clubId));
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Demande refusée.'),
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _SwipeBackground extends StatelessWidget {
  const _SwipeBackground({
    required this.color,
    required this.icon,
    required this.alignment,
  });

  final Color color;
  final IconData icon;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: color,
      child: Align(
        alignment: alignment,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Icon(icon, color: Colors.white),
        ),
      ),
    );
  }
}

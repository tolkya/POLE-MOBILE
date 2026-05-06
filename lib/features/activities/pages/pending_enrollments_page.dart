import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:pole_mobile/core/models/enums.dart';
import 'package:pole_mobile/core/models/user_activity.dart';
import 'package:pole_mobile/features/activities/data/activities_repository.dart';
import 'package:pole_mobile/features/activities/providers/my_activities_provider.dart';
import 'package:pole_mobile/shared/widgets/empty_state.dart';
import 'package:pole_mobile/shared/widgets/error_view.dart';

final FutureProviderFamily<List<UserActivity>, int> activityMembersProvider =
    FutureProvider.autoDispose.family<List<UserActivity>, int>(
  (ref, activityId) =>
      ref.read(activitiesRepositoryProvider).getActivityMembers(activityId),
);

class PendingEnrollmentsPage extends ConsumerWidget {
  const PendingEnrollmentsPage({
    required this.activityId,
    required this.isAdmin,
    super.key,
  });

  final int activityId;
  final bool isAdmin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final membersAsync = ref.watch(activityMembersProvider(activityId));

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Gestion des inscriptions'),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(56),
            child: membersAsync.when(
              loading: () => const TabBar(
                tabs: [
                  Tab(text: 'En attente'),
                  Tab(text: 'Inscrits'),
                ],
              ),
              error: (e, _) => const TabBar(
                tabs: [
                  Tab(text: 'En attente'),
                  Tab(text: 'Inscrits'),
                ],
              ),
              data: (members) {
                final pending = members
                    .where((m) => m.status == UserActivityStatus.pending)
                    .toList();
                final approved = members
                    .where((m) => m.status == UserActivityStatus.approved)
                    .toList();

                return TabBar(
                  tabs: [
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('En attente'),
                          if (pending.isNotEmpty) ...[
                            const SizedBox(width: 8),
                            Badge(label: Text(pending.length.toString())),
                          ],
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Inscrits'),
                          if (approved.isNotEmpty) ...[
                            const SizedBox(width: 8),
                            Badge(label: Text(approved.length.toString())),
                          ],
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        body: membersAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => ErrorView(
            message: 'Impossible de charger les inscriptions.',
            onRetry: () => ref.invalidate(activityMembersProvider(activityId)),
          ),
          data: (members) {
            final pending = members
                .where((m) => m.status == UserActivityStatus.pending)
                .toList();

            final teachers = members
                .where(
                  (m) =>
                      m.status == UserActivityStatus.approved &&
                      m.role == ActivityRole.teacher,
                )
                .toList();

            final students = members
                .where(
                  (m) =>
                      m.status == UserActivityStatus.approved &&
                      m.role == ActivityRole.student,
                )
                .toList();

            return TabBarView(
              children: [
                _PendingTab(
                  activityId: activityId,
                  pending: pending,
                ),
                _ApprovedTab(
                  activityId: activityId,
                  teachers: teachers,
                  students: students,
                  isAdmin: isAdmin,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _PendingTab extends ConsumerWidget {
  const _PendingTab({
    required this.activityId,
    required this.pending,
  });

  final int activityId;
  final List<UserActivity> pending;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (pending.isEmpty) {
      return const EmptyState(
        message: 'Aucune inscription en attente.',
        icon: Icons.how_to_reg_outlined,
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(activityMembersProvider(activityId));
      },
      child: ListView.separated(
        itemCount: pending.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final ua = pending[index];
          return Dismissible(
            key: ValueKey(ua.id),
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
              final status = direction == DismissDirection.startToEnd
                  ? 'APPROVED'
                  : 'REJECTED';

              await ref
                  .read(activitiesRepositoryProvider)
                  .updateEnrollmentStatus(ua.id, status);

              ref
                ..invalidate(activityMembersProvider(activityId))
                ..invalidate(myActivitiesProvider);

              return false;
            },
            child: ListTile(
              leading: CircleAvatar(
                child: Text(
                  ua.member.firstName.substring(0, 1).toUpperCase(),
                ),
              ),
              title: Text('${ua.member.firstName} ${ua.member.lastName}'),
              subtitle: Text(ua.member.email),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.check_circle_outline,
                      color: Colors.green,
                    ),
                    tooltip: 'Approuver',
                    onPressed: () async {
                      await ref
                          .read(activitiesRepositoryProvider)
                          .updateEnrollmentStatus(ua.id, 'APPROVED');

                      ref
                        ..invalidate(activityMembersProvider(activityId))
                        ..invalidate(myActivitiesProvider);
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.cancel_outlined,
                      color: Colors.red,
                    ),
                    tooltip: 'Rejeter',
                    onPressed: () async {
                      await ref
                          .read(activitiesRepositoryProvider)
                          .updateEnrollmentStatus(ua.id, 'REJECTED');

                      ref
                        ..invalidate(activityMembersProvider(activityId))
                        ..invalidate(myActivitiesProvider);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ApprovedTab extends ConsumerWidget {
  const _ApprovedTab({
    required this.activityId,
    required this.teachers,
    required this.students,
    required this.isAdmin,
  });

  final int activityId;
  final List<UserActivity> teachers;
  final List<UserActivity> students;
  final bool isAdmin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (teachers.isEmpty && students.isEmpty) {
      return const EmptyState(
        message: 'Aucun membre inscrit.',
        icon: Icons.groups_outlined,
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(activityMembersProvider(activityId));
      },
      child: ListView(
        children: [
          if (teachers.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                'Professeurs',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            ...teachers.map(
              (ua) => ListTile(
                leading: CircleAvatar(
                  child: Text(
                    ua.member.firstName.substring(0, 1).toUpperCase(),
                  ),
                ),
                title: Text('${ua.member.firstName} ${ua.member.lastName}'),
                subtitle: const Text('Professeur'),
                trailing: isAdmin
                    ? IconButton(
                        icon: const Icon(
                          Icons.person_remove_outlined,
                          color: Colors.red,
                        ),
                        tooltip: 'Retirer ce professeur',
                        onPressed: () async {
                          await ref
                              .read(activitiesRepositoryProvider)
                              .deleteMembership(ua.id);

                          ref
                            ..invalidate(activityMembersProvider(activityId))
                            ..invalidate(myActivitiesProvider);
                        },
                      )
                    : null,
              ),
            ),
          ],
          if (students.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                'Élèves',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            ...students.map(
              (ua) => ListTile(
                leading: CircleAvatar(
                  child: Text(
                    ua.member.firstName.substring(0, 1).toUpperCase(),
                  ),
                ),
                title: Text('${ua.member.firstName} ${ua.member.lastName}'),
                subtitle: const Text('Élève'),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.person_remove_outlined,
                    color: Colors.red,
                  ),
                  tooltip: 'Retirer cet élève',
                  onPressed: () async {
                    await ref
                        .read(activitiesRepositoryProvider)
                        .deleteMembership(ua.id);

                    ref
                      ..invalidate(activityMembersProvider(activityId))
                      ..invalidate(myActivitiesProvider);
                  },
                ),
              ),
            ),
          ],
        ],
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
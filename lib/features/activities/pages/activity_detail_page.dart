import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pole_mobile/core/models/enums.dart';
import 'package:pole_mobile/core/models/user_activity.dart';
import 'package:pole_mobile/core/theme/club_theme_provider.dart';
import 'package:pole_mobile/features/activities/data/activities_repository.dart';
import 'package:pole_mobile/features/activities/providers/club_activities_provider.dart';
import 'package:pole_mobile/features/activities/providers/my_activities_provider.dart';
import 'package:pole_mobile/features/activities/widgets/level_accordion.dart';
import 'package:pole_mobile/features/clubs/providers/active_club_provider.dart';

class ActivityDetailPage extends ConsumerWidget {
  const ActivityDetailPage({required this.activityId, super.key});
  

  final int activityId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeClub = ref.watch(activeUserClubProvider);
    final ct = ref.watch(clubThemeProvider);
    final myActivities = ref.watch(myActivitiesProvider).asData?.value ?? [];

    final userActivity = myActivities
        .where((ua) => ua.activity.id == activityId)
        .firstOrNull;
    
    final isApprovedMember =
      userActivity?.status == UserActivityStatus.approved;

    final activitiesAsync = activeClub != null
        ? ref.watch(clubActivitiesProvider(activeClub.club.id))
        : null;

    final activity = activitiesAsync?.asData?.value
        .where((a) => a.id == activityId)
        .firstOrNull;

    return Scaffold(
      appBar: AppBar(
        title: Text(activity?.name ?? 'Activité'),
        backgroundColor: ct.primary,
        foregroundColor: ct.onPrimary,
        iconTheme: IconThemeData(color: ct.onPrimary),
      ),
      body: !isApprovedMember
          ? Center(
              child: Text(
                "Accès réservé aux membres validés de l'activité.",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: ct.dark,
                ),
                textAlign: TextAlign.center,
              ),
            )
          : activity == null
              ? Center(child: CircularProgressIndicator(color: ct.primary))
              : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  if (activity.description != null &&
                      activity.description!.isNotEmpty) ...[
                    Text(
                      activity.description!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 24),
                  ],
                  _JoinLeaveButton(
                    activityId: activityId,
                    userActivity: userActivity,
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Niveaux & skills',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: ct.dark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  LevelAccordion(activityId: activityId),
                ],

              ),
    );
  }
}

class _JoinLeaveButton extends ConsumerStatefulWidget {
  const _JoinLeaveButton({
    required this.activityId,
    required this.userActivity,
  });

  final int activityId;
  final UserActivity? userActivity;

  @override
  ConsumerState<_JoinLeaveButton> createState() => _JoinLeaveButtonState();
}

class _JoinLeaveButtonState extends ConsumerState<_JoinLeaveButton> {
  bool _loading = false;

  Future<void> _join() async {
    setState(() => _loading = true);
    try {
      await ref
          .read(activitiesRepositoryProvider)
          .joinActivity(widget.activityId);
      ref.invalidate(myActivitiesProvider);
    } on Exception catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _leave() async {
    setState(() => _loading = true);
    try {
      await ref
          .read(activitiesRepositoryProvider)
          .leaveActivity(widget.userActivity!.id);
      ref.invalidate(myActivitiesProvider);
      if (mounted) context.go('/home');
    } on Exception catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isJoined =
      widget.userActivity?.status == UserActivityStatus.approved;
    final ct = ref.watch(clubThemeProvider);

    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (isJoined) {
      return OutlinedButton.icon(
        onPressed: _leave,
        icon: const Icon(Icons.exit_to_app),
        label: const Text('Quitter cette activité'),
        style: OutlinedButton.styleFrom(
          foregroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }

    return FilledButton.icon(
      onPressed: _join,
      icon: const Icon(Icons.add),
      label: const Text("S'inscrire"),
      style: FilledButton.styleFrom(
        backgroundColor: ct.primary,
        foregroundColor: ct.onPrimary,
      ),
    );
  }
}
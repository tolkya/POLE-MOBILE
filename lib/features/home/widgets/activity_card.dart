import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pole_mobile/core/models/activity.dart';
import 'package:pole_mobile/core/models/enums.dart';
import 'package:pole_mobile/core/models/user_activity.dart';
import 'package:pole_mobile/core/theme/club_theme_provider.dart';
import 'package:pole_mobile/features/activities/data/activities_repository.dart';
import 'package:pole_mobile/features/activities/providers/my_activities_provider.dart';

class ActivityCard extends ConsumerStatefulWidget {
  const ActivityCard({
    required this.activity,
    this.userActivity,
    super.key,
  });

  final Activity activity;
  final UserActivity? userActivity;

  @override
  ConsumerState<ActivityCard> createState() => _ActivityCardState();
}

class _ActivityCardState extends ConsumerState<ActivityCard> {
  bool _loading = false;

  UserActivityStatus? get _status => widget.userActivity?.status;
  bool get _isApproved => _status == UserActivityStatus.approved;
  bool get _isPending => _status == UserActivityStatus.pending;
  bool get _isRejected => _status == UserActivityStatus.rejected;
  bool get _isLeft => _status == UserActivityStatus.left;
  bool get _isNotJoined =>
      widget.userActivity == null || _isRejected || _isLeft;

  Future<void> _join() async {
    setState(() => _loading = true);
    try {
      await ref
          .read(activitiesRepositoryProvider)
          .joinActivity(widget.activity.id);
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

  Future<void> _cancelRequest() async {
    setState(() => _loading = true);
    try {
      await ref
          .read(activitiesRepositoryProvider)
          .cancelRequest(widget.userActivity!.id);
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

  Future<void> _reRequest() async {
    setState(() => _loading = true);
    try {
      await ref
          .read(activitiesRepositoryProvider)
          .reRequestActivity(widget.userActivity!.id);
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

  void _onTap() {
    if (_isApproved) {
      unawaited(context.push('/activity/${widget.activity.id}'));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ct = ref.watch(clubThemeProvider);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: _isApproved ? _onTap : null,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: ct.subtle,
                    child: Text(
                      widget.activity.name
                          .substring(0, 1)
                          .toUpperCase(),
                      style: TextStyle(
                        color: ct.dark,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.activity.name,
                      style: theme.textTheme.titleSmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (_isApproved)
                _StatusBadge(
                  label: 'Inscrit',
                  color: ct.subtle,
                  textColor: ct.dark,
                )
              else if (_isPending)
                _StatusBadge(
                  label: 'En attente',
                  color: ct.subtle,
                  textColor: ct.dark.withValues(alpha: 0.6),
                )
              else if (_isRejected)
                _StatusBadge(
                  label: 'Refusé',
                  color: theme.colorScheme.errorContainer,
                  textColor: theme.colorScheme.onErrorContainer,
                ),
              const Spacer(),
              if (_loading)
                const Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              else if (_isNotJoined)
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: (_isRejected || _isLeft) ? _reRequest : _join,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      textStyle: theme.textTheme.labelSmall,
                      backgroundColor: ct.primary,
                      foregroundColor: ct.onPrimary,
                      disabledBackgroundColor: ct.subtle,
                      disabledForegroundColor: ct.dark.withValues(alpha: 0.6),
                    ),
                    child: const Text("S'inscrire"),
                  ),
                )
              else if (_isPending)
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: _cancelRequest,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      textStyle: theme.textTheme.labelSmall,
                      foregroundColor: ct.dark,
                      side: BorderSide(color: ct.border),
                      backgroundColor: ct.subtle.withValues(alpha: 0.05),
                    ),
                    child: const Text('Annuler'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({
    required this.label,
    required this.color,
    required this.textColor,
  });

  final String label;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: textColor,
            ),
      ),
    );
  }
}
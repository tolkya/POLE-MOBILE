import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pole_mobile/core/models/level.dart';
import 'package:pole_mobile/core/models/skill.dart';
import 'package:pole_mobile/core/models/skill_media_tuto.dart';
import 'package:pole_mobile/core/network/media_url.dart';
import 'package:pole_mobile/core/theme/club_theme_provider.dart';
import 'package:pole_mobile/features/activities/data/activities_repository.dart';
import 'package:pole_mobile/features/activities/providers/levels_provider.dart';
import 'package:pole_mobile/features/activities/providers/skills_provider.dart';
import 'package:pole_mobile/features/activities/sheets/create_skill_sheet.dart';
import 'package:pole_mobile/features/activities/sheets/edit_skill_sheet.dart';
import 'package:pole_mobile/features/activities/sheets/upload_tuto_sheet.dart';
import 'package:pole_mobile/features/profile/providers/me_provider.dart';
import 'package:video_player/video_player.dart';

class LevelAccordion extends ConsumerWidget {
  const LevelAccordion({
    required this.activityId,
    required this.isTeacher,
    super.key,
  });

  final int activityId;
  final bool isTeacher;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final levelsAsync = ref.watch(levelsProvider(activityId));
    final theme = Theme.of(context);
    final ct = ref.watch(clubThemeProvider);

    return levelsAsync.when(
      loading: () => Center(
        child: CircularProgressIndicator(color: ct.primary),
      ),
      error: (e, _) => Center(child: Text('Erreur niveaux : $e')),
      data: (levels) {
        if (levels.isEmpty) {
          return Text(
            'Aucun niveau défini pour cette activité',
            style: theme.textTheme.bodySmall?.copyWith(
              color: ct.dark.withValues(alpha: 0.7),
            ),
          );
        }
        return Column(
          children: levels.asMap().entries.map((entry) {
            final index = entry.key;
            final level = entry.value;

            return Column(
              children: [
                _LevelTile(level: level, isTeacher: isTeacher),
                if (index < levels.length - 1)
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: ct.border,
                  ),
              ],
            );
          }).toList(),
        );
      },
    );
  }
}

class _LevelTile extends ConsumerStatefulWidget {
  const _LevelTile({required this.level, required this.isTeacher});

  final Level level;
  final bool isTeacher;

  @override
  ConsumerState<_LevelTile> createState() => _LevelTileState();
}

class _LevelTileState extends ConsumerState<_LevelTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ct = ref.watch(clubThemeProvider);

    return ExpansionTile(
      title: Text(widget.level.name, style: theme.textTheme.titleSmall),
      iconColor: ct.primary,
      collapsedIconColor: ct.dark,
      collapsedBackgroundColor: ct.surface,
      backgroundColor: ct.subtle,
      subtitle: widget.level.description?.isNotEmpty == true
          ? Text(
              widget.level.description ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall,
            )
          : null,
      onExpansionChanged: (expanded) => setState(() => _expanded = expanded),
      children: _expanded
          ? [
              _SkillsList(
                levelId: widget.level.id,
                isTeacher: widget.isTeacher,
              ),
            ]
          : [],
    );
  }
}

class _SkillsList extends ConsumerWidget {
  const _SkillsList({required this.levelId, required this.isTeacher});

  final int levelId;
  final bool isTeacher;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final skillsAsync = ref.watch(skillsProvider(levelId));
    final theme = Theme.of(context);

    return skillsAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Padding(
        padding: const EdgeInsets.all(16),
        child: Text('Erreur skills : $e'),
      ),
      data: (skills) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (skills.isEmpty)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Aucun skill dans ce niveau',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              )
            else
              ...skills.map((skill) => _SkillCard(
                    skill: skill,
                    levelId: levelId,
                    isTeacher: isTeacher,
                  )),
            if (isTeacher)
              TextButton.icon(
                onPressed: () => showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => CreateSkillSheet(levelId: levelId),
                ),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Ajouter un skill'),
              ),
          ],
        );
      },
    );
  }
}

class _SkillCard extends ConsumerWidget {
  const _SkillCard({
    required this.skill,
    required this.levelId,
    required this.isTeacher,
  });

  final Skill skill;
  final int levelId;
  final bool isTeacher;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final ct = ref.watch(clubThemeProvider);

    final medias = skill.skillMediaTutos
        .where((t) => t.mediaUrl != null)
        .toList();

    final currentUserId = ref.watch(meProvider).asData?.value.id;
    final canManageSkill = isTeacher && skill.createdById == currentUserId;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: ct.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (canManageSkill)
              Align(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      tooltip: 'Editer le skill',
                      icon: const Icon(Icons.edit_outlined),
                      onPressed: () => showModalBottomSheet<void>(
                        context: context,
                        isScrollControlled: true,
                        builder: (_) => EditSkillSheet(
                          levelId: levelId,
                          skill: skill,
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Supprimer le skill',
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                      ),
                      onPressed: () async {
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Supprimer ce skill ?'),
                            content: const Text(
                              'Cette action est irreversible.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text('Annuler'),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: const Text(
                                  'Supprimer',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        );

                        if (confirmed == true) {
                          await ref
                              .read(activitiesRepositoryProvider)
                              .deleteSkill(skill.id);
                          ref.invalidate(skillsProvider(levelId));
                        }
                      },
                    ),
                  ],
                ),
              ),

            Text(skill.name, style: theme.textTheme.titleSmall),

            if (skill.description != null && skill.description!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                skill.description!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],

            if (medias.isNotEmpty) ...[
              const SizedBox(height: 10),
              SizedBox(
                height: 160,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: medias.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 8),
                  itemBuilder: (context, index) => _MediaThumbnail(
                    tuto: medias[index],
                    levelId: levelId,
                    isTeacher: isTeacher,
                  ),
                ),
              ),
            ],

            if (canManageSkill) ...[
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () => showModalBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    builder: (_) => UploadTutoSheet(
                      skillId: skill.id,
                      levelId: levelId,
                    ),
                  ),
                  icon: const Icon(Icons.upload_outlined, size: 18),
                  label: const Text('Ajouter un media'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _MediaThumbnail extends ConsumerWidget {
  const _MediaThumbnail({
    required this.tuto,
    required this.levelId,
    required this.isTeacher,
  });

  final SkillMediaTuto tuto;
  final int levelId;
  final bool isTeacher;

  bool get _isVideo => tuto.mimetype?.startsWith('video/') ?? false;

  void _openImage(BuildContext context, String url) {
    unawaited(
      showDialog<void>(
        context: context,
        builder: (_) => Dialog(
          backgroundColor: Colors.black,
          insetPadding: EdgeInsets.zero,
          child: Stack(
            children: [
              InteractiveViewer(
                child: CachedNetworkImage(
                  imageUrl: url,
                  fit: BoxFit.contain,
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openVideo(BuildContext context, String url) {
    unawaited(
      showDialog<void>(
        context: context,
        builder: (_) => _VideoPlayerDialog(url: url),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final url = resolveMediaUrl(tuto.mediaUrl!);
    final currentUserId = ref.watch(meProvider).asData?.value.id;
    final canDelete = isTeacher &&
        tuto.createdById != null &&
        tuto.createdById == currentUserId;

    return Stack(
      children: [
        GestureDetector(
      onTap: () =>
          _isVideo ? _openVideo(context, url) : _openImage(context, url),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          width: 160,
          height: 160,
          child: _isVideo
              ? _VideoThumbnail(url: url)
              : CachedNetworkImage(
                  imageUrl: url,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const ColoredBox(
                    color: Colors.black12,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  errorWidget: (context, url, error) => const ColoredBox(
                    color: Colors.black12,
                    child: Icon(Icons.broken_image),
                  ),
                ),
        ),
      ),
        ),
        if (canDelete)
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Supprimer ce média ?'),
                    content: const Text(
                      'Cette action est irréversible.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('Annuler'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text(
                          'Supprimer',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );
                if (confirmed == true) {
                  await ref
                      .read(activitiesRepositoryProvider)
                      .deleteMediaTuto(tuto.id);
                  ref.invalidate(skillsProvider(levelId));
                }
              },
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(4),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// Charge la vidéo et affiche la première image comme miniature
class _VideoThumbnail extends StatefulWidget {
  const _VideoThumbnail({required this.url});

  final String url;

  @override
  State<_VideoThumbnail> createState() => _VideoThumbnailState();
}

class _VideoThumbnailState extends State<_VideoThumbnail> {
  VideoPlayerController? _controller;
  bool _initialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    unawaited(_init());
  }

  Future<void> _init() async {
    try {
      final controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.url),
      );
      await controller.initialize();
      await controller.seekTo(Duration.zero);
      if (mounted) {
        setState(() {
          _controller = controller;
          _initialized = true;
        });
      } else {
        unawaited(controller.dispose());
      }
    } on Exception {
      if (mounted) {
        setState(() => _hasError = true);
      }
    }
  }

  @override
  void dispose() {
    unawaited(_controller?.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return const Stack(
        fit: StackFit.expand,
        children: [
          ColoredBox(color: Colors.black),
          ColoredBox(color: Color(0x44000000)),
          Center(
            child: Icon(
              Icons.play_circle_filled,
              color: Colors.white,
              size: 48,
            ),
          ),
        ],
      );
    }

    if (!_initialized || _controller == null) {
      return const ColoredBox(
        color: Colors.black,
        child: Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }
    return Stack(
      fit: StackFit.expand,
      children: [
        VideoPlayer(_controller!),
        const ColoredBox(color: Color(0x44000000)),
        const Center(
          child: Icon(
            Icons.play_circle_filled,
            color: Colors.white,
            size: 48,
          ),
        ),
      ],
    );
  }
}

// Dialog plein écran pour lire la vidéo
class _VideoPlayerDialog extends StatefulWidget {
  const _VideoPlayerDialog({required this.url});

  final String url;

  @override
  State<_VideoPlayerDialog> createState() => _VideoPlayerDialogState();
}

class _VideoPlayerDialogState extends State<_VideoPlayerDialog> {
  late VideoPlayerController _videoController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    unawaited(_init());
  }

  Future<void> _init() async {
    _videoController = VideoPlayerController.networkUrl(
      Uri.parse(widget.url),
    );
    await _videoController.initialize();
    _chewieController = ChewieController(
      videoPlayerController: _videoController,
      autoPlay: true,
    );
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    unawaited(_videoController.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black,
      insetPadding: EdgeInsets.zero,
      child: Stack(
        children: [
          Center(
            child: _chewieController != null
                ? AspectRatio(
                    aspectRatio: _videoController.value.aspectRatio,
                    child: Chewie(controller: _chewieController!),
                  )
                : const CircularProgressIndicator(color: Colors.white),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }
}

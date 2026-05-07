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

  static const double _mediaCardWidth = 176;
  static const double _mediaCardAspectRatio = 4 / 5;

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
                height: _mediaCardWidth / _mediaCardAspectRatio,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: medias.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 8),
                  itemBuilder: (context, index) => _MediaThumbnail(
                    tuto: medias[index],
                    levelId: levelId,
                    isTeacher: isTeacher,
                    width: _mediaCardWidth,
                    aspectRatio: _mediaCardAspectRatio,
                    backgroundColor: ct.dark,
                    loaderColor: ct.primary,
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
    required this.width,
    required this.aspectRatio,
    required this.backgroundColor,
    required this.loaderColor,
  });

  final SkillMediaTuto tuto;
  final int levelId;
  final bool isTeacher;
  final double width;
  final double aspectRatio;
  final Color backgroundColor;
  final Color loaderColor;

  bool get _isVideo => tuto.mimetype?.startsWith('video/') ?? false;

  void _openViewer(BuildContext context, String url) {
    unawaited(
      showDialog<void>(
        context: context,
        builder: (_) => _MediaViewerDialog(
          url: url,
          isVideo: _isVideo,
        ),
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
    final ct = ref.watch(clubThemeProvider);
    final radius = BorderRadius.circular(14);

    return Stack(
      children: [
        GestureDetector(
          onTap: () => _openViewer(context, url),
          child: Container(
            width: width,
            decoration: BoxDecoration(
              borderRadius: radius,
              border: Border.all(color: ct.border),
              boxShadow: [
                BoxShadow(
                  color: ct.dark.withValues(alpha: 0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: radius,
              child: AspectRatio(
                aspectRatio: aspectRatio,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(color: ct.surface),
                      child: _isVideo
                          ? _VideoThumbnail(
                              url: url,
                              backgroundColor: backgroundColor,
                              loaderColor: loaderColor,
                            )
                          : CachedNetworkImage(
                              imageUrl: url,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => ColoredBox(
                                color: ct.subtle,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: ct.primary,
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) => ColoredBox(
                                color: ct.subtle,
                                child: Icon(
                                  Icons.broken_image_outlined,
                                  color: ct.dark,
                                ),
                              ),
                            ),
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.08),
                            Colors.black.withValues(alpha: 0.12),
                            Colors.black.withValues(alpha: 0.36),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      right: 10,
                      bottom: 10,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.45),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _isVideo
                              ? Icons.play_arrow_rounded
                              : Icons.open_in_full_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ),
                  ],
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
  const _VideoThumbnail({
    required this.url,
    required this.backgroundColor,
    required this.loaderColor,
  });

  final String url;
  final Color backgroundColor;
  final Color loaderColor;

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
      return Stack(
        fit: StackFit.expand,
        children: [
          ColoredBox(color: widget.backgroundColor),
          ColoredBox(color: Colors.black.withValues(alpha: 0.22)),
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

    if (!_initialized || _controller == null) {
      return ColoredBox(
        color: widget.backgroundColor,
        child: Center(
          child: CircularProgressIndicator(color: widget.loaderColor),
        ),
      );
    }

    final controller = _controller!;
    final videoSize = controller.value.size;

    return Stack(
      fit: StackFit.expand,
      children: [
        FittedBox(
          fit: BoxFit.cover,
          clipBehavior: Clip.hardEdge,
          child: SizedBox(
            width: videoSize.width,
            height: videoSize.height,
            child: VideoPlayer(controller),
          ),
        ),
        ColoredBox(color: Colors.black.withValues(alpha: 0.2)),
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

class _MediaViewerDialog extends StatefulWidget {
  const _MediaViewerDialog({
    required this.url,
    required this.isVideo,
  });

  final String url;
  final bool isVideo;

  @override
  State<_MediaViewerDialog> createState() => _MediaViewerDialogState();
}

class _MediaViewerDialogState extends State<_MediaViewerDialog> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    if (widget.isVideo) {
      unawaited(_init());
    }
  }

  Future<void> _init() async {
    try {
      final controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.url),
      );
      await controller.initialize();
      final chewie = ChewieController(
        videoPlayerController: controller,
      );
      if (!mounted) {
        chewie.dispose();
        unawaited(controller.dispose());
        return;
      }
      setState(() {
        _videoController = controller;
        _chewieController = chewie;
      });
    } on Exception {
      if (mounted) {
        setState(() => _hasError = true);
      }
    }
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    unawaited(_videoController?.dispose());
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
            child: widget.isVideo
                ? _buildVideoViewer()
                : InteractiveViewer(
                    maxScale: 4,
                    child: CachedNetworkImage(
                      imageUrl: widget.url,
                      fit: BoxFit.contain,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(
                            color: Colors.white,
                          ),
                      errorWidget: (context, url, error) => const Icon(
                        Icons.broken_image_outlined,
                        color: Colors.white,
                        size: 48,
                      ),
                    ),
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
    );
  }

  Widget _buildVideoViewer() {
    if (_hasError) {
      return const Icon(
        Icons.error_outline,
        color: Colors.white,
        size: 48,
      );
    }

    if (_chewieController == null || _videoController == null) {
      return const CircularProgressIndicator(color: Colors.white);
    }

    return AspectRatio(
      aspectRatio: _videoController!.value.aspectRatio,
      child: Chewie(controller: _chewieController!),
    );
  }
}

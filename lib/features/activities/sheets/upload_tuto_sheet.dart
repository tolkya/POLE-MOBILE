import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pole_mobile/features/activities/data/activities_repository.dart';
import 'package:pole_mobile/features/activities/providers/skills_provider.dart';

class UploadTutoSheet extends ConsumerStatefulWidget {
  const UploadTutoSheet({
    required this.skillId,
    required this.levelId,
    super.key});

  final int skillId;
  final int levelId;

  @override
  ConsumerState<UploadTutoSheet> createState() => _UploadTutoSheetState();
}

class _UploadTutoSheetState extends ConsumerState<UploadTutoSheet> {
  final _picker = ImagePicker();
  bool _uploading = false;
  double _progress = 0;
  String? _error;

  /// Déduit le mimeType depuis l'extension si image_picker ne le fournit pas.
  String _resolveMime(XFile file, {required bool isVideo}) {
    if (file.mimeType != null && file.mimeType!.isNotEmpty) {
      return file.mimeType!;
    }
    final ext = file.path.split('.').last.toLowerCase();
    const map = {
      'jpg': 'image/jpeg',
      'jpeg': 'image/jpeg',
      'png': 'image/png',
      'webp': 'image/webp',
      'gif': 'image/gif',
      'mp4': 'video/mp4',
      'mov': 'video/quicktime',
      'webm': 'video/webm',
    };
    return map[ext] ?? (isVideo ? 'video/mp4' : 'image/jpeg');
  }

  Future<void> _pickCameraPhoto() async {
    final status = await Permission.camera.request();
    if (!status.isGranted) {
      setState(() => _error = 'Permission caméra refusée.');
      return;
    }
    final file = await _picker.pickImage(source: ImageSource.camera);
    if (file != null) await _upload(file, isVideo: false);
  }

  Future<void> _pickCameraVideo() async {
    final status = await Permission.camera.request();
    if (!status.isGranted) {
      setState(() => _error = 'Permission caméra refusée.');
      return;
    }
    final file = await _picker.pickVideo(
      source: ImageSource.camera,
      maxDuration: const Duration(minutes: 5),
    );
    if (file != null) await _upload(file, isVideo: true);
  }

  Future<void> _pickGallery() async {
    await Permission.photos.request();
    await Permission.videos.request();
    final file = await _picker.pickMedia();
    if (file == null) return;
    final isVideo = (file.mimeType ?? '').startsWith('video/') ||
        ['mp4', 'mov', 'webm']
            .contains(file.path.split('.').last.toLowerCase());
    await _upload(file, isVideo: isVideo);
  }

  Future<void> _upload(XFile file, {required bool isVideo}) async {
    setState(() {
      _uploading = true;
      _progress = 0;
      _error = null;
    });
    try {
      await ref.read(activitiesRepositoryProvider).uploadTuto(
        skillId: widget.skillId,
        filePath: file.path,
        mimeType: _resolveMime(file, isVideo: isVideo),
        onProgress: (sent, total) {
          if (total > 0) setState(() => _progress = sent / total);
        },
      );
      ref.invalidate(skillsProvider(widget.levelId));
      if (mounted) Navigator.of(context).pop();
    } on Exception catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        24,
        16,
        24,
        MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Ajouter un tuto',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 20),
          if (_uploading) ...[
            LinearProgressIndicator(value: _progress),
            const SizedBox(height: 12),
            Text(
              '${(_progress * 100).toStringAsFixed(0)} %',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ] else ...[
            if (_error != null) ...[
              Text(
                _error!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
              const SizedBox(height: 12),
            ],
            // Caméra : photo + vidéo
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _pickCameraPhoto,
                    icon: const Icon(Icons.photo_camera_outlined, size: 18),
                    label: const Text('Photo'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _pickCameraVideo,
                    icon: const Icon(Icons.videocam_outlined, size: 18),
                    label: const Text('Vidéo'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Galerie : image ou vidéo au choix
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _pickGallery,
                icon: const Icon(Icons.photo_library_outlined),
                label: const Text('Choisir dans la galerie'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
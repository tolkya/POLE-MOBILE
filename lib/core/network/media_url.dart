import 'package:pole_mobile/core/env/env.dart';

/// Convertit un chemin relatif de média en URL absolue.
/// Si [path] est déjà une URL absolue, le retourne tel quel.
String resolveMediaUrl(String path) {
  if (path.startsWith('http')) return path;
  final base = Env.apiBaseUrl.replaceAll(RegExp(r'/api$'), '');
  return '$base$path';
}
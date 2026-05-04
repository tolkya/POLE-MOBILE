import 'dart:ui';

class ClubTheme {
  factory ClubTheme.fromHex(String? hex) {
    final h = (hex != null && hex.startsWith('#') && hex.length == 7)
        ? hex
        : '#7c3aed';
    final r = int.parse(h.substring(1, 3), radix: 16);
    final g = int.parse(h.substring(3, 5), radix: 16);
    final b = int.parse(h.substring(5, 7), radix: 16);
    return ClubTheme._(r, g, b);
  }

  ClubTheme._(int r, int g, int b)
    : primary = Color.fromARGB(255, r, g, b),
      subtle = Color.fromARGB(31, r, g, b), // ~0.12 opacity
      border = Color.fromARGB(56, r, g, b), // ~0.22 opacity
      surface = Color.fromARGB(13, r, g, b), // ~0.05 opacity
      dark = Color.fromARGB(
        255,
        (r * 0.8).round(),
        (g * 0.8).round(),
        (b * 0.8).round(),
      ),
      onPrimary = _contrast(r, g, b);

  /// Couleur principale du club (500)
  final Color primary;

  /// Fond très léger teinté (100) — cards, surfaces
  final Color subtle;

  /// Bordures et badges (300)
  final Color border;

  /// Surface quasi transparente (50) — arrière-plans
  final Color surface;

  /// Version sombre (700) — textes sur fond clair
  final Color dark;

  /// Blanc ou noir selon la luminance — texte sur fond primary
  final Color onPrimary;

  static Color _contrast(int r, int g, int b) {
    final luminance = (0.299 * r + 0.587 * g + 0.114 * b) / 255;
    return luminance > 0.5 ? const Color(0xFF1a1a2e) : const Color(0xFFFFFFFF);
  }
}

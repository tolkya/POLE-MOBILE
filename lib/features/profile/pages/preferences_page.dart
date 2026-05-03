import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pole_mobile/features/profile/providers/theme_mode_provider.dart';

class PreferencesPage extends ConsumerWidget {
  const PreferencesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Préférences')),
      body: RadioGroup<ThemeMode>(
        groupValue: mode,
        onChanged: (v) =>
            ref.read(themeModeProvider.notifier).setMode(v!),
        child: ListView(
          children: const [
            ListTile(
              title: Text('Thème'),
              dense: true,
              enabled: false,
            ),
            RadioListTile<ThemeMode>(
              title: Text('Système'),
              value: ThemeMode.system,
            ),
            RadioListTile<ThemeMode>(
              title: Text('Clair'),
              value: ThemeMode.light,
            ),
            RadioListTile<ThemeMode>(
              title: Text('Sombre'),
              value: ThemeMode.dark,
            ),
          ],
        ),
      ),
    );
  }
}
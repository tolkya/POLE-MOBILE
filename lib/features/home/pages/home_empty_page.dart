import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeEmptyPage extends StatelessWidget {
  const HomeEmptyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                Icons.search_off_rounded,
                size: 72,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 24),
              Text(
                "Tu n'as pas encore de club",
                style: theme.textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Recherche un club ou '
                'rejoins-en un avec un code.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: () => context.go('/discover'),
                icon: const Icon(Icons.explore),
                label: const Text('Découvrir des clubs'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

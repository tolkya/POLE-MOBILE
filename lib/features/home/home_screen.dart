import 'package:flutter/material.dart';

import '../../app/theme/app_theme.dart';
import '../../core/models/user_model.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({
    super.key,
    required this.user,
  });

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 18),
      children: [
        _HeroCard(user: user),
        const SizedBox(height: 14),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Bienvenue dans votre espace',
                  style: TextStyle(
                    color: AppTheme.text,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Retrouvez vos clubs, rejoignez de nouvelles structures et pilotez votre profil depuis la navigation en bas.',
                  style: TextStyle(color: AppTheme.textMuted, height: 1.4),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF7C3AED), Color(0xFF5B21B6)],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x2E7C3AED),
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bonjour ${user.firstName},',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 21,
            ),
          ),
        ],
      ),
    );
  }
}

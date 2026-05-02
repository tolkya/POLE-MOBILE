import 'package:flutter/material.dart';
import 'package:pole_mobile/core/models/club.dart';
import 'package:pole_mobile/core/network/media_url.dart';
import 'package:pole_mobile/core/theme/club_theme.dart';

class ClubHero extends StatelessWidget {
  const ClubHero({required this.club, super.key});

  final Club club;

  @override
  Widget build(BuildContext context) {
    final ct = ClubTheme.fromHex(club.themeColor);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ct.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          _ClubAvatar(club: club, ct: ct),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              club.name,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: ct.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ClubAvatar extends StatelessWidget {
  const _ClubAvatar({required this.club, required this.ct});

  final Club club;
  final ClubTheme ct;

  @override
  Widget build(BuildContext context) {
    final logoUrl = club.logoUrl;

    if (logoUrl != null && logoUrl.isNotEmpty) {
      return CircleAvatar(
        radius: 28,
        backgroundImage: NetworkImage(resolveMediaUrl(logoUrl)),
        backgroundColor: Color.fromARGB(
          31,
          ct.onPrimary.r.toInt(),
          ct.onPrimary.g.toInt(),
          ct.onPrimary.b.toInt(),
        ),
      );
    }

    return CircleAvatar(
      radius: 28,
      backgroundColor: Color.fromARGB(
        31,
        ct.onPrimary.r.toInt(),
        ct.onPrimary.g.toInt(),
        ct.onPrimary.b.toInt(),
      ),
      child: Text(
        club.name.substring(0, 1).toUpperCase(),
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: ct.onPrimary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
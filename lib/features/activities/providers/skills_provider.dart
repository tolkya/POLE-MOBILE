import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:pole_mobile/core/models/skill.dart';
import 'package:pole_mobile/core/network/dio_provider.dart';

final FutureProviderFamily<List<Skill>, int> skillsProvider = FutureProvider
    .autoDispose
    .family<List<Skill>, int>((ref, levelId) async {
      final dio = ref.read(dioProvider);
      final response = await dio.get<List<dynamic>>(
        '/levels/$levelId/skills',
      );
      return (response.data ?? [])
          .cast<Map<String, dynamic>>()
          .map(Skill.fromJson)
          .toList();
    });

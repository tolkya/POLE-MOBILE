import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:pole_mobile/core/models/level.dart';
import 'package:pole_mobile/core/network/dio_provider.dart';

final FutureProviderFamily<List<Level>, int> levelsProvider = FutureProvider
    .autoDispose
    .family<List<Level>, int>(
      (ref, activityId) async {
        final dio = ref.read(dioProvider);
        final response = await dio.get<List<dynamic>>(
          '/activities/$activityId/levels',
        );
        return (response.data ?? [])
            .cast<Map<String, dynamic>>()
            .map(Level.fromJson)
            .toList();
      },
    );

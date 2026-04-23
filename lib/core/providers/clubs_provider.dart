import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/club_model.dart';
import '../services/clubs_service.dart';
import 'auth_provider.dart';

class ClubsState {
  const ClubsState({
    required this.isLoading,
    required this.clubs,
    required this.error,
  });

  final bool isLoading;
  final List<UserClubModel> clubs;
  final String? error;

  factory ClubsState.initial() => const ClubsState(
        isLoading: false,
        clubs: <UserClubModel>[],
        error: null,
      );

  ClubsState copyWith({
    bool? isLoading,
    List<UserClubModel>? clubs,
    String? error,
    bool clearError = false,
  }) {
    return ClubsState(
      isLoading: isLoading ?? this.isLoading,
      clubs: clubs ?? this.clubs,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

final clubsServiceProvider = Provider<ClubsService>((ref) {
  return ClubsService(dio: ref.watch(dioProvider));
});

final clubsControllerProvider = NotifierProvider<ClubsController, ClubsState>(
  ClubsController.new,
);

class ClubsController extends Notifier<ClubsState> {
  @override
  ClubsState build() {
    return ClubsState.initial();
  }

  ClubsService get _clubsService => ref.read(clubsServiceProvider);

  Future<void> loadMyClubs() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final clubs = await _clubsService.fetchMyClubs();
      state = state.copyWith(
        isLoading: false,
        clubs: clubs,
        clearError: true,
      );
    } on DioException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Erreur clubs: ${e.response?.statusCode ?? 'API'}',
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Erreur clubs: $e',
      );
    }
  }

  Future<void> joinClubByCode(String clubCode) async {
    final code = clubCode.trim();
    if (code.isEmpty) {
      state = state.copyWith(error: 'Le code club est obligatoire.');
      return;
    }

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      await _clubsService.joinClubByCode(code);
      await loadMyClubs();
    } on DioException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Echec inscription club: ${e.response?.statusCode ?? 'API'}',
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Echec inscription club: $e',
      );
    }
  }

  Future<void> createClub(String name) async {
    final safeName = name.trim();
    if (safeName.isEmpty) {
      state = state.copyWith(error: 'Le nom du club est obligatoire.');
      return;
    }

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      await _clubsService.createClub(safeName);
      await loadMyClubs();
    } on DioException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Creation club impossible: ${e.response?.statusCode ?? 'API'}',
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Creation club impossible: $e',
      );
    }
  }
}

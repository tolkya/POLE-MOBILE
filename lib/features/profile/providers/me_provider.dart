import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pole_mobile/core/models/user.dart';
import 'package:pole_mobile/features/profile/data/profile_repository.dart';

final meProvider = AsyncNotifierProvider<MeNotifier, User>(MeNotifier.new);

class MeNotifier extends AsyncNotifier<User> {
  @override
  Future<User> build() =>
      ref.read(profileRepositoryProvider).getMe();

  void updateUser(User updated) {
    state = AsyncData(updated);
  }
}
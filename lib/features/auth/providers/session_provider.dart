import 'package:flutter_riverpod/flutter_riverpod.dart';

final tokenProvider = NotifierProvider<TokenNotifier, String?>(
  TokenNotifier.new,
);

class TokenNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  String? get token => state;
  set token(String token) => state = token;

  void clearToken() => state = null;
}

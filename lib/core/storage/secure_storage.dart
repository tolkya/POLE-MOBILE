import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Clés disponibles dans le stockage sécurisé.
/// Utiliser ces constantes partout — jamais de strings en dur ailleurs.
abstract final class StorageKeys {
  static const String token = 'auth_token';
  static const String activeClubId = 'active_club_id';
}

/// Wrapper autour de [FlutterSecureStorage].
/// Stocke les données sensibles dans le Keystore Android.
class SecureStorage {
  SecureStorage() : _storage = const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);

  Future<String?> read(String key) => _storage.read(key: key);

  Future<void> delete(String key) => _storage.delete(key: key);

  Future<void> deleteAll() => _storage.deleteAll();
}
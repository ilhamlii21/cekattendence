import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Service untuk menyimpan dan mengambil token JWT
/// di tempat yang aman (encrypted storage).
class SecureStorageService {
  static const _tokenKey = 'jwt_token';
  static final SecureStorageService _instance = SecureStorageService._();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  SecureStorageService._();

  /// Singleton instance agar storage konsisten di seluruh app
  factory SecureStorageService() => _instance;

  /// Simpan JWT token ke secure storage
  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  /// Ambil JWT token dari secure storage
  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  /// Hapus token (untuk logout)
  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }

  /// Cek apakah user sudah login (ada token tersimpan)
  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}

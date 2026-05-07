import 'package:flutter/material.dart';
import '../services/auth_api_service.dart';
import '../services/secure_storage_service.dart';

class AuthController extends ChangeNotifier {
  final AuthApiService _authApi = AuthApiService();
  final SecureStorageService _storage = SecureStorageService();

  bool isLoading = false;
  String errorMessage = '';

  /// Flow utama: Login → Ambil Token → Simpan di Secure Storage
  Future<bool> login(String email, String password) async {
    // Validasi input
    if (email.isEmpty || password.isEmpty) {
      errorMessage = 'Email dan password harus diisi!';
      notifyListeners();
      return false;
    }

    isLoading = true;
    errorMessage = '';
    notifyListeners();

    // Step 1: Hit login API, ambil token yang di-generate backend
    final (success, result) = await _authApi.login(email, password);

    if (success) {
      // Step 2: Simpan token di tempat sementara yang aman (secure storage)
      await _storage.saveToken(result);

      // Debug: Buktikan token berhasil disimpan dan bisa dibaca kembali
      debugPrint('═══════════════════════════════════════');
      debugPrint('✅ LOGIN BERHASIL');
      debugPrint('Token dari API: ${result.substring(0, 20)}...'); // 20 char pertama saja
      final savedToken = await _storage.getToken();
      debugPrint('Token dari Storage: ${savedToken?.substring(0, 20)}...');
      debugPrint('Token cocok: ${result == savedToken}');
      debugPrint('═══════════════════════════════════════');

      isLoading = false;
      notifyListeners();
      return true;
    } else {
      errorMessage = result;
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Logout: hapus token dari secure storage
  Future<void> logout() async {
    await _storage.deleteToken();
    notifyListeners();
  }

  /// Cek apakah sudah ada token tersimpan
  Future<bool> isLoggedIn() async {
    return await _storage.hasToken();
  }
}

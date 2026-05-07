import 'package:flutter/material.dart';
import '../models/check_in_request.dart';
import '../services/attendance_api_service.dart';
import '../services/secure_storage_service.dart';

class AttendanceController extends ChangeNotifier {
  final AttendanceApiService _apiService = AttendanceApiService();
  final SecureStorageService _storage = SecureStorageService();
  
  bool isLoading = false;
  String message = '';

  /// Ambil token dari secure storage (bukan hardcode!)
  Future<String?> _getToken() async {
    final token = await _storage.getToken();
    if (token == null || token.isEmpty) {
      message = 'Sesi habis. Silakan login ulang.';
      notifyListeners();
    }
    return token;
  }

  Future<void> performCheckIn(String qrToken, double lat, double lon) async {
    // Step: Ambil token dari secure storage
    final token = await _getToken();
    if (token == null || token.isEmpty) return;

    isLoading = true;
    message = 'Loading...';
    notifyListeners();

    final request = CheckInRequest(qrToken: qrToken, latitude: lat, longitude: lon);
    final result = await _apiService.checkIn(request, token);

    isLoading = false;
    if (result.$1) {
      message = '✅ Check-in berhasil!';
    } else {
      message = '❌ Gagal:\n${result.$2}';
    }
    notifyListeners();
  }

  Future<void> performCheckOut() async {
    // Step: Ambil token dari secure storage
    final token = await _getToken();
    if (token == null || token.isEmpty) return;

    isLoading = true;
    message = 'Loading...';
    notifyListeners();

    final result = await _apiService.checkOut(token);

    isLoading = false;
    if (result.$1) {
      message = '✅ Check-out berhasil!';
    } else {
      message = '❌ Gagal:\n${result.$2}';
    }
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import '../models/barbershop.dart';
import '../services/attendance_api_service.dart';
import '../services/secure_storage_service.dart';

class BarbershopController extends ChangeNotifier {
  final AttendanceApiService _apiService = AttendanceApiService();
  final SecureStorageService _storage = SecureStorageService();
  
  bool isLoading = false;
  String message = '';
  List<Barbershop> barbershops = [];

  Future<void> fetchBarbershops() async {
    final token = await _storage.getToken();
    if (token == null || token.isEmpty) {
      message = 'Sesi habis. Silakan login ulang.';
      notifyListeners();
      return;
    }

    isLoading = true;
    message = 'Loading data...';
    notifyListeners();

    final data = await _apiService.getBarbershops(token);
    
    if (data.isNotEmpty) {
      barbershops = data.map((json) => Barbershop.fromJson(json)).toList();
      message = '✅ Berhasil mengambil ${barbershops.length} data';
    } else {
      message = '❌ Gagal atau data kosong.';
      barbershops = [];
    }
    
    isLoading = false;
    notifyListeners();
  }
}

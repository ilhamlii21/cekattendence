import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/check_in_request.dart';

class AttendanceApiService {
  static const String baseUrl = 'https://ada-backend-service.onrender.com';

  /// Parse error message dari response backend
  String _parseErrorMessage(int statusCode, String body) {
    // Coba parse JSON error dari backend
    try {
      final json = jsonDecode(body);
      final msg = json['message'] ?? json['error'] ?? json['msg'] ?? '';
      if (msg.toString().isNotEmpty) {
        return msg.toString();
      }
    } catch (_) {}

    // Fallback berdasarkan status code
    switch (statusCode) {
      case 400:
        return 'Request tidak valid. Periksa data yang dikirim.';
      case 401:
        return 'Token tidak valid atau sudah expired. Silakan login ulang.';
      case 403:
        return 'Anda tidak punya akses untuk melakukan ini.';
      case 404:
        return 'Endpoint tidak ditemukan.';
      case 409:
        return 'Konflik — mungkin sudah check-in/check-out sebelumnya.';
      case 422:
        return 'Data tidak valid (QR token salah atau sudah expired).';
      case 429:
        return 'Terlalu banyak request. Coba lagi nanti.';
      case 500:
        return 'Server sedang bermasalah. Coba lagi nanti.';
      case 502:
        return 'Server tidak merespons (Bad Gateway).';
      case 503:
        return 'Server sedang maintenance. Coba lagi nanti.';
      default:
        return 'Error tidak dikenal (HTTP $statusCode): $body';
    }
  }

  /// Parse error dari exception (koneksi, timeout, dll)
  String _parseException(dynamic e) {
    if (e is SocketException) {
      return 'Tidak ada koneksi internet. Periksa WiFi/data kamu.';
    } else if (e is HttpException) {
      return 'Gagal menghubungi server.';
    } else if (e is FormatException) {
      return 'Response dari server tidak valid.';
    } else if (e.toString().contains('TimeoutException')) {
      return 'Koneksi timeout. Server terlalu lama merespons.';
    } else if (e.toString().contains('HandshakeException')) {
      return 'Gagal koneksi SSL. Periksa koneksi internet kamu.';
    } else {
      return 'Terjadi kesalahan: ${e.toString()}';
    }
  }

  Future<(bool, String)> checkIn(CheckInRequest request, String token) async {
    final url = Uri.parse('$baseUrl/attendance/check-in');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 201) {
        return (true, 'Check-in berhasil!');
      } else {
        final errorMsg = _parseErrorMessage(response.statusCode, response.body);
        debugPrint('Check-in failed: ${response.statusCode} - ${response.body}');
        return (false, errorMsg);
      }
    } catch (e) {
      debugPrint('Error during check-in: $e');
      return (false, _parseException(e));
    }
  }

  Future<(bool, String)> checkOut(String token) async {
    final url = Uri.parse('$baseUrl/attendance/check-out');
    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return (true, 'Check-out berhasil!');
      } else {
        final errorMsg = _parseErrorMessage(response.statusCode, response.body);
        debugPrint('Check-out failed: ${response.statusCode} - ${response.body}');
        return (false, errorMsg);
      }
    } catch (e) {
      debugPrint('Error during check-out: $e');
      return (false, _parseException(e));
    }
  }

  // GET /barbershops
  Future<List<dynamic>> getBarbershops(String token) async {
    final url = Uri.parse('$baseUrl/barbershops');
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data;
      } else {
        debugPrint('Get barbershops failed: ${response.statusCode} - ${response.body}');
        return [];
      }
    } catch (e) {
      debugPrint('Error getting barbershops: $e');
      return [];
    }
  }
}

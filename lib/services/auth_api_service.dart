import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthApiService {
  static const String baseUrl = 'https://ada-backend-service.onrender.com';

  /// Login ke backend, return (success, token/errorMessage)
  Future<(bool, String)> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/auth/login');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        // Ambil token dari response — sesuaikan key-nya
        // biasanya: { "token": "xxx" } atau { "data": { "token": "xxx" } }
        final token = body['token'] ?? body['data']?['token'] ?? body['accessToken'];
        if (token != null) {
          return (true, token as String);
        } else {
          debugPrint('Login response body: ${response.body}');
          return (false, 'Token tidak ditemukan di response');
        }
      } else {
        debugPrint('Login failed: ${response.statusCode} - ${response.body}');
        return (false, 'Login gagal (${response.statusCode}): ${response.body}');
      }
    } catch (e) {
      debugPrint('Error during login: $e');
      return (false, 'Error: $e');
    }
  }
}

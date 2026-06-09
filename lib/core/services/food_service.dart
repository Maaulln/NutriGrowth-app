import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/food_model.dart';
import 'api_service.dart';

class FoodService {
  FoodService._();
  static final FoodService _instance = FoodService._();
  static FoodService get instance => _instance;

  final http.Client _client = http.Client();
  String? pendingCategory;

  /// Mengambil daftar makanan dari backend API.
  ///
  /// Fungsi ini dilengkapi dengan retry logic otomatis jika terjadi masalah jaringan
  /// seperti [SocketException] atau [TimeoutException].
  ///
  /// [category] - Kategori makanan yang ingin disaring (opsional).
  /// [search] - Kata kunci pencarian nama makanan (opsional).
  /// [maxRetries] - Jumlah maksimal percobaan ulang request jika gagal (default: 3).
  /// [timeoutDuration] - Durasi timeout maksimal untuk setiap request (default: 15 detik).
  Future<List<Food>> getFoods({
    String? category,
    String? search,
    int maxRetries = 3,
    Duration timeoutDuration = const Duration(seconds: 15),
  }) async {
    final queryParameters = <String, String>{};
    if (category != null && category != 'All') {
      queryParameters['category'] = category.toLowerCase();
    }
    if (search != null && search.isNotEmpty) {
      queryParameters['search'] = search;
    }

    final uri = Uri.parse('${ApiService.baseUrl}/foods').replace(
      queryParameters: queryParameters,
    );

    int attempts = 0;
    while (attempts < maxRetries) {
      attempts++;
      try {
        if (attempts > 1) {
          debugPrint('Mencoba kembali mengambil data makanan (Percobaan $attempts/$maxRetries)...');
        }
        final response = await _client.get(
          uri,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ).timeout(timeoutDuration);

        if (response.statusCode == 200) {
          final Map<String, dynamic> body = jsonDecode(response.body);
          final List<dynamic> data = body['data'];
          return data.map((json) => Food.fromJson(json)).toList();
        } else {
          throw FoodServiceException('Failed to load foods (${response.statusCode})');
        }
      } on FoodServiceException {
        // Jika status code bukan 200, langsung throw karena ini kesalahan logika/otorisasi
        rethrow;
      } on SocketException {
        if (attempts >= maxRetries) {
          throw const FoodServiceException('No internet connection. Check your network.');
        }
        // Jeda sebelum percobaan berikutnya (backoff sederhana)
        await Future.delayed(Duration(milliseconds: 500 * attempts));
      } on TimeoutException {
        if (attempts >= maxRetries) {
          throw const FoodServiceException('Server took too long to respond. Try again.');
        }
        // Jeda sebelum percobaan berikutnya (backoff sederhana)
        await Future.delayed(Duration(milliseconds: 500 * attempts));
      } catch (e) {
        if (attempts >= maxRetries) {
          throw const FoodServiceException('Failed to load foods. Try again.');
        }
        await Future.delayed(Duration(milliseconds: 500 * attempts));
      }
    }

    throw const FoodServiceException('Failed to load foods. Try again.');
  }
}

class FoodServiceException implements Exception {
  const FoodServiceException(this.message);
  final String message;

  @override
  String toString() => message;
}

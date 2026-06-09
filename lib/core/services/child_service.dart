import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';
import 'auth_service.dart';
import '../models/child_model.dart';
import '../models/growth_record_model.dart';

class ChildService {
  ChildService._();
  static final ChildService _instance = ChildService._();
  static ChildService get instance => _instance;

  static const String _activeChildIdKey = 'active_child_id';

  final _client = http.Client();

  /// Menyimpan ID anak aktif yang dipilih orang tua.
  Future<void> setActiveChildId(int childId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_activeChildIdKey, childId);
  }

  /// Mengambil ID anak aktif dari penyimpanan lokal.
  Future<int?> getActiveChildId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_activeChildIdKey);
  }

  /// Menghapus ID anak aktif saat data tidak lagi valid.
  Future<void> clearActiveChildId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_activeChildIdKey);
  }

  Future<Map<String, String>> _getAuthHeaders() async {
    final token = await AuthService.instance.getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  /// Mengambil daftar anak dari backend dengan retry logic dan timeout.
  ///
  /// [maxRetries] - Jumlah maksimal percobaan jika terjadi masalah jaringan (default: 3).
  /// [timeoutDuration] - Batas waktu timeout untuk setiap request (default: 10 detik).
  Future<List<Child>> getChildren({
    int maxRetries = 3,
    Duration timeoutDuration = const Duration(seconds: 10),
  }) async {
    final uri = Uri.parse('${ApiService.baseUrl}/children');
    int attempts = 0;

    while (attempts < maxRetries) {
      attempts++;
      try {
        if (attempts > 1) {
          debugPrint('Mencoba kembali mengambil data anak (Percobaan $attempts/$maxRetries)...');
        }
        final headers = await _getAuthHeaders();
        final response = await _client
            .get(uri, headers: headers)
            .timeout(timeoutDuration);

        if (response.statusCode == 200) {
          final jsonResponse = jsonDecode(response.body);
          final List data = jsonResponse['data'];
          return data.map((child) => Child.fromJson(child)).toList();
        } else {
          throw Exception('Failed to fetch child data (${response.statusCode})');
        }
      } on SocketException {
        if (attempts >= maxRetries) {
          throw Exception('No internet connection. Check your network.');
        }
        await Future.delayed(Duration(milliseconds: 500 * attempts));
      } on TimeoutException {
        if (attempts >= maxRetries) {
          throw Exception('Server took too long to respond. Try again.');
        }
        await Future.delayed(Duration(milliseconds: 500 * attempts));
      } catch (e) {
        if (attempts >= maxRetries) {
          throw Exception('An error occurred: $e');
        }
        await Future.delayed(Duration(milliseconds: 500 * attempts));
      }
    }
    throw Exception('Failed to fetch child data. Try again.');
  }

  /// Menambahkan data anak baru dengan timeout.
  Future<Child> addChild(Child child) async {
    final uri = Uri.parse('${ApiService.baseUrl}/children');

    try {
      final headers = await _getAuthHeaders();
      final response = await _client.post(
        uri,
        headers: headers,
        body: jsonEncode(child.toJson()),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);
        return Child.fromJson(jsonResponse['data']);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to add child data');
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }

  /// Memperbarui data anak dengan timeout.
  Future<Child> updateChild(int id, Child child) async {
    final uri = Uri.parse('${ApiService.baseUrl}/children/$id');

    try {
      final headers = await _getAuthHeaders();
      final response = await _client.put(
        uri,
        headers: headers,
        body: jsonEncode(child.toJson()),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return Child.fromJson(jsonResponse['data']);
      } else {
        throw Exception('Failed to update child data');
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }

  /// Menghapus data anak dengan timeout.
  Future<void> deleteChild(int id) async {
    final uri = Uri.parse('${ApiService.baseUrl}/children/$id');

    try {
      final headers = await _getAuthHeaders();
      final response = await _client
          .delete(uri, headers: headers)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception('Failed to delete child data');
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }

  /// Mengambil riwayat tumbuh kembang anak (max 6 titik, diurutkan dari terlama).
  Future<List<GrowthRecord>> getGrowthRecords(int childId) async {
    final uri = Uri.parse(
      '${ApiService.baseUrl}/children/$childId/growth-records',
    );
    try {
      final headers = await _getAuthHeaders();
      final response = await _client
          .get(uri, headers: headers)
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        final list = body['data'] as List? ?? [];
        return list
            .map((e) => GrowthRecord.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }
}

import 'package:flutter/foundation.dart';

/// Konfigurasi base URL untuk setiap platform.
///
/// Endpoint yang digunakan:
///   POST   /api/users  → Daftar user baru
///   GET    /api/users  → List semua user
///
/// Platform URL mapping:
/// - Android Emulator : 10.0.2.2  (localhost dari perspektif emulator)
/// - iOS Simulator    : localhost
/// - Web              : localhost
/// - Device Fisik     : ganti dengan IP mesin Anda, contoh: 192.168.1.10
class ApiService {
  ApiService._();

  static const String _aiHostEnv = String.fromEnvironment(
    'NUTRIGROWTH_API_HOST',
  );
  static const String _apiKeyEnv = String.fromEnvironment('API_KEY');

  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:8080/api';
    }

    // Defaulting ke 10.0.2.2 (Android Emulator).
    // Jika pakai iOS Simulator atau device fisik, ganti nilai ini.
    return 'http://10.0.2.2:8080/api';
  }

  /// Base URL untuk endpoint AI NutriGrowth.
  ///
  /// Prioritas nilai:
  /// 1. `--dart-define=NUTRIGROWTH_API_HOST=...`
  /// 2. Default lokal (`localhost` untuk web, `10.0.2.2` untuk emulator Android)
  static String get aiBaseUrl {
    if (_aiHostEnv.isNotEmpty) {
      return _aiHostEnv;
    }
    if (kIsWeb) {
      return 'http://localhost:8000';
    }
    return 'http://10.0.2.2:8000';
  }

  /// API key opsional yang dikirim sebagai Bearer token.
  static String? get apiKey {
    if (_apiKeyEnv.isEmpty) {
      return null;
    }
    return _apiKeyEnv;
  }

  /// Membuat URI endpoint AI dari [path] dan [queryParameters].
  static Uri buildAiUri(String path, {Map<String, dynamic>? queryParameters}) {
    final normalizedPath = path.startsWith('/') ? path : '/$path';
    return Uri.parse('$aiBaseUrl$normalizedPath').replace(
      queryParameters: queryParameters?.map(
        (key, value) => MapEntry(key, value.toString()),
      ),
    );
  }

  /// Header standar JSON untuk endpoint AI.
  static Map<String, String> aiHeaders({bool withAuth = true}) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final token = apiKey;
    if (withAuth && token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }
}

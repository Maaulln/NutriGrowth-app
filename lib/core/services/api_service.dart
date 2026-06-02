import 'package:flutter/foundation.dart';

/// Konfigurasi base URL untuk setiap platform.
///
/// Untuk production, set URL via --dart-define saat build:
///   flutter build apk \
///     --dart-define=NUTRIGROWTH_BACKEND_HOST=https://api.nutrigrowth.com \
///     --dart-define=NUTRIGROWTH_API_HOST=https://ai.nutrigrowth.com \
///     --dart-define=API_KEY=your_key_here
class ApiService {
  ApiService._();

  static const String _backendHostEnv = String.fromEnvironment(
    'NUTRIGROWTH_BACKEND_HOST',
  );
  static const String _aiHostEnv = String.fromEnvironment(
    'NUTRIGROWTH_API_HOST',
  );
  static const String _apiKeyEnv = String.fromEnvironment('API_KEY');

  /// Base URL untuk backend (Spring Boot / REST API).
  ///
  /// Prioritas:
  /// 1. --dart-define=NUTRIGROWTH_BACKEND_HOST=https://...
  /// 2. Fallback lokal (development only)
  static String get baseUrl {
    if (_backendHostEnv.isNotEmpty) {
      return '$_backendHostEnv/api';
    }
    if (kIsWeb) {
      return 'http://localhost:8080/api';
    }
    return 'http://192.168.18.176:8080/api';
  }

  /// Base URL untuk endpoint AI NutriGrowth.
  ///
  /// Prioritas:
  /// 1. --dart-define=NUTRIGROWTH_API_HOST=https://...
  /// 2. Fallback lokal (development only)
  static String get aiBaseUrl {
    if (_aiHostEnv.isNotEmpty) {
      return _aiHostEnv;
    }
    if (kIsWeb) {
      return 'http://localhost:8000';
    }
    return 'http://13.211.78.15:8000';
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

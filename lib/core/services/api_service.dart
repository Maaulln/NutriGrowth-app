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

  /// Base URL untuk backend REST API.
  ///
  /// Prioritas:
  /// 1. --dart-define=NUTRIGROWTH_BACKEND_HOST=https://...
  /// 2. Fallback: public backend server at 13.213.1.155:8000
  static String get baseUrl {
    if (_backendHostEnv.isNotEmpty) {
      return '$_backendHostEnv/api';
    }
    return 'http://13.213.1.155:8000/api';
  }

  /// Path endpoint analisis gizi di AI service lokal (nutrigrowth-ai).
  static const String nutritionAnalyzePath = '/analyze';

  /// Base URL untuk endpoint AI NutriGrowth.
  ///
  /// Prioritas:
  /// 1. --dart-define=NUTRIGROWTH_API_HOST=https://...
  /// 2. Fallback: public AI server at 13.54.38.203:8000
  static String get aiBaseUrl {
    if (_aiHostEnv.isNotEmpty) {
      return _aiHostEnv;
    }
    return 'http://13.54.38.203:8000';
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

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/nutrition_analysis_model.dart';
import '../models/stunting_assessment_model.dart';
import 'api_service.dart';
import 'auth_service.dart';

/// Exception khusus untuk kegagalan komunikasi ke API AI NutriGrowth.
class NutritionAiException implements Exception {
  /// Membuat error service AI dengan [message] yang aman untuk UI.
  const NutritionAiException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Service untuk analisis gizi anak.
///
/// Request dikirim langsung ke local AI server (nutrigrowth-ai, port 8000).
class NutritionAiService {
  NutritionAiService._();

  static final NutritionAiService _instance = NutritionAiService._();
  static NutritionAiService get instance => _instance;

  final http.Client _client = http.Client();

  Future<Map<String, String>> _getAuthHeaders() async {
    final token = await AuthService.instance.getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  /// Mengirim data antropometri langsung ke local AI server (nutrigrowth-ai).
  Future<NutritionAnalysisResult> analyzeNutrition(
    NutritionAnalysisRequest request,
  ) async {
    final uri = ApiService.buildAiUri(ApiService.nutritionAnalyzePath);

    try {
      final response = await _client
          .post(
            uri,
            headers: ApiService.aiHeaders(withAuth: false),
            body: jsonEncode(request.toJson()),
          )
          .timeout(const Duration(seconds: 30));

      final dynamic decodedBody = _decodeResponse(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final resultMap = _extractResultMap(decodedBody);
        return NutritionAnalysisResult.fromJson(resultMap);
      }

      throw NutritionAiException(_extractErrorMessage(decodedBody));
    } on NutritionAiException {
      rethrow;
    } on SocketException {
      throw const NutritionAiException(
        'Cannot connect to AI server. Ensure your phone and laptop are on the same WiFi network and the AI server (port 8000) is running.',
      );
    } on TimeoutException {
      throw const NutritionAiException(
        'AI server is not responding. Ensure nutrigrowth-ai is running.',
      );
    } catch (_) {
      throw const NutritionAiException(
        'Cannot connect to AI server. Ensure the AI server is running on port 8000.',
      );
    }
  }

  dynamic _decodeResponse(String body) {
    if (body.trim().isEmpty) return <String, dynamic>{};
    try {
      return jsonDecode(body);
    } catch (_) {
      return <String, dynamic>{};
    }
  }

  /// Backend membungkus response AI dalam `{ status, message, data: {...} }`.
  /// Jika tidak ada wrapper, pakai langsung (kompatibel dengan test UI).
  Map<String, dynamic> _extractResultMap(dynamic decodedBody) {
    if (decodedBody is Map<String, dynamic>) {
      final nested = decodedBody['data'];
      if (nested is Map<String, dynamic>) return nested;
      return decodedBody;
    }
    return <String, dynamic>{};
  }

  String _extractErrorMessage(dynamic decodedBody) {
    if (decodedBody is Map<String, dynamic>) {
      for (final key in ['message', 'detail', 'error']) {
        final val = decodedBody[key];
        if (val is String && val.trim().isNotEmpty) return val;
      }
    }
    return 'An error occurred while processing nutrition analysis.';
  }

  /// Mengambil assessment terbaru untuk anak tertentu.
  Future<StuntingAssessmentSummary?> getLatestAssessment(int childId) async {
    final assessments = await getAllAssessments(childId);
    return assessments.isNotEmpty ? assessments.first : null;
  }

  /// Mengambil semua riwayat assessment untuk anak tertentu (urut terlama → terbaru).
  Future<List<StuntingAssessmentSummary>> getAllAssessments(int childId) async {
    final uri = Uri.parse('${ApiService.baseUrl}/children/$childId/assessments');
    try {
      final headers = await _getAuthHeaders();
      final response = await _client
          .get(uri, headers: headers)
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        final list = body['data'] as List? ?? [];
        final assessments = list
            .whereType<Map<String, dynamic>>()
            .map(StuntingAssessmentSummary.fromJson)
            .toList();
        // Backend returns newest-first; reverse agar grafik terlama → terbaru
        return assessments.reversed.toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }
}

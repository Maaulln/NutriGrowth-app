import 'dart:convert';

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
/// Request dikirim ke Backend Laravel (POST /api/analyze) bukan langsung ke
/// AI server. Backend yang mengambil food candidates dari Supabase, memanggil
/// AI, menyimpan hasilnya, lalu mengembalikan response ke app.
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

  /// Mengirim data antropometri ke Backend dan mengembalikan hasil analisis.
  ///
  /// Backend akan:
  ///   1. Mengambil food candidates dari Supabase (filter usia & budget)
  ///   2. Memanggil AI server dengan food_candidates
  ///   3. Menyimpan hasil ke DB
  ///   4. Mengembalikan response AI
  Future<NutritionAnalysisResult> analyzeNutrition(
    NutritionAnalysisRequest request,
  ) async {
    final uri = Uri.parse('${ApiService.baseUrl}/analyze');

    try {
      final headers = await _getAuthHeaders();
      final response = await _client
          .post(
            uri,
            headers: headers,
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
    } catch (_) {
      throw const NutritionAiException(
        'Tidak dapat terhubung ke server. Pastikan koneksi internet aktif.',
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
    return 'Terjadi kesalahan saat memproses analisis gizi.';
  }

  /// Mengambil assessment terbaru untuk anak tertentu.
  Future<StuntingAssessmentSummary?> getLatestAssessment(int childId) async {
    final uri = Uri.parse('${ApiService.baseUrl}/children/$childId/assessments');
    try {
      final headers = await _getAuthHeaders();
      final response = await _client
          .get(uri, headers: headers)
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        final list = body['data'] as List?;
        if (list == null || list.isEmpty) return null;
        return StuntingAssessmentSummary.fromJson(
          list.first as Map<String, dynamic>,
        );
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}

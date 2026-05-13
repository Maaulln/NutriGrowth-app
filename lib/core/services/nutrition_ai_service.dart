import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/nutrition_analysis_model.dart';
import 'api_service.dart';

/// Exception khusus untuk kegagalan komunikasi ke API AI NutriGrowth.
class NutritionAiException implements Exception {
  /// Membuat error service AI dengan [message] yang aman untuk UI.
  const NutritionAiException(this.message);

  final String message;

  @override
  /// Mengembalikan pesan error agar mudah ditampilkan ke pengguna.
  String toString() => message;
}

/// Service untuk memanggil endpoint analisis gizi berbasis model AI.
class NutritionAiService {
  /// Membuat instance service sebagai singleton.
  NutritionAiService._();

  static final NutritionAiService _instance = NutritionAiService._();

  /// Getter singleton service analisis gizi.
  static NutritionAiService get instance => _instance;

  final http.Client _client = http.Client();

  /// Mengirim data antropometri ke endpoint AI dan mengembalikan hasil analisis.
  ///
  /// [request] berisi payload input model yang sudah tervalidasi di UI.
  /// Return berupa [NutritionAnalysisResult] jika request berhasil.
  Future<NutritionAnalysisResult> analyzeNutrition(
    NutritionAnalysisRequest request,
  ) async {
    final uri = ApiService.buildAiUri('/api/v1/nutrition/analyze');

    try {
      final response = await _client
          .post(
            uri,
            headers: ApiService.aiHeaders(),
            body: jsonEncode(request.toJson()),
          )
          .timeout(const Duration(seconds: 15));

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
        'Tidak dapat terhubung ke API AI. Pastikan server aktif dan host benar.',
      );
    }
  }

  /// Mengubah body respons menjadi object JSON dinamis yang aman diproses.
  dynamic _decodeResponse(String body) {
    if (body.trim().isEmpty) {
      return <String, dynamic>{};
    }

    try {
      return jsonDecode(body);
    } catch (_) {
      return <String, dynamic>{};
    }
  }

  /// Mengekstrak map data utama dari respons agar parsing model konsisten.
  Map<String, dynamic> _extractResultMap(dynamic decodedBody) {
    if (decodedBody is Map<String, dynamic>) {
      final nestedData = decodedBody['data'];
      if (nestedData is Map<String, dynamic>) {
        return nestedData;
      }
      return decodedBody;
    }
    return <String, dynamic>{};
  }

  /// Mengambil pesan error paling relevan dari body respons API.
  String _extractErrorMessage(dynamic decodedBody) {
    if (decodedBody is Map<String, dynamic>) {
      final message = decodedBody['message'];
      if (message is String && message.trim().isNotEmpty) {
        return message;
      }

      final detail = decodedBody['detail'];
      if (detail is String && detail.trim().isNotEmpty) {
        return detail;
      }

      final error = decodedBody['error'];
      if (error is String && error.trim().isNotEmpty) {
        return error;
      }
    }

    return 'Terjadi kesalahan saat memproses analisis gizi.';
  }
}

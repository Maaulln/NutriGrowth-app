/// Model request untuk endpoint analisis gizi AI.
class NutritionAnalysisRequest {
  /// Membuat payload analisis dari data antropometri anak.
  ///
  /// [ageMonths] umur anak dalam bulan.
  /// [gender] 1 untuk laki-laki, 0 untuk perempuan.
  /// [weightKg] berat badan dalam kilogram.
  /// [heightCm] tinggi badan dalam sentimeter.
  /// [muacCm] lingkar lengan atas (MUAC) dalam sentimeter.
  const NutritionAnalysisRequest({
    required this.ageMonths,
    required this.gender,
    required this.weightKg,
    required this.heightCm,
    required this.muacCm,
  });

  final int ageMonths;
  final int gender;
  final double weightKg;
  final double heightCm;
  final double muacCm;

  /// Mengubah object menjadi JSON body yang siap dikirim ke API.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'age_months': ageMonths,
      'gender': gender,
      'weight_kg': weightKg,
      'height_cm': heightCm,
      'muac_cm': muacCm,
    };
  }
}

/// Model respons hasil analisis gizi AI.
class NutritionAnalysisResult {
  /// Membuat object hasil analisis yang siap dipakai di UI.
  ///
  /// [status] label status pertumbuhan dari API.
  /// [recommendation] saran lanjutan berdasarkan hasil model.
  const NutritionAnalysisResult({
    required this.status,
    required this.recommendation,
  });

  final String status;
  final String recommendation;

  /// Parsing JSON respons dari API menjadi model yang aman untuk UI.
  ///
  /// Method ini mendukung beberapa variasi key umum agar integrasi
  /// tetap kompatibel meski struktur respons sedikit berbeda.
  factory NutritionAnalysisResult.fromJson(Map<String, dynamic> json) {
    final dynamic statusValue =
        json['status'] ?? json['nutrition_status'] ?? json['label'];

    // Prioritaskan 'interpretation' dari API AI baru, atau fallback ke 'recommendation/advice/message'
    final dynamic primaryAdvice =
        json['interpretation'] ??
        json['recommendation'] ??
        json['advice'] ??
        json['message'];

    // Tangani list 'recommendations' jika ada
    String recommendationText = '';
    if (primaryAdvice is String && primaryAdvice.isNotEmpty) {
      recommendationText = primaryAdvice;
    }

    final dynamic recommendationsList = json['recommendations'];
    if (recommendationsList is List && recommendationsList.isNotEmpty) {
      final String joinedRecs = recommendationsList.join('\n• ');
      if (recommendationText.isNotEmpty) {
        recommendationText += '\n\nSaran:\n• $joinedRecs';
      } else {
        recommendationText = 'Saran:\n• $joinedRecs';
      }
    }

    return NutritionAnalysisResult(
      status: statusValue is String && statusValue.trim().isNotEmpty
          ? statusValue
          : 'Status tidak tersedia',
      recommendation: recommendationText.isNotEmpty
          ? recommendationText
          : 'Rekomendasi tidak tersedia dari server.',
    );
  }
}

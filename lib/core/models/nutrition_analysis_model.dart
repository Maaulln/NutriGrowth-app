/// Model request untuk endpoint analisis gizi AI.
class NutritionAnalysisRequest {
  const NutritionAnalysisRequest({
    required this.ageMonths,
    required this.gender,
    required this.weightKg,
    required this.heightCm,
    this.muacCm,
    required this.userId,
    required this.childId,
    this.budgetMin = 0,
    this.budgetMax = 50000,
  });

  /// Usia anak dalam bulan.
  final int ageMonths;

  /// Jenis kelamin: 1 = laki-laki, 0 = perempuan (format UI internal).
  final int gender;

  final double weightKg;
  final double heightCm;
  final double? muacCm;
  final int userId;
  final int childId;
  final int budgetMin;
  final int budgetMax;

  /// Mengubah object menjadi JSON body sesuai schema AI server.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'user_id': userId,
      'child_id': childId,
      'child_age_months': ageMonths,
      'gender': gender == 1 ? 'male' : 'female',
      'weight_kg': weightKg,
      'height_cm': heightCm,
      if (muacCm != null) 'muac_cm': muacCm,
      'budget_min': budgetMin,
      'budget_max': budgetMax,
    };
  }
}

/// Model respons hasil analisis gizi dari AI server.
class NutritionAnalysisResult {
  const NutritionAnalysisResult({
    required this.status,
    required this.recommendation,
    required this.riskLevel,
    required this.riskScore,
    required this.summary,
    required this.analysis,
    required this.warningFlags,
  });

  /// Status gizi: 'normal' | 'stunted' | 'severely stunted' | 'tinggi'
  final String status;

  /// Gabungan treatment_recommendations dari AI sebagai teks UI.
  final String recommendation;

  /// Tingkat risiko stunting: 'low' | 'medium' | 'high'
  final String riskLevel;

  /// Skor risiko 0–100.
  final int riskScore;

  /// Ringkasan hasil analisis dari AI.
  final String summary;

  /// Poin-poin analisis detail.
  final List<String> analysis;

  /// Flag klinis yang terdeteksi.
  final List<String> warningFlags;

  /// Parsing JSON respons dari `/analyze` AI server.
  factory NutritionAnalysisResult.fromJson(Map<String, dynamic> json) {
    final statusGizi = json['status_gizi'];
    final status = statusGizi is String && statusGizi.trim().isNotEmpty
        ? statusGizi
        : 'Status tidak tersedia';

    final treatmentList = json['treatment_recommendations'];
    final String recommendation;
    if (treatmentList is List && treatmentList.isNotEmpty) {
      recommendation = '• ${treatmentList.join('\n• ')}';
    } else {
      recommendation = 'Rekomendasi tidak tersedia dari server.';
    }

    final analysisList = json['analysis'];
    final analysis = analysisList is List
        ? List<String>.from(analysisList.whereType<String>())
        : <String>[];

    final flagsList = json['warning_flags'];
    final warningFlags = flagsList is List
        ? List<String>.from(flagsList.whereType<String>())
        : <String>[];

    return NutritionAnalysisResult(
      status: status,
      recommendation: recommendation,
      riskLevel: json['risk_level'] is String ? json['risk_level'] as String : 'low',
      riskScore: json['risk_score'] is int ? json['risk_score'] as int : 0,
      summary: json['summary'] is String ? json['summary'] as String : '',
      analysis: analysis,
      warningFlags: warningFlags,
    );
  }
}

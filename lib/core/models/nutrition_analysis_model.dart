import '../utils/food_image_helper.dart';

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
    this.allergies = const [],
    this.exclusiveBreastfeeding = true,
    this.supplementIntake = 'irregular',
    this.illnessFrequency = 'low',
  });

  final int ageMonths;
  final int gender; // 1 = male, 0 = female
  final double weightKg;
  final double heightCm;
  final double? muacCm;
  final int userId;
  final int childId;
  final int budgetMin;
  final int budgetMax;
  final List<String> allergies;
  final bool exclusiveBreastfeeding;
  final String supplementIntake;   // 'regular' | 'irregular' | 'none'
  final String illnessFrequency;   // 'low' | 'medium' | 'high'

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
      if (allergies.isNotEmpty) 'allergies': allergies,
      'nutrition_history': {
        'exclusive_breastfeeding': exclusiveBreastfeeding,
        'supplement_intake': supplementIntake,
        'illness_frequency': illnessFrequency,
      },
    };
  }
}

/// Satu item rekomendasi makanan dari AI.
class FoodRecommendationItem {
  const FoodRecommendationItem({
    required this.foodName,
    required this.category,
    required this.servingSize,
    required this.estimatedPrice,
    required this.reason,
    this.imageUrl,
  });

  final String foodName;
  final String category;
  final String servingSize;
  final int estimatedPrice;
  final String reason;
  final String? imageUrl;

  /// URL gambar efektif (AI/backend atau fallback Unsplash).
  String get effectiveImageUrl => FoodImageHelper.resolveImageUrl(
        imageUrl: imageUrl,
        name: foodName,
        category: category,
      );

  factory FoodRecommendationItem.fromJson(Map<String, dynamic> json) {
    return FoodRecommendationItem(
      foodName: json['food_name'] as String? ?? '',
      category: json['category'] as String? ?? '',
      servingSize: json['serving_size'] as String? ?? '',
      estimatedPrice: json['estimated_price'] as int? ?? 0,
      reason: json['reason'] as String? ?? '',
      imageUrl: json['image_url'] as String?,
    );
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
    required this.foodSummary,
    required this.foodItems,
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

  /// Ringkasan rekomendasi makanan dari AI.
  final String foodSummary;

  /// Daftar makanan yang direkomendasikan AI.
  final List<FoodRecommendationItem> foodItems;

  /// Parsing JSON respons dari `/analyze` AI server.
  factory NutritionAnalysisResult.fromJson(Map<String, dynamic> json) {
    final statusGizi = json['status_gizi'];
    final status = statusGizi is String && statusGizi.trim().isNotEmpty
        ? statusGizi
        : 'Status unavailable';

    final treatmentList = json['treatment_recommendations'];
    final String recommendation;
    if (treatmentList is List && treatmentList.isNotEmpty) {
      recommendation = '• ${treatmentList.join('\n• ')}';
    } else {
      recommendation = 'Recommendations unavailable from server.';
    }

    final analysisList = json['analysis'];
    final analysis = analysisList is List
        ? List<String>.from(analysisList.whereType<String>())
        : <String>[];

    final flagsList = json['warning_flags'];
    final warningFlags = flagsList is List
        ? List<String>.from(flagsList.whereType<String>())
        : <String>[];

    final foodItemsList = json['food_items'];
    final foodItems = foodItemsList is List
        ? foodItemsList
            .whereType<Map<String, dynamic>>()
            .map(FoodRecommendationItem.fromJson)
            .toList()
        : <FoodRecommendationItem>[];

    return NutritionAnalysisResult(
      status: status,
      recommendation: recommendation,
      riskLevel: json['risk_level'] is String ? json['risk_level'] as String : 'low',
      riskScore: json['risk_score'] is int ? json['risk_score'] as int : 0,
      summary: json['summary'] is String ? json['summary'] as String : '',
      analysis: analysis,
      warningFlags: warningFlags,
      foodSummary: json['food_summary'] is String ? json['food_summary'] as String : '',
      foodItems: foodItems,
    );
  }
}

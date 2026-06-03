class StuntingAssessmentSummary {
  final int id;
  final int? childId;
  final String? statusGizi;
  final String riskLevel;
  final int riskScore;
  final String summary;
  final List<String> recommendations;
  final List<String> warningFlags;
  final DateTime createdAt;

  const StuntingAssessmentSummary({
    required this.id,
    this.childId,
    this.statusGizi,
    required this.riskLevel,
    required this.riskScore,
    required this.summary,
    required this.recommendations,
    required this.warningFlags,
    required this.createdAt,
  });

  factory StuntingAssessmentSummary.fromJson(Map<String, dynamic> json) {
    List<String> toStringList(dynamic value) {
      if (value is List) return value.whereType<String>().toList();
      return [];
    }

    return StuntingAssessmentSummary(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id'].toString()) ?? 0,
      childId: json['child_id'] is int
          ? json['child_id'] as int
          : int.tryParse(json['child_id']?.toString() ?? ''),
      statusGizi: json['status_gizi'] as String?,
      riskLevel: json['risk_level'] as String? ?? 'low',
      riskScore: json['risk_score'] is int ? json['risk_score'] as int : 0,
      summary: json['summary'] as String? ?? '',
      recommendations: toStringList(json['recommendations']),
      warningFlags: toStringList(json['warning_flags']),
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  String get statusLabel {
    switch ((statusGizi ?? '').toLowerCase()) {
      case 'severely stunted':
        return 'Severely Stunted';
      case 'stunted':
        return 'Stunted';
      case 'normal':
        return 'Normal';
      case 'tinggi':
        return 'Tall';
      default:
        return riskLevel == 'low' ? 'Normal' : riskLevel == 'medium' ? 'Needs Attention' : 'At Risk';
    }
  }
}

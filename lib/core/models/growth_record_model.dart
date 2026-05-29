class GrowthRecord {
  final int id;
  final DateTime recordedAt;
  final double? weightKg;
  final double? heightCm;
  final double? muacCm;

  const GrowthRecord({
    required this.id,
    required this.recordedAt,
    this.weightKg,
    this.heightCm,
    this.muacCm,
  });

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }

  factory GrowthRecord.fromJson(Map<String, dynamic> json) {
    return GrowthRecord(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id'].toString()) ?? 0,
      recordedAt: DateTime.tryParse(json['recorded_at']?.toString() ?? '') ?? DateTime.now(),
      weightKg: _parseDouble(json['weight_kg']),
      heightCm: _parseDouble(json['height_cm']),
      muacCm: _parseDouble(json['muac_cm']),
    );
  }
}

class Child {
  final int? id;
  final int userId;
  final String name;
  final String gender;
  final DateTime birthDate;
  final String? imageUrl;
  final double? weightKg;
  final double? heightCm;
  final double? muacCm;

  Child({
    this.id,
    required this.userId,
    required this.name,
    required this.gender,
    required this.birthDate,
    this.imageUrl,
    this.weightKg,
    this.heightCm,
    this.muacCm,
  });

  /// Mengubah nilai dinamis dari JSON menjadi `double?` yang aman.
  static double? _parseNullableDouble(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is num) {
      return value.toDouble();
    }
    return double.tryParse(value.toString());
  }

  factory Child.fromJson(Map<String, dynamic> json) {
    final dynamic idValue = json['id'];
    final dynamic userIdValue = json['user_id'];
    final dynamic nameValue = json['name'];
    final dynamic genderValue = json['gender'];
    final dynamic birthDateValue = json['birth_date'];
    final dynamic imageUrlValue = json['image_url'];

    return Child(
      id: idValue is int ? idValue : int.tryParse(idValue?.toString() ?? ''),
      userId: userIdValue is int
          ? userIdValue
          : int.tryParse(userIdValue?.toString() ?? '') ?? 0,
      name: nameValue?.toString() ?? '',
      gender: genderValue?.toString() ?? 'male',
      birthDate: DateTime.parse(birthDateValue.toString()),
      imageUrl: imageUrlValue?.toString(),
      weightKg: _parseNullableDouble(json['weight_kg']),
      heightCm: _parseNullableDouble(json['height_cm']),
      muacCm: _parseNullableDouble(json['muac_cm']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'gender': gender,
      'birth_date': birthDate.toIso8601String().split('T')[0],
      if (imageUrl != null) 'image_url': imageUrl,
      if (weightKg != null) 'weight_kg': weightKg,
      if (heightCm != null) 'height_cm': heightCm,
      if (muacCm != null) 'muac_cm': muacCm,
    };
  }

  int get ageInMonths {
    final now = DateTime.now();
    return (now.year - birthDate.year) * 12 + (now.month - birthDate.month);
  }

  String get ageFormatted {
    final totalMonths = ageInMonths;
    final years = totalMonths ~/ 12;
    final months = totalMonths % 12;

    if (years > 0) {
      return '$years years $months months';
    }
    return '$months months';
  }

  /// Mengembalikan label gender yang ramah tampilan berdasarkan nilai database.
  String get genderLabel {
    return gender == 'male' ? 'Male' : 'Female';
  }

  /// Menandai apakah data anak adalah laki-laki.
  bool get isMale => gender == 'male';

  /// Format berat badan untuk UI.
  String get weightLabel {
    if (weightKg == null) {
      return '-';
    }
    return weightKg!.toStringAsFixed(1);
  }

  /// Format tinggi badan untuk UI.
  String get heightLabel {
    if (heightCm == null) {
      return '-';
    }
    return heightCm!.toStringAsFixed(1);
  }

  /// Format MUAC untuk UI.
  String get muacLabel {
    if (muacCm == null) {
      return '-';
    }
    return muacCm!.toStringAsFixed(1);
  }
}

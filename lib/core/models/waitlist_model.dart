/// Model data untuk user terdaftar dari API `/api/users`.
class RegisteredUserModel {
  final int? id;
  final String name;
  final String email;
  final String? createdAt;
  final String? updatedAt;

  const RegisteredUserModel({
    this.id,
    required this.name,
    required this.email,
    this.createdAt,
    this.updatedAt,
  });

  factory RegisteredUserModel.fromJson(Map<String, dynamic> json) {
    return RegisteredUserModel(
      id: json['id'] as int?,
      name: json['name'] as String,
      email: json['email'] as String,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
    };
  }
}

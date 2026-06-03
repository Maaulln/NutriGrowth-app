import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/waitlist_model.dart';
import 'api_service.dart';

class UserServiceException implements Exception {
  final String message;
  const UserServiceException(this.message);

  @override
  String toString() => message;
}

/// Service untuk berkomunikasi dengan endpoint `/api/users`.
class UserService {
  UserService._();

  static final UserService _instance = UserService._();
  static UserService get instance => _instance;

  final _client = http.Client();

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  /// Mendaftarkan user baru.
  /// Memanggil POST /api/users dengan { name, email }.
  Future<RegisteredUserModel> registerUser({
    required String name,
    required String email,
  }) async {
    final uri = Uri.parse('${ApiService.baseUrl}/users');

    try {
      final response = await _client
          .post(
            uri,
            headers: _headers,
            body: jsonEncode({'name': name, 'email': email}),
          )
          .timeout(const Duration(seconds: 15));

      final json = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = json['data'] as Map<String, dynamic>? ?? json;
        return RegisteredUserModel.fromJson(data);
      }

      final errorMsg = json['message'] as String? ??
          json['error'] as String? ??
          'A server error occurred.';
      throw UserServiceException(errorMsg);
    } on UserServiceException {
      rethrow;
    } catch (e) {
      throw const UserServiceException(
        'Cannot connect to server. Ensure the server is running.',
      );
    }
  }

  /// Mengambil semua user terdaftar.
  /// Memanggil GET /api/users.
  Future<List<RegisteredUserModel>> getUsers() async {
    final uri = Uri.parse('${ApiService.baseUrl}/users');

    try {
      final response = await _client
          .get(uri, headers: _headers)
          .timeout(const Duration(seconds: 15));

      final json = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final List<dynamic> list = json is List ? json : (json['data'] as List);
        return list
            .map((item) =>
                RegisteredUserModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }

      final errorMsg =
          (json as Map)['message'] as String? ?? 'Failed to fetch user data.';
      throw UserServiceException(errorMsg);
    } on UserServiceException {
      rethrow;
    } catch (e) {
      throw const UserServiceException(
        'Cannot connect to server. Ensure the server is running.',
      );
    }
  }
}

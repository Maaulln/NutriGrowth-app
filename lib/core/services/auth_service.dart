import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import 'api_service.dart';

/// Error khusus untuk kegagalan proses autentikasi.
class AuthException implements Exception {
  final String message;

  /// Membuat error autentikasi dengan pesan yang akan ditampilkan ke UI.
  ///
  /// [message] adalah deskripsi kegagalan dari server atau validasi lokal.
  const AuthException(this.message);

  @override
  /// Mengembalikan pesan error agar mudah ditampilkan ke UI atau log.
  String toString() => message;
}

/// Service untuk register, login, logout, dan pengelolaan session autentikasi.
class AuthService {
  /// Membuat instance service autentikasi sebagai singleton.
  AuthService._();

  static final AuthService _instance = AuthService._();
  static AuthService get instance => _instance;

  static const _tokenKey = 'auth_token';
  static const _userNameKey = 'user_name';
  static const _userEmailKey = 'user_email';
  static const _userIdKey = 'user_id';

  final _client = http.Client();

  /// Header standar untuk request JSON ke backend.
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  /// Header request yang menyertakan token Bearer untuk endpoint terlindungi.
  Map<String, String> _authHeaders(String token) => {
    ..._headers,
    'Authorization': 'Bearer $token',
  };

  // ── Token & Session ──────────────────────────────────────────────────────

  /// Menyimpan token dan data user ke penyimpanan lokal.
  ///
  /// [user] berisi data hasil login atau register yang sudah valid.
  Future<void> _saveSession(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, user.token);
    await prefs.setInt(_userIdKey, user.id);
    await prefs.setString(_userNameKey, user.name);
    await prefs.setString(_userEmailKey, user.email);
  }

  /// Menghapus seluruh data session yang tersimpan di perangkat.
  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userIdKey);
    await prefs.remove(_userNameKey);
    await prefs.remove(_userEmailKey);
  }

  /// Mengambil token autentikasi yang tersimpan di perangkat.
  ///
  /// Hasilnya `null` jika pengguna belum pernah login.
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  /// Mengecek apakah sesi login masih aktif berdasarkan token lokal.
  ///
  /// Mengembalikan `true` jika token tersedia dan tidak kosong.
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  /// Mengambil data user yang sudah disimpan sebelumnya.
  ///
  /// Mengembalikan `null` jika salah satu data session tidak lengkap.
  Future<UserModel?> getSavedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    final id = prefs.getInt(_userIdKey);
    final name = prefs.getString(_userNameKey);
    final email = prefs.getString(_userEmailKey);
    if (token == null || id == null || name == null || email == null) {
      return null;
    }
    return UserModel(id: id, name: name, email: email, token: token);
  }

  // ── Register ─────────────────────────────────────────────────────────────

  /// Mengirim data registrasi ke backend untuk membuat akun baru.
  ///
  /// [name], [email], [password], dan [passwordConfirmation] akan dikirim
  /// dalam format JSON ke endpoint register.
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    final uri = Uri.parse('${ApiService.baseUrl}/auth/register');

    try {
      // Request POST ke backend untuk membuat akun baru.
      final response = await _client
          .post(
            uri,
            headers: _headers,
            body: jsonEncode({
              'name': name,
              'email': email,
              'password': password,
              'password_confirmation': passwordConfirmation,
            }),
          )
          .timeout(const Duration(seconds: 15));

      final json = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 201 || response.statusCode == 200) {
        final token = json['token'] as String;
        final userData = json['user'] as Map<String, dynamic>;
        final user = UserModel.fromJson(userData, token: token);
        await _saveSession(user);
        return user;
      }

      final errorMsg =
          json['error'] as String? ??
          json['message'] as String? ??
          'Terjadi kesalahan pada server.';
      throw AuthException(errorMsg);
    } on AuthException {
      rethrow;
    } catch (_) {
      throw const AuthException(
        'Tidak dapat terhubung ke server. Pastikan server sedang berjalan.',
      );
    }
  }

  // ── Login ─────────────────────────────────────────────────────────────────

  /// Mengirim kredensial login ke backend untuk mendapatkan token akses.
  ///
  /// [email] dan [password] akan divalidasi oleh server.
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final uri = Uri.parse('${ApiService.baseUrl}/auth/login');

    try {
      // Request POST ke backend untuk memverifikasi email dan password.
      final response = await _client
          .post(
            uri,
            headers: _headers,
            body: jsonEncode({'email': email, 'password': password}),
          )
          .timeout(const Duration(seconds: 15));

      final json = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        final token = json['token'] as String;
        final userData = json['user'] as Map<String, dynamic>;
        final user = UserModel.fromJson(userData, token: token);
        await _saveSession(user);
        return user;
      }

      final errorMsg =
          json['error'] as String? ??
          json['message'] as String? ??
          'Terjadi kesalahan pada server.';
      throw AuthException(errorMsg);
    } on AuthException {
      rethrow;
    } catch (_) {
      throw const AuthException(
        'Tidak dapat terhubung ke server. Pastikan server sedang berjalan.',
      );
    }
  }

  // ── Logout ────────────────────────────────────────────────────────────────

  /// Mengakhiri sesi login di server dan menghapus session lokal.
  ///
  /// Jika request ke server gagal, session lokal tetap dibersihkan.
  Future<void> logout() async {
    final token = await getToken();
    if (token != null) {
      try {
        final uri = Uri.parse('${ApiService.baseUrl}/auth/logout');
        // Request POST ke backend untuk memutus sesi Bearer token.
        await _client
            .post(uri, headers: _authHeaders(token))
            .timeout(const Duration(seconds: 10));
      } catch (_) {
        // Tetap lanjutkan clear local session meski request gagal.
      }
    }
    await clearSession();
  }
}

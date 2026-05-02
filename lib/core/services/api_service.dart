import 'package:flutter/foundation.dart';

/// Konfigurasi base URL untuk setiap platform.
///
/// Endpoint yang digunakan:
///   POST   /api/users  → Daftar user baru
///   GET    /api/users  → List semua user
///
/// Platform URL mapping:
/// - Android Emulator : 10.0.2.2  (localhost dari perspektif emulator)
/// - iOS Simulator    : localhost
/// - Web              : localhost
/// - Device Fisik     : ganti dengan IP mesin Anda, contoh: 192.168.1.10
class ApiService {
  ApiService._();

  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:8080/api';
    }

    // Defaulting ke 10.0.2.2 (Android Emulator).
    // Jika pakai iOS Simulator atau device fisik, ganti nilai ini.
    return 'http://10.0.2.2:8080/api';
  }
}

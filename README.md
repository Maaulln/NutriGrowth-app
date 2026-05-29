# NutriGrowth App

Aplikasi mobile untuk pemantauan gizi dan pertumbuhan anak. Dibangun dengan **Flutter** — berjalan di iOS, Android, dan Web.

---

## Tech Stack

| Layer | Teknologi |
|---|---|
| Framework | Flutter / Dart |
| HTTP Client | `http` package |
| Session Storage | `shared_preferences` |
| UI Fonts | Google Fonts |
| Vector Assets | flutter_svg |
| Image Picker | image_picker |

---

## Prasyarat

- Flutter SDK >= 3.11.4
- Dart SDK >= 3.11.4
- Android Studio / Xcode (untuk emulator/simulator)
- NutriGrowth Backend berjalan di port 8080
- NutriGrowth AI Service berjalan di port 8000 (opsional, untuk analisis gizi)

---

## Setup

### 1. Install dependencies

```bash
flutter pub get
```

### 2. Konfigurasi API URL

Edit `lib/core/services/api_service.dart`:

```dart
static String get baseUrl {
  if (kIsWeb) return 'http://localhost:8080/api';
  return 'http://10.0.2.2:8080/api'; // Android Emulator
  // iOS Simulator / device fisik: ganti dengan IP komputer Anda
  // return 'http://192.168.x.x:8080/api';
}
```

### 3. Jalankan aplikasi

```bash
# Android Emulator
flutter run

# iOS Simulator
flutter run -d iPhone

# Web browser
flutter run -d chrome

# Dengan custom API host (AI service)
flutter run --dart-define=NUTRIGROWTH_API_HOST=http://192.168.x.x:8000
```

---

## Fitur

| Fitur | Deskripsi |
|---|---|
| Autentikasi | Login, register, logout dengan Sanctum token |
| Profil Anak | Tambah, lihat, dan kelola data anak |
| Analisis Gizi | Input antropometri → analisis status gizi via AI |
| Daftar Makanan | Browse, filter kategori, cari, dan lihat detail makanan |
| Foto | Ambil foto anak via kamera |
| Waitlist | Daftar waitlist produk |

---

## Screens

```
Login / Register
└── MainWrapper (bottom nav)
    ├── Home         — dashboard ringkasan (daily tip, profil anak, tren berat)
    ├── Analysis     — form input + hasil analisis gizi AI
    ├── Food         — katalog makanan bergizi
    └── Photo        — kamera untuk foto anak
```

---

## Koneksi API

Aplikasi terhubung ke **dua** service:

### 1. NutriGrowth Backend (Laravel)

```
Base URL: http://10.0.2.2:8080/api  (Android emulator)
          http://localhost:8080/api  (Web)

Endpoints yang digunakan:
  POST /api/auth/register
  POST /api/auth/login
  POST /api/auth/logout
  GET  /api/auth/me
  GET/POST/PUT/DELETE /api/children
  GET  /api/foods
  GET  /api/foods/{id}
  POST /api/waitlist
```

### 2. NutriGrowth AI Service (Python/FastAPI)

```
Base URL: http://10.0.2.2:8000  (default)
          Atau via --dart-define=NUTRIGROWTH_API_HOST=...

Endpoints yang digunakan:
  GET  /health
  POST /api/v1/nutrition/analyze
  POST /api/v1/food/recommend
```

---

## Struktur Folder

```
lib/
├── main.dart
├── core/
│   ├── constants/
│   │   └── app_colors.dart
│   ├── models/
│   │   ├── user_model.dart
│   │   ├── child_model.dart
│   │   ├── food_model.dart
│   │   ├── nutrition_analysis_model.dart
│   │   └── waitlist_model.dart
│   ├── services/
│   │   ├── api_service.dart          — konfigurasi base URL
│   │   ├── auth_service.dart         — login, register, logout
│   │   ├── child_service.dart        — CRUD anak
│   │   ├── food_service.dart         — daftar makanan
│   │   ├── nutrition_ai_service.dart — analisis gizi via AI
│   │   └── waitlist_service.dart     — submit waitlist
│   └── theme/
│       └── app_theme.dart
├── screens/
│   ├── auth/
│   │   ├── login_screen.dart
│   │   └── register_screen.dart
│   ├── home_screen.dart
│   ├── analysis_screen.dart
│   ├── food_screen.dart
│   ├── food_detail_screen.dart
│   ├── photo_screen.dart
│   ├── children_screen.dart
│   ├── add_child_screen.dart
│   ├── child_profile_screen.dart
│   ├── waitlist_screen.dart
│   └── main_wrapper.dart
└── widgets/
    ├── home/
    ├── analysis/
    ├── food/
    └── photo/
```

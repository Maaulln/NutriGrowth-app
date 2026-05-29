# NutriGrowth App — Architecture

## Gambaran Sistem

```
┌──────────────────────────────────────────────────────────┐
│                    NutriGrowth App                       │
│                   Flutter / Dart                         │
│                                                          │
│  Screens → Widgets → Services → HTTP (dart:http)         │
│                                                          │
│  Session: SharedPreferences (token Sanctum)              │
└────────────────┬───────────────────────┬─────────────────┘
                 │                       │
       port 8080 │               port 8000│
                 ▼                       ▼
   ┌─────────────────────┐   ┌──────────────────────┐
   │  NutriGrowth        │   │  NutriGrowth         │
   │  Backend            │   │  AI Service          │
   │  Laravel 10         │   │  Python / FastAPI    │
   │  + Supabase         │   │  XGBoost + LightGBM  │
   └─────────────────────┘   └──────────────────────┘
```

---

## Pola Arsitektur

Aplikasi mengikuti pola **Service Layer** sederhana (bukan full BLoC/Provider):

```
Screen
  └── memanggil Service (async)
        └── HTTP request via dart:http
              └── parse JSON → Model
                    └── return ke Screen → setState / rebuild
```

Tidak menggunakan state management library besar (Provider, Riverpod, BLoC) — state dikelola langsung di dalam `StatefulWidget`.

---

## Layer Aplikasi

### 1. Models (`core/models/`)

Plain Dart classes dengan `fromJson()` / `toJson()`:

| Model | Deskripsi |
|---|---|
| `UserModel` | Data user dari `/api/auth/me` |
| `ChildModel` | Data anak dari `/api/children` |
| `FoodModel` | Data makanan dari `/api/foods` |
| `NutritionAnalysisModel` | Request & result analisis AI |
| `WaitlistModel` | Payload submit waitlist |

### 2. Services (`core/services/`)

| Service | Tanggung Jawab |
|---|---|
| `ApiService` | Konfigurasi base URL backend & AI |
| `AuthService` | Register, login, logout, simpan token ke SharedPreferences |
| `ChildService` | CRUD anak via `Authorization: Bearer <token>` |
| `FoodService` | Fetch daftar dan detail makanan |
| `NutritionAiService` | POST ke AI endpoint, parse NutritionAnalysisResult |
| `WaitlistService` | Submit form waitlist |

### 3. Screens (`screens/`)

Setiap screen adalah `StatefulWidget` yang mengakses service secara langsung.

### 4. Widgets (`widgets/`)

Komponen UI reusable yang dikelompokkan per fitur: `home/`, `analysis/`, `food/`, `photo/`.

---

## Alur Autentikasi

```
LoginScreen
  → AuthService.login(email, password)
  → POST /api/auth/login
  → Response: { token, user }
  → SharedPreferences.setString('token', token)
  → SharedPreferences.setString('user', jsonEncode(user))
  → Navigator → MainWrapper

Request berikutnya:
  → SharedPreferences.getString('token')
  → Header: Authorization: Bearer <token>

Logout:
  → AuthService.logout()
  → POST /api/auth/logout (revoke server-side)
  → SharedPreferences.clear()
  → Navigator → LoginScreen
```

---

## Alur Analisis Gizi

```
AnalysisScreen
  → User isi form: age_months, gender, weight_kg, height_cm, muac_cm
  → NutritionAiService.analyzeNutrition(request)
  → POST http://10.0.2.2:8000/api/v1/nutrition/analyze
     Body: { age_months, gender, weight_kg, height_cm, muac_cm }
  → Response: { status_gizi, rekomendasi, ... }
  → NutritionAnalysisResult.fromJson()
  → Tampilkan hasil di AnalysisScreen
```

---

## Konfigurasi URL

```dart
// lib/core/services/api_service.dart

// Backend (Laravel)
static String get baseUrl {
  if (kIsWeb) return 'http://localhost:8080/api';
  return 'http://10.0.2.2:8080/api'; // Android Emulator
}

// AI Service (FastAPI) — dapat di-override via --dart-define
static String get aiBaseUrl {
  if (_aiHostEnv.isNotEmpty) return _aiHostEnv; // dart-define priority
  if (kIsWeb) return 'http://localhost:8000';
  return 'http://10.0.2.2:8000';
}
```

Untuk device fisik, override saat build:
```bash
flutter run --dart-define=NUTRIGROWTH_API_HOST=http://192.168.1.x:8000
```

---

## Navigasi

```
main.dart
  └── MaterialApp
        ├── LoginScreen (initial route)
        └── MainWrapper (setelah login)
              └── BottomNavigationBar
                    ├── [0] HomeScreen
                    ├── [1] AnalysisScreen
                    ├── [2] FoodScreen
                    └── [3] PhotoScreen

Modal/Push routes:
  HomeScreen      → ChildProfileScreen
  FoodScreen      → FoodDetailScreen
  ChildrenScreen  → AddChildScreen
  Navbar          → WaitlistScreen
```

---

## Session Storage

Menggunakan `SharedPreferences` untuk persistensi token:

| Key | Value |
|---|---|
| `token` | Bearer token dari Sanctum |
| `user` | JSON string data user (id, name, email) |

Token dikirim di setiap request ke backend sebagai `Authorization: Bearer <token>`. Token ke AI service dikirim jika `API_KEY` di-set via `--dart-define`.

---

## Platform Support

| Platform | Status | Catatan |
|---|---|---|
| Android | Aktif | Emulator: `10.0.2.2`, device fisik: IP lokal |
| iOS | Aktif | Simulator: `localhost`, device: IP lokal |
| Web | Aktif | `localhost` langsung |
| macOS / Windows / Linux | Build tersedia | Belum di-test |

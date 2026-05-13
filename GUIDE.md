## NutriGrowth System Guide (Android + Website + AI Model)

## 1. Tujuan Dokumen
Dokumen ini menjelaskan alur proyek NutriGrowth secara end-to-end agar developer dan AI agent memahami hubungan antara 3 komponen utama:
1. Android App (Flutter)
2. Website App (Frontend React + Backend Laravel)
3. AI Model API (FastAPI + XGBoost + LightGBM)

---

## 2. Struktur Repositori dan Peran

### 2.1 Android App
Lokasi:
- /Users/maaullntech/Documents/COde/NutriGrowth-app

Peran:
- Aplikasi mobile utama.
- Mengelola auth, data user, dan fitur analisis.
- Mengirim data antropometri ke AI Model API untuk inference status gizi.

Komponen penting:
- Service API umum: lib/core/services/api_service.dart
- Service analisis AI: lib/core/services/nutrition_ai_service.dart
- Screen analisis: lib/screens/analysis_screen.dart

### 2.2 Web & Backend System
Lokasi:
- Web Frontend (React): /Users/maaullntech/Documents/COde/nutrigrowth-web
- Core Backend (Laravel) & DB: /Users/maaullntech/Documents/COde/nutrigrowth-backend

Peran:
- Landing page dan Dashboard (nutrigrowth-web).
- Backend API (nutrigrowth-backend) menangani logic bisnis utama dan data persistence.
- Database SQLite tersimpan di dalam folder backend.

Struktur:
- Frontend: nutrigrowth-web
- Backend: nutrigrowth-backend

Contoh alur aktif:
- Frontend CTA form mengirim POST ke endpoint users di backend Laravel.

### 2.3 AI Model API
Lokasi:
- /Users/maaullntech/Documents/COde/nutrigrowth-ai

Peran:
- Menjalankan model machine learning untuk:
1. Analisis status gizi (XGBoost)
2. Rekomendasi makanan (LightGBM)
- Menyediakan endpoint inference terpisah dari backend Laravel.

File penting:
- FastAPI entrypoint: api/main.py
- Router nutrition: api/routers/nutrition.py
- Router food: api/routers/food_recommendation.py

---

## 3. Arsitektur Tingkat Tinggi

Ada 2 jalur backend yang berbeda:
1. Backend Laravel untuk fitur aplikasi umum (auth, users, waitlist, dsb).
2. Backend FastAPI AI untuk inference model ML.

Prinsip penting:
- Jangan mencampur endpoint Laravel dengan endpoint AI.
- Android/Web dapat memanggil keduanya sesuai kebutuhan fitur.
- Gunakan environment variable untuk host dan token, jangan hardcode.

---

## 4. Alur Data End-to-End

### 4.1 Alur Website Waitlist/User (Saat Ini)
1. User submit form di frontend React.
2. Frontend kirim request ke backend Laravel.
3. Laravel validasi data dan simpan ke DB.
4. Laravel kirim response sukses/gagal.
5. Frontend tampilkan notifikasi hasil.

### 4.2 Alur Analisis Gizi (Android ke AI)
1. User isi data umur, gender, berat, tinggi, MUAC di aplikasi Android.
2. Android memanggil endpoint POST /api/v1/nutrition/analyze ke AI API.
3. AI service memproses dengan model XGBoost.
4. API mengembalikan status gizi, confidence, interpretasi, dan rekomendasi.
5. Android menampilkan hasil analisis ke UI.

### 4.3 Alur Rekomendasi Makanan (Client ke AI)
1. Client mengirim profil anak + status gizi + budget.
2. AI service memproses ranking makanan dengan LightGBM.
3. API mengembalikan daftar rekomendasi + estimasi biaya + coverage nutrisi.
4. Client menampilkan hasil rekomendasi.

---

## 5. Kontrak Endpoint AI

### 5.1 Health
- GET /health
- GET /api/health
- GET /api/v1/nutrition/health
- GET /api/v1/food/health

### 5.2 Nutrition Analysis
- POST /api/v1/nutrition/analyze

Request minimal:
- age_months (int)
- gender (0 atau 1)
- weight_kg (float)
- height_cm (float)
- muac_cm (float)

Response penting:
- status
- confidence
- interpretation
- severity
- recommendations

### 5.3 Food Recommendation
- POST /api/v1/food/recommend

Request minimal:
- age_months
- gender
- nutrition_status
- daily_budget_idr
- preferred_categories (opsional)
- excluded_foods (opsional)

Response penting:
- recommendations
- total_estimated_cost_idr
- nutrition_coverage_pct
- meal_plan_note
- budget_fit

### 5.4 Food List
- GET /api/v1/food/list
- Query opsional: category, age_months, max_price, limit

---

## 6. Konfigurasi Environment

### 6.1 Android Flutter
Gunakan dart-define:
- NUTRIGROWTH_API_HOST untuk host AI API
- API_KEY untuk bearer token (jika AI API pakai auth)

Catatan:
- Emulator Android biasanya gunakan host 10.0.2.2.
- Web/iOS simulator biasanya localhost.
- Pastikan port tidak bentrok dengan Laravel.

### 6.2 Website Frontend
- Simpan base URL backend Laravel di environment frontend.
- Hindari hardcoded URL endpoint di komponen.

### 6.3 AI API (FastAPI)
- Jalankan service AI terpisah dari Laravel.
- Pastikan CORS sesuai environment (dev vs production).

---

## 7. Port dan Routing Strategy

Karena Laravel dan FastAPI sama-sama sering memakai port 8000, wajib atur port agar tidak bentrok.

Rekomendasi sederhana:
1. Laravel di 8080
2. FastAPI AI di 8000 atau 7000
3. Frontend Vite di 5173

Jika port diubah:
- Update environment variable client.
- Jangan ubah logic bisnis, hanya host/port config.

---

## 8. Batas Tanggung Jawab (Rule untuk AI Agent)

AI agent wajib memahami:
1. Laravel backend:
- Auth/register/login/logout
- CRUD user/waitlist
- Database application

2. FastAPI AI:
- Inference nutrition
- Inference food recommendation
- Data/model serving

3. Flutter/React client:
- Validasi input dasar
- API call + error handling
- Menampilkan hasil ke UI

Larangan:
- Jangan pindahkan logic model ke Laravel/frontend.
- Jangan hardcode API key atau host production.
- Jangan skip error handling untuk request API.

---

## 9. Best Practices Integrasi

1. Validasi payload di sisi client sebelum request.
2. Terapkan timeout dan fallback message pada semua API call.
3. Tangani HTTP error:
- 400: payload invalid
- 401/403: auth/token invalid
- 500: server/model issue
4. Tambahkan logging ringkas pada layer service.
5. Gunakan retry terbatas untuk error jaringan sementara.

---

## 10. Checklist Integrasi

### Android
- Sudah pakai host AI via environment.
- Analisis gizi tidak dummy, sudah call AI endpoint.
- Error dari API tampil user-friendly.

### Website
- Frontend endpoint tidak hardcoded permanen.
- Endpoint mengarah ke backend Laravel yang benar.
- Form response handling sukses/gagal jelas.

### AI API
- Endpoint health berjalan.
- Model file berhasil di-load saat startup.
- Endpoint analyze dan recommend mengembalikan response valid.

---

## 11. Runbook Singkat Development

1. Jalankan backend Laravel website.
2. Jalankan frontend React website.
3. Jalankan AI FastAPI.
4. Jalankan Android app dengan host AI sesuai target device/emulator.
5. Uji:
- Website waitlist flow
- Android nutrition analysis flow
- AI health endpoints

---

## 12. Definisi Sukses

Proyek dianggap terintegrasi dengan baik jika:
1. Website flow tetap normal melalui Laravel.
2. Android berhasil memanggil AI model dan menampilkan hasil real.
3. Konfigurasi endpoint bisa dipindah antar environment tanpa ubah kode inti.
4. Tidak ada bentrok peran antara Laravel API dan FastAPI AI API.
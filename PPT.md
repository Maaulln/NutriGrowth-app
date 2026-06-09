# NutriGrowth — Slide Deck Blueprint

> Gunakan dokumen ini sebagai acuan konten saat membuat presentasi (PowerPoint / Google Slides / Canva).
> Setiap slide diberi judul, poin-poin utama, dan catatan pembicara.

---

## SLIDE 1 — Cover

**Judul:** NutriGrowth
**Sub-judul:** Aplikasi Pemantauan Gizi & Tumbuh Kembang Anak Berbasis AI
**Visual:** Logo + ilustrasi anak sehat / background hijau gradasi (#4CAF82)
**Catatan:** Perkenalkan nama tim dan tanggal presentasi.

---

## SLIDE 2 — Latar Belakang & Masalah

**Judul:** Mengapa NutriGrowth?

- Stunting masih menjadi masalah gizi utama di Indonesia
- Orang tua kesulitan memantau pertumbuhan anak secara berkala
- Akses ke ahli gizi terbatas, terutama di daerah dengan fasilitas kesehatan minim
- Tidak ada platform terintegrasi yang menggabungkan pemantauan pertumbuhan + rekomendasi makanan terjangkau

**Catatan:** Sertakan statistik stunting nasional terbaru (Kemenkes / SSGI) untuk memperkuat urgensi.

---

## SLIDE 3 — Solusi

**Judul:** NutriGrowth sebagai Solusi

- Aplikasi mobile Flutter (Android & iOS) untuk orang tua
- Pemantauan pertumbuhan anak: berat badan, tinggi badan, MUAC
- Analisis risiko stunting berbasis AI (machine learning)
- Rekomendasi makanan bergizi sesuai usia & budget keluarga
- Dashboard visual: grafik tren berat badan & nutrisi mingguan

---

## SLIDE 4 — Fitur Utama

**Judul:** Fitur Aplikasi

| Fitur | Deskripsi |
|---|---|
| Profil Anak | Data lengkap: nama, usia, gender, alergi, riwayat ASI |
| Analisis AI | Deteksi risiko stunting (low / medium / high) dengan skor 0–100 |
| Rekomendasi Makanan | Daftar makanan + harga estimasi sesuai budget |
| Grafik Tren | Weight trend & weekly nutrition chart |
| Daily Tips | Tips gizi harian untuk orang tua |
| Multi-Anak | Satu akun dapat memantau lebih dari satu anak |

---

## SLIDE 5 — Alur Penggunaan Aplikasi

**Judul:** Cara Kerja NutriGrowth

```
Login / Register
      ↓
Tambah Profil Anak
(nama, TTL, gender, berat, tinggi, MUAC, alergi)
      ↓
Pilih Anak Aktif di Dashboard
      ↓
Jalankan Analisis Gizi
(input budget, data antropometri dikirim ke AI server)
      ↓
Terima Hasil: Status Gizi + Skor Risiko + Rekomendasi
      ↓
Pantau Tren di Home (grafik berat & nutrisi)
```

---

## SLIDE 6 — Arsitektur Sistem

**Judul:** Arsitektur Teknis

```
┌──────────────┐        REST API        ┌──────────────────────────┐
│  Flutter App │ ──────────────────────▶│  Backend Server          │
│  (Mobile)    │◀────────────────────── │  AWS EC2 / ECS           │
└──────────────┘                        └──────────┬───────────────┘
       │                                           │
       │                              ┌────────────┴────────────┐
       │                              │                         │
       │                              ▼                         ▼
       │                    ┌──────────────────┐    ┌──────────────────┐
       │    AI Endpoint     │  AI Server       │    │  Supabase        │
       └───────────────────▶│  AWS (Python)    │    │  (PostgreSQL DB) │
                            │  Stunting Model  │    │  Auth + Storage  │
                            └──────────────────┘    └──────────────────┘
```

- **Frontend:** Flutter + Riverpod (state management)
- **Backend API:** REST di AWS — autentikasi JWT, manajemen data anak
- **AI Server:** Python di AWS — endpoint `/analyze` untuk klasifikasi stunting
- **Database:** Supabase (PostgreSQL managed) — data user, anak, riwayat analisis
- **Storage:** Cached Network Image, SharedPreferences

---

## SLIDE 7 — Teknologi yang Digunakan

**Judul:** Tech Stack

**Mobile (Flutter)**
- Flutter SDK ^3.11 / Dart
- `flutter_riverpod` 2.6.1 — state management
- `http` — komunikasi REST
- `cached_network_image` — caching gambar makanan
- `shared_preferences` — persistensi lokal
- `google_fonts`, `flutter_svg` — UI/theming

### Backend & AI (AWS)

- Backend Server di **AWS** (EC2 / ECS) — REST API dengan autentikasi Bearer Token (JWT)
- AI Server **Python** di AWS — endpoint `/analyze` untuk analisis & klasifikasi stunting
- Model output: `status_gizi`, `risk_level`, `risk_score`, `treatment_recommendations`, `food_items`

### Database & Storage

- **Supabase** (PostgreSQL managed) — menyimpan data user, profil anak, riwayat analisis
- Supabase Auth — manajemen autentikasi & session
- Supabase Storage — penyimpanan aset/gambar jika diperlukan

---

## SLIDE 8 — Model Data Utama

**Judul:** Struktur Data Anak & Analisis

**Child Model** (data yang dipantau):
- `name`, `gender`, `birthDate`
- `weightKg`, `heightCm`, `muacCm`
- `allergies[]`, `exclusiveBreastfeeding`
- `supplementIntake`, `illnessFrequency`

**NutritionAnalysisResult** (output AI):
- `status` — Normal / Stunted / Severely Stunted / Tinggi
- `riskLevel` — low / medium / high
- `riskScore` — 0 sampai 100
- `analysis[]` — poin-poin analisis detail
- `warningFlags[]` — flag klinis yang terdeteksi
- `foodItems[]` — rekomendasi makanan + harga + alasan

---

## SLIDE 9 — Tampilan Aplikasi (Screenshots)

**Judul:** UI NutriGrowth

*(Tambahkan screenshot aktual dari emulator/device di sini)*

- **Home Screen** — profil anak aktif, weight trend chart, weekly nutrition, last check-up
- **Analisis Screen** — form input antropometri & budget → hasil AI
- **Rekomendasi Makanan** — kartu makanan dengan gambar, harga, & alasan
- **Children Screen** — daftar semua anak yang dipantau
- **Food Screen** — katalog makanan

---

## SLIDE 10 — Hasil Analisis AI

**Judul:** Output Analisis Gizi AI

**Input yang dikirim ke AI:**
- Usia (bulan), gender, berat, tinggi, MUAC
- Budget min–max, alergi, riwayat ASI, frekuensi sakit

**Output yang diterima:**
- Status gizi + tingkat risiko stunting + skor numerik
- Ringkasan kondisi anak
- Poin-poin analisis klinis
- Warning flags (misal: berat badan rendah, MUAC di bawah ambang)
- 5–10 rekomendasi makanan dengan harga & porsi

---

## SLIDE 11 — Keunggulan Kompetitif

**Judul:** Keunggulan NutriGrowth

| Aspek | NutriGrowth | Aplikasi Serupa |
|---|---|---|
| Analisis AI stunting | ✅ Skor + level risiko | ❌ Tidak ada |
| Rekomendasi makanan + harga | ✅ Sesuai budget | ❌ Generik |
| Multi-anak dalam 1 akun | ✅ | Terbatas |
| Offline-friendly (cache) | ✅ | ❌ |
| Grafik tren pertumbuhan | ✅ | Sebagian |

---

## SLIDE 12 — Target Pengguna

**Judul:** Siapa Pengguna NutriGrowth?

- **Orang tua** dengan anak usia 0–5 tahun (1000 hari pertama kehidupan)
- **Kader Posyandu** yang memantau tumbuh kembang anak di komunitas
- **Puskesmas / Bidan** sebagai alat bantu skrining awal stunting
- Fokus segmen: **keluarga menengah ke bawah** yang sensitif terhadap harga makanan

---

## SLIDE 13 — Rencana Pengembangan

**Judul:** Roadmap

**Versi 1.0 (Saat Ini)**
- Login & manajemen profil anak
- Analisis gizi berbasis AI
- Rekomendasi makanan
- Dashboard tren pertumbuhan

**Versi 1.x (Mendatang)**
- Notifikasi jadwal check-up & pengingat makan
- Integrasi data Posyandu
- Mode offline penuh
- Export laporan PDF untuk dokter/bidan
- Multi-bahasa (Indonesia / Inggris)

---

## SLIDE 14 — Penutup & Demo

**Judul:** Kesimpulan

- NutriGrowth menghadirkan **deteksi dini stunting** langsung di genggaman orang tua
- Menggabungkan **pemantauan pertumbuhan + rekomendasi AI + edukasi gizi** dalam satu platform
- Dibangun dengan Flutter + Riverpod untuk pengalaman yang **cepat, responsif, dan mudah digunakan**

**Call to Action:**
> "Bersama NutriGrowth, setiap anak berhak tumbuh sehat."

*(Lanjutkan ke sesi demo live aplikasi)*

---

## SLIDE 15 — Q&A

**Judul:** Tanya Jawab

*(Halaman kosong dengan branding)*

---

## Panduan Desain Slide

| Elemen | Spesifikasi |
|---|---|
| Warna utama | `#4CAF82` (hijau NutriGrowth) |
| Warna aksen | `#1A2E2A` (teks gelap) |
| Background | `#F7FBF9` (hijau sangat muda) |
| Font heading | Google Fonts — **Nunito** atau **Poppins** Bold |
| Font body | **Nunito** Regular / 14–16pt |
| Logo | Gunakan aset dari `assets/` di repo |
| Rasio slide | 16:9 |
| Jumlah slide | 15 slide (dapat diperluas sesuai kebutuhan) |

# Dokumentasi Proyek NutriGrowth

Dokumen ini merangkum bagian-bagian yang sudah dibuat di aplikasi NutriGrowth dan struktur folder `lib` secara rinci.

## Ringkasan Fitur yang Sudah Dibuat

Aplikasi ini sudah memiliki beberapa bagian utama berikut:

1. Autentikasi pengguna.
   - Halaman login.
   - Halaman register.
   - Penyimpanan session login menggunakan `SharedPreferences`.
   - Logout dan penghapusan session lokal.

2. Navigasi utama aplikasi.
   - `MainWrapper` sebagai wadah halaman utama.
   - Bottom navigation untuk berpindah antar menu.
   - Halaman utama yang menampilkan 4 tab utama: Home, Analysis, Food, dan Photo.

3. Halaman Home.
   - Header utama.
   - Kartu daily tip.
   - Kartu profil anak.
   - Kartu tren berat badan.
   - Kartu nutrisi mingguan.
   - Kartu last check-up.

4. Halaman Analysis.
   - Form input umur, berat badan, tinggi badan, dan MUAC.
   - Validasi input dasar.
   - Proses analisis sederhana untuk menampilkan status pertumbuhan.
   - Hasil analisis beserta rekomendasi.

5. Halaman Food.
   - Daftar makanan dengan gambar, kalori, protein, dan kategori.
   - Filter kategori makanan.
   - Pencarian makanan berdasarkan judul atau deskripsi.
   - Halaman detail makanan.

6. Halaman Photo.
   - Ambil foto dari kamera.
   - Tampilkan hasil foto yang diambil.
   - Instruksi penggunaan kamera.

7. Halaman waitlist.
   - Form pendaftaran waitlist.
   - Validasi input nama dan email.
   - Animasi tampilan saat halaman dibuka.

8. Arsitektur pendukung.
   - Service untuk autentikasi.
   - Service untuk waitlist user.
   - Konfigurasi API base URL.
   - Model data user.
   - Theme aplikasi.
   - Kumpulan widget reusable.

## Tree Struktur Folder `lib`

```text
lib/
├── main.dart
├── core/
│   ├── constants/
│   │   └── app_colors.dart
│   ├── models/
│   │   ├── user_model.dart
│   │   └── waitlist_model.dart
│   ├── services/
│   │   ├── api_service.dart
│   │   ├── auth_service.dart
│   │   └── waitlist_service.dart
│   └── theme/
│       └── app_theme.dart
├── screens/
│   ├── analysis_screen.dart
│   ├── child_profile_screen.dart
│   ├── food_detail_screen.dart
│   ├── food_screen.dart
│   ├── home_screen.dart
│   ├── main_wrapper.dart
│   ├── photo_screen.dart
│   ├── waitlist_screen.dart
│   ├── screens.dart
│   └── auth/
│       ├── login_screen.dart
│       └── register_screen.dart
└── widgets/
    ├── action_button.dart
    ├── custom_input_field.dart
    ├── custom_navbar.dart
    ├── metric_card.dart
    ├── notification_button.dart
    ├── widgets.dart
    ├── analysis/
    │   ├── analysis_form.dart
    │   ├── analysis_header.dart
    │   ├── analysis_info_box.dart
    │   └── analysis_result_box.dart
    ├── food/
    │   ├── food_category_filters.dart
    │   ├── food_header.dart
    │   ├── food_list_item.dart
    │   └── food_search_bar.dart
    ├── home/
    │   ├── child_profile_card.dart
    │   ├── daily_tip_card.dart
    │   ├── home_header.dart
    │   ├── last_checkup_card.dart
    │   ├── weekly_nutrition_card.dart
    │   └── weight_trend_card.dart
    └── photo/
        ├── camera_view.dart
        ├── photo_header.dart
        └── photo_instructions.dart
```

## Penjelasan Singkat Isi Folder

### `core`

Berisi fondasi aplikasi, seperti warna, model data, service API, dan tema visual.

### `screens`

Berisi halaman utama aplikasi, termasuk login, register, home, analysis, food, photo, dan waitlist.

### `widgets`

Berisi komponen UI yang dipakai berulang, supaya struktur kode lebih rapi dan mudah dirawat.

## Catatan

- File `main.dart` masih mengarahkan aplikasi mulai dari `LoginScreen`.
- `MainWrapper` menampung navigasi utama setelah pengguna masuk ke aplikasi.
- Struktur `lib` di atas mengikuti file yang sudah ada di project saat ini.

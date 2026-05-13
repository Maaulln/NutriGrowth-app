# AGENTS.md

## Konteks Project

- Nama project: NutriGrowth App (Flutter Android/iOS/Web)
- Path project: /Users/maaullntech/Documents/COde/NutriGrowth-app

## Path Ekosistem NutriGrowth

- Aplikasi mobile (repo ini): /Users/maaullntech/Documents/COde/NutriGrowth-app
- Backend Laravel: /Users/maaullntech/Documents/COde/nutrigrowth-backend
- Frontend Web: /Users/maaullntech/Documents/COde/nutrigrowth-web
- AI model API (referensi integrasi): /Users/maaullntech/Documents/COde/nutrigrowth-ai

## Tanggung Jawab Repo Ini

- Menangani UI/UX aplikasi mobile NutriGrowth.
- Mengelola autentikasi user dari backend Laravel.
- Mengambil dan menampilkan data anak (children) dari backend Laravel.
- Mengirim request analisis gizi ke AI API.

## Aturan Integrasi

- Endpoint Laravel dipakai untuk auth dan data aplikasi umum (contoh: auth, users, children).
- Endpoint AI dipakai khusus untuk inference (nutrition analyze, food recommend).
- Jangan hardcode API key atau URL produksi, gunakan environment variable/dart-define.
- Setiap API call wajib ada error handling dan timeout.

## Aturan Coding

- Gunakan bahasa Indonesia untuk komentar dan dokumentasi.
- Setiap fungsi harus memiliki docstring/JSDoc.
- Gunakan async/await, hindari then/catch berantai.
- Jangan gunakan var; gunakan const atau let (untuk JavaScript/TypeScript) dan final/const (untuk Dart).
- Prioritaskan readability, pecah kode menjadi fungsi kecil.
- Untuk Python: wajib type hints dan f-string.

## Catatan Data Anak

- Sumber kebenaran data child adalah database backend (tabel children).
- Jika tampilan berbeda dengan DB, prioritaskan cek:
  1. mapping model Flutter,
  2. endpoint API children,
  3. host/port backend pada konfigurasi app.

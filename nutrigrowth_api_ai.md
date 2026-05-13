
## 🔗 Panduan Koneksi Model ke Aplikasi

Dokumentasi singkat ini menjelaskan cara menghubungkan aplikasi (mis. Flutter, web, atau backend lain) ke API NutriGrowth AI yang menjalankan model XGBoost dan LightGBM.

1. Prasyarat

- Pastikan server API berjalan (dev): `uvicorn api.main:app --reload --host 0.0.0.0 --port 8000`
- Pastikan file model telah tersedia:
  - `models/xgboost_nutrition/model.json`
  - `models/lightgbm_food/model.txt`
- Pastikan dependency terinstall: `pip install -r requirements.txt`

2. Konfigurasi environment

- Gunakan environment variables untuk konfigurasi sensitif dan endpoint:
  - `NUTRIGROWTH_API_HOST` (default: `http://localhost:8000`)
  - `API_KEY` (jika mengaktifkan otentikasi)

3. Endpoint utama

- Health: `GET /health`
- Nutrition analysis: `POST /api/v1/nutrition/analyze` (JSON body)
- Food recommendation: `POST /api/v1/food/recommend` (JSON body)
- Food list: `GET /api/v1/food/list?category=...&limit=...`

4. Contoh klien — Python (requests)

```python
"""Contoh sederhana: panggil endpoint nutrition analyze dari aplikasi Python."""
import os
import requests

API_HOST = os.getenv('NUTRIGROWTH_API_HOST', 'http://localhost:8000')
API_KEY = os.getenv('API_KEY')

def analyze_nutrition(payload: dict) -> dict:
    """Kirim data anak ke endpoint dan kembalikan hasil analisis."""
    headers = {'Content-Type': 'application/json'}
    if API_KEY:
        headers['Authorization'] = f'Bearer {API_KEY}'
    resp = requests.post(f"{API_HOST}/api/v1/nutrition/analyze", json=payload, headers=headers, timeout=10)
    resp.raise_for_status()
    return resp.json()

# Usage
if __name__ == '__main__':
    sample = {
        'age_months': 36,
        'gender': 1,
        'weight_kg': 11.5,
        'height_cm': 88.0,
        'muac_cm': 14.2
    }
    print(analyze_nutrition(sample))
```

5. Contoh klien — JavaScript (fetch)

```javascript
// Contoh panggilan dari aplikasi web / React
const API_HOST = process.env.NUTRIGROWTH_API_HOST || "http://localhost:8000";
const API_KEY = process.env.API_KEY || null;

async function analyzeNutrition(payload) {
  const headers = { "Content-Type": "application/json" };
  if (API_KEY) headers["Authorization"] = `Bearer ${API_KEY}`;
  const res = await fetch(`${API_HOST}/api/v1/nutrition/analyze`, {
    method: "POST",
    headers,
    body: JSON.stringify(payload),
  });
  if (!res.ok) throw new Error(`API error ${res.status}`);
  return res.json();
}

// contoh
// analyzeNutrition({ age_months:36, gender:1, weight_kg:11.5, height_cm:88, muac_cm:14.2 })
```

6. Contoh cURL

```bash
curl -X POST $NUTRIGROWTH_API_HOST/api/v1/nutrition/analyze \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $API_KEY" \
  -d '{"age_months":36,"gender":1,"weight_kg":11.5,"height_cm":88.0,"muac_cm":14.2}'
```

7. Best practices integrasi

- Validasi payload di sisi klien sebelum mengirim (tipe dan rentang nilai).
- Tangani error jaringan dengan retry dan exponential backoff.
- Jika low-latency dibutuhkan, pertimbangkan caching hasil rekomendasi per user/child.
- Gunakan HTTPS di produksi dan batasi origins via CORS.
- Terapkan otentikasi (API key / JWT) pada API untuk mencegah penyalahgunaan.

8. Pengujian integrasi

- Gunakan `pytest` untuk membuat test yang memanggil endpoint lokal.
- Mock model jika ingin isolasi logika aplikasi saat pengujian.

9. Troubleshooting cepat

- 401 Unauthorized: periksa header `Authorization` dan `API_KEY`.
- 400 Bad Request: periksa schema JSON pada `api/schemas/schemas.py`.
- 500 Internal Server Error: lihat logs server dan cek pemuatan model di `api/services`.

Jika Anda ingin, saya bisa juga menambahkan contoh integrasi khusus untuk Flutter (Dart) atau membuat skrip postman/collection untuk tim QA.
/// Helper URL gambar makanan dari sumber terbuka (Unsplash CDN).
///
/// Digunakan saat backend belum menyediakan [imageUrl], agar daftar makanan
/// tetap menampilkan foto relevan tanpa upload asset lokal.
class FoodImageHelper {
  FoodImageHelper._();

  /// Daftar foto Unsplash (lisensi gratis) per kategori umum makanan.
  static const Map<String, List<String>> _categoryPhotos = {
    'rice': [
      'https://images.unsplash.com/photo-1536304993881-ff8427959b32?auto=format&fit=crop&w=400&h=400&q=80',
      'https://images.unsplash.com/photo-1516684732162-798a0062be99?auto=format&fit=crop&w=400&h=400&q=80',
    ],
    'protein': [
      'https://images.unsplash.com/photo-1606755459625-b25329553fac?auto=format&fit=crop&w=400&h=400&q=80',
      'https://images.unsplash.com/photo-1607623814075-e51df1a82d4f?auto=format&fit=crop&w=400&h=400&q=80',
    ],
    'fish': [
      'https://images.unsplash.com/photo-1519708227418-c8fd9a32b9a2?auto=format&fit=crop&w=400&h=400&q=80',
      'https://images.unsplash.com/photo-1467003909585-2f8a72700288?auto=format&fit=crop&w=400&h=400&q=80',
    ],
    'vegetable': [
      'https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=400&h=400&q=80',
      'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=400&h=400&q=80',
    ],
    'fruit': [
      'https://images.unsplash.com/photo-1619569643744-bf987f011451?auto=format&fit=crop&w=400&h=400&q=80',
      'https://images.unsplash.com/photo-1490474568278-789ed412d229?auto=format&fit=crop&w=400&h=400&q=80',
    ],
    'dairy': [
      'https://images.unsplash.com/photo-1550583724-b2693bf4382d?auto=format&fit=crop&w=400&h=400&q=80',
      'https://images.unsplash.com/photo-1563636619-e9143da7973b?auto=format&fit=crop&w=400&h=400&q=80',
    ],
    'egg': [
      'https://images.unsplash.com/photo-1582722878405-a63ccb13c0e9?auto=format&fit=crop&w=400&h=400&q=80',
    ],
    'soup': [
      'https://images.unsplash.com/photo-1547592166-23ac45744acd?auto=format&fit=crop&w=400&h=400&q=80',
      'https://images.unsplash.com/photo-1604908176997-4316357a1b4a?auto=format&fit=crop&w=400&h=400&q=80',
    ],
    'snack': [
      'https://images.unsplash.com/photo-1558961363-fa8fdf82db35?auto=format&fit=crop&w=400&h=400&q=80',
    ],
    'default': [
      'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=400&h=400&q=80',
      'https://images.unsplash.com/photo-1490645935967-10de6ba17061?auto=format&fit=crop&w=400&h=400&q=80',
      'https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=400&h=400&q=80',
    ],
  };

  /// Mengembalikan URL gambar efektif: prioritas backend, lalu Unsplash.
  static String resolveImageUrl({
    String? imageUrl,
    required String name,
    required String category,
  }) {
    final trimmed = imageUrl?.trim();
    if (trimmed != null && trimmed.isNotEmpty) {
      return trimmed;
    }
    return _unsplashUrlForFood(name, category);
  }

  /// Memilih foto Unsplash berdasarkan nama dan kategori makanan.
  static String _unsplashUrlForFood(String name, String category) {
    final key = _detectPhotoKey(name, category);
    final photos = _categoryPhotos[key] ?? _categoryPhotos['default']!;
    final index = name.hashCode.abs() % photos.length;
    return photos[index];
  }

  /// Mendeteksi kategori foto dari nama/kategori makanan (ID & EN).
  static String _detectPhotoKey(String name, String category) {
    final text = '${name.toLowerCase()} ${category.toLowerCase()}';

    if (_containsAny(text, ['nasi', 'rice', 'bubur', 'porridge', 'carb'])) {
      return 'rice';
    }
    if (_containsAny(text, ['ikan', 'fish', 'salmon', 'tuna', 'seafood'])) {
      return 'fish';
    }
    if (_containsAny(text, [
      'ayam', 'chicken', 'daging', 'meat', 'beef', 'sapi', 'protein', 'tempe', 'tahu', 'tofu',
    ])) {
      return 'protein';
    }
    if (_containsAny(text, ['telur', 'egg'])) {
      return 'egg';
    }
    if (_containsAny(text, [
      'sayur', 'vegetable', 'veggie', 'brokoli', 'broccoli', 'bayam', 'spinach', 'wortel', 'carrot',
    ])) {
      return 'vegetable';
    }
    if (_containsAny(text, ['buah', 'fruit', 'pisang', 'banana', 'apel', 'apple', 'jeruk', 'orange'])) {
      return 'fruit';
    }
    if (_containsAny(text, ['susu', 'milk', 'yogurt', 'keju', 'cheese', 'dairy'])) {
      return 'dairy';
    }
    if (_containsAny(text, ['sup', 'soup', 'soto', 'bubur'])) {
      return 'soup';
    }
    if (_containsAny(text, ['snack', 'camilan', 'kue', 'cookie', 'biskuit'])) {
      return 'snack';
    }
    return 'default';
  }

  static bool _containsAny(String text, List<String> keywords) {
    for (final keyword in keywords) {
      if (text.contains(keyword)) return true;
    }
    return false;
  }
}

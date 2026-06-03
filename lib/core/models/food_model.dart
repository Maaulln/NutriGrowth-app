import '../utils/food_image_helper.dart';

class Food {
  final int id;
  final String name;
  final String category;
  final double calories;
  final double protein;
  final double fat;
  final double carbs;
  final int pricePerServing;
  final String servingSize;
  final String? description;
  final String? imageUrl;

  Food({
    required this.id,
    required this.name,
    required this.category,
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carbs,
    required this.pricePerServing,
    required this.servingSize,
    this.description,
    this.imageUrl,
  });

  /// URL gambar efektif (backend atau fallback Unsplash).
  String get effectiveImageUrl => FoodImageHelper.resolveImageUrl(
        imageUrl: imageUrl,
        name: name,
        category: category,
      );

  factory Food.fromJson(Map<String, dynamic> json) {
    final name = json['name'] as String;
    final category = json['category'] as String;
    return Food(
      id: json['id'],
      name: name,
      category: category,
      calories: (json['calories'] as num).toDouble(),
      protein: (json['protein'] as num).toDouble(),
      fat: (json['fat'] as num).toDouble(),
      carbs: (json['carbs'] as num).toDouble(),
      pricePerServing: json['price_per_serving'],
      servingSize: json['serving_size'],
      description: json['description'],
      imageUrl: FoodImageHelper.resolveImageUrl(
        imageUrl: json['image_url'] as String?,
        name: name,
        category: category,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'calories': calories,
      'protein': protein,
      'fat': fat,
      'carbs': carbs,
      'price_per_serving': pricePerServing,
      'serving_size': servingSize,
      'description': description,
      'image_url': imageUrl,
    };
  }
}

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

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      calories: (json['calories'] as num).toDouble(),
      protein: (json['protein'] as num).toDouble(),
      fat: (json['fat'] as num).toDouble(),
      carbs: (json['carbs'] as num).toDouble(),
      pricePerServing: json['price_per_serving'],
      servingSize: json['serving_size'],
      description: json['description'],
      imageUrl: json['image_url'],
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

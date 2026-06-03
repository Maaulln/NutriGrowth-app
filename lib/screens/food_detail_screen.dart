import 'package:flutter/material.dart';
import '../core/models/food_model.dart';
import '../widgets/food/food_network_image.dart';

class FoodDetailScreen extends StatelessWidget {
  final Food food;

  const FoodDetailScreen({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. Header Image Background
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.45,
            child: FoodNetworkImage(
              imageUrl: food.effectiveImageUrl,
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.45,
              fit: BoxFit.cover,
              placeholderIcon: Icons.restaurant_menu,
              placeholderIconSize: 80,
            ),
          ),

          // 2. Custom Back Button
          Positioned(
            top: MediaQuery.of(context).padding.top > 0
                ? MediaQuery.of(context).padding.top + 8
                : 40,
            left: 20,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: Color(0xFF1A2E2A),
                  size: 20,
                ),
              ),
            ),
          ),

          // 3. Content overlay
          Positioned(
            top: MediaQuery.of(context).size.height * 0.4 - 30,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(
                  top: 32,
                  left: 24,
                  right: 24,
                  bottom: 40,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tag Category
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF82).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        food.category.toUpperCase(),
                        style: const TextStyle(
                          color: Color(0xFF2D7A55),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Title
                    Text(
                      food.name,
                      style: const TextStyle(
                        color: Color(0xFF1A2E2A),
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Description
                    Text(
                      food.description ?? 'No description available.',
                      style: TextStyle(
                        color: const Color(0xFF1A2E2A).withValues(alpha: 0.6),
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Metrics Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildMetricCard(
                          Icons.local_fire_department,
                          "Calories",
                          "${food.calories.toStringAsFixed(0)} kcal",
                        ),
                        _buildMetricCard(
                          Icons.fitness_center,
                          "Protein",
                          "${food.protein.toStringAsFixed(1)}g",
                        ),
                        _buildMetricCard(
                          Icons.shopping_bag_outlined,
                          "Price",
                          "IDR ${food.pricePerServing}",
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Nutrition Details
                    const Text(
                      'Nutritional Details',
                      style: TextStyle(
                        color: Color(0xFF1A2E2A),
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildListItem('Serving Size: ${food.servingSize}'),
                    _buildListItem('Fat: ${food.fat.toStringAsFixed(1)}g'),
                    _buildListItem('Carbohydrates: ${food.carbs.toStringAsFixed(1)}g'),
                    const SizedBox(height: 24),

                    // Recipe/Instructions
                    const Text(
                      'Instructions',
                      style: TextStyle(
                        color: Color(0xFF1A2E2A),
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildStepItem(
                      '1',
                      'Wash and prepare all ingredients carefully ensuring they are safe for toddler consumption.',
                    ),
                    _buildStepItem(
                      '2',
                      'Steam or boil the ingredients until they reach a soft, easily chewable texture.',
                    ),
                    _buildStepItem(
                      '3',
                      'Mash or cut into tiny bite-sized pieces to prevent any choking hazards.',
                    ),
                    _buildStepItem('4', 'Serve at room temperature. Enjoy!'),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(IconData icon, String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F7F4),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF4CAF82), size: 24),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF6B8F80),
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF1A2E2A),
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.circle, size: 6, color: Color(0xFF4CAF82)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Color(0xFF4A6B5D), fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepItem(String step, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF82).withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                step,
                style: const TextStyle(
                  color: Color(0xFF2D7A55),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Color(0xFF4A6B5D),
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

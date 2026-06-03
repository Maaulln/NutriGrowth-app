import 'package:flutter/material.dart';
import '../../screens/food_detail_screen.dart';
import '../../core/models/food_model.dart';
import 'food_network_image.dart';

class FoodListItem extends StatelessWidget {
  final Food food;

  const FoodListItem({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FoodDetailScreen(food: food),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        height: 102,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFF4CAF82).withValues(alpha: 0.15),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Image
            FoodNetworkImage(
              imageUrl: food.effectiveImageUrl,
              width: 100,
              height: 100,
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(20),
              ),
            ),
            // Details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          food.name,
                          style: const TextStyle(
                            color: Color(0xFF1A2E2A),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          food.description ?? '',
                          style: const TextStyle(
                            color: Color(0xFF6B8F80),
                            fontSize: 11,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        _buildInfoChip(
                          Icons.local_fire_department,
                          '${food.calories.toStringAsFixed(0)} kcal',
                          const Color(0xFFE6912E),
                        ),
                        const SizedBox(width: 12),
                        _buildInfoChip(
                          Icons.fitness_center,
                          '${food.protein.toStringAsFixed(1)}g',
                          const Color(0xFF4CAF82),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, Color iconAndTextColor) {
    return Row(
      children: [
        Icon(icon, size: 12, color: iconAndTextColor),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: iconAndTextColor,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

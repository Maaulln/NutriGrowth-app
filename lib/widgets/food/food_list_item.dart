import 'package:flutter/material.dart';
import '../../screens/food_detail_screen.dart';

class FoodListItem extends StatelessWidget {
  final Map<String, String> foodItem;

  const FoodListItem({super.key, required this.foodItem});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FoodDetailScreen(foodItem: foodItem),
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
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(20),
              ),
              child: Container(
                width: 100,
                height: 100,
                color: const Color(0xFFE8F5EE),
                child: Image.asset(
                  foodItem['image'] ?? '',
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.fastfood,
                      color: Colors.grey,
                      size: 40,
                    );
                  },
                ),
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
                          foodItem['title'] ?? '',
                          style: const TextStyle(
                            color: Color(0xFF1A2E2A),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          foodItem['subtitle'] ?? '',
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
                          foodItem['kcal'] ?? '',
                          const Color(0xFFE6912E),
                        ),
                        const SizedBox(width: 12),
                        _buildInfoChip(
                          Icons.fitness_center,
                          foodItem['protein'] ?? '',
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

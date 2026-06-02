import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../core/models/nutrition_analysis_model.dart';

class FoodRecommendationsSection extends StatelessWidget {
  const FoodRecommendationsSection({
    super.key,
    required this.foodSummary,
    required this.foodItems,
    this.padding = const EdgeInsets.symmetric(horizontal: 20),
  });

  final String foodSummary;
  final List<FoodRecommendationItem> foodItems;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.restaurant_menu,
                color: Color(0xFF4CAF82),
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'Rekomendasi Makanan AI',
                style: TextStyle(
                  color: Color(0xFF1A2E2A),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          if (foodSummary.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              foodSummary,
              style: TextStyle(
                color: const Color(0xFF1A2E2A).withValues(alpha: 0.65),
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ],
          const SizedBox(height: 12),
          ...foodItems.map((item) => _FoodRecommendationCard(item: item)),
        ],
      ),
    );
  }
}

class _FoodRecommendationCard extends StatelessWidget {
  const _FoodRecommendationCard({required this.item});

  final FoodRecommendationItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF4CAF82).withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar makanan
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(left: Radius.circular(14)),
            child: item.imageUrl != null
                ? CachedNetworkImage(
                    imageUrl: item.imageUrl!,
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => _imagePlaceholder(),
                    errorWidget: (context, url, error) => _imagePlaceholder(),
                  )
                : _imagePlaceholder(),
          ),
          // Detail makanan
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          item.foodName,
                          style: const TextStyle(
                            color: Color(0xFF1A2E2A),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4CAF82).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          item.category,
                          style: const TextStyle(
                            color: Color(0xFF4CAF82),
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.scale_outlined, size: 12, color: Color(0xFF888888)),
                      const SizedBox(width: 3),
                      Text(item.servingSize, style: const TextStyle(color: Color(0xFF888888), fontSize: 11)),
                      const SizedBox(width: 10),
                      const Icon(Icons.payments_outlined, size: 12, color: Color(0xFF888888)),
                      const SizedBox(width: 3),
                      Text(
                        'Rp ${_formatPrice(item.estimatedPrice)}',
                        style: const TextStyle(color: Color(0xFF888888), fontSize: 11),
                      ),
                    ],
                  ),
                  if (item.reason.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      item.reason,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: const Color(0xFF1A2E2A).withValues(alpha: 0.6),
                        fontSize: 11,
                        height: 1.4,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      width: 90,
      height: 90,
      color: const Color(0xFFE8F5EE),
      child: const Icon(Icons.restaurant, color: Color(0xFF4CAF82), size: 32),
    );
  }

  String _formatPrice(int price) {
    final str = price.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buffer.write('.');
      buffer.write(str[i]);
    }
    return buffer.toString();
  }
}

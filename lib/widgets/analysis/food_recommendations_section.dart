import 'package:flutter/material.dart';
import '../../core/models/food_model.dart';
import '../../core/models/nutrition_analysis_model.dart';
import '../../core/services/food_service.dart';
import '../../screens/food_detail_screen.dart';
import '../food/food_network_image.dart';

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
                'AI Food Recommendations',
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

class _FoodRecommendationCard extends StatefulWidget {
  const _FoodRecommendationCard({required this.item});
  final FoodRecommendationItem item;

  @override
  State<_FoodRecommendationCard> createState() => _FoodRecommendationCardState();
}

class _FoodRecommendationCardState extends State<_FoodRecommendationCard> {
  bool _tapping = false;
  Food? _dbFood;

  /// Memuat detail data makanan dari database backend berdasarkan nama makanan.
  ///
  /// Melakukan pencarian menggunakan [FoodService] dengan batas retry dan timeout lebih pendek.
  Future<Food?> _loadDbFood() async {
    if (_dbFood != null) return _dbFood;
    try {
      final results = await FoodService.instance.getFoods(
        search: widget.item.foodName,
        maxRetries: 2,
        timeoutDuration: const Duration(seconds: 3),
      );
      if (results.isNotEmpty) {
        _dbFood = results.first;
        return _dbFood;
      }
    } catch (_) {}
    return null;
  }

  Future<void> _onTap() async {
    setState(() => _tapping = true);
    try {
      final food = await _loadDbFood();
      if (!mounted) return;
      if (food != null) {
        if (mounted && _dbFood != null) setState(() {});
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => FoodDetailScreen(food: food)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Details for "${widget.item.foodName}" not found.'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load food details.')),
        );
      }
    } finally {
      if (mounted) setState(() => _tapping = false);
    }
  }

  String get _imageUrl =>
      _dbFood?.effectiveImageUrl ?? widget.item.effectiveImageUrl;

  FoodRecommendationItem get item => widget.item;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _tapping ? null : _onTap,
      child: AnimatedOpacity(
        opacity: _tapping ? 0.6 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Container(
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
          FoodNetworkImage(
            imageUrl: _imageUrl,
            width: 90,
            height: 90,
            borderRadius: const BorderRadius.horizontal(left: Radius.circular(14)),
            placeholderIcon: Icons.restaurant,
            placeholderIconSize: 32,
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
                        'IDR ${_formatPrice(item.estimatedPrice)}',
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
        ),
      ),
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

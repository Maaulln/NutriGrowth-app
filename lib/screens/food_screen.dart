import 'package:flutter/material.dart';
import '../widgets/food/food_header.dart';
import '../widgets/food/food_search_bar.dart';
import '../widgets/food/food_category_filters.dart';
import '../widgets/food/food_list_item.dart';

class FoodScreen extends StatefulWidget {
  final Function(int)? onNavigate;

  const FoodScreen({super.key, this.onNavigate});

  @override
  State<FoodScreen> createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> {
  String _selectedFilter = 'All';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _filters = [
    'All',
    'High Protein',
    'Weight Gain',
    'Balanced',
  ];

  final List<Map<String, String>> _foods = [
    {
      'title': 'Salmon Fillet',
      'subtitle': 'Rich in omega-3 for brain development',
      'kcal': '208 kcal',
      'protein': '20g',
      'category': 'High Protein',
      'image': 'assets/6d67bf6da57eb7316edb07289f3a0f10d18096a1.png',
    },
    {
      'title': 'Boiled Eggs',
      'subtitle': 'Complete protein with essential vitamins',
      'kcal': '155 kcal',
      'protein': '13g',
      'category': 'High Protein',
      'image': 'assets/9cfa3b837aea3995065f53dc380dd81b6ac68e73.png',
    },
    {
      'title': 'Avocado',
      'subtitle': 'Healthy fats for weight gain support',
      'kcal': '160 kcal',
      'protein': '2g',
      'category': 'Weight Gain',
      'image': 'assets/52b900a1749dd940f32217227cbef2e49e4180d6.png',
    },
    {
      'title': 'Banana Mash',
      'subtitle': 'Natural energy & potassium boost',
      'kcal': '89 kcal',
      'protein': '1.1g',
      'category': 'Weight Gain',
      'image': 'assets/b15d81c58a949c3fe3670feeedeaf8a042141622.png',
    },
    {
      'title': 'Sweet Potato',
      'subtitle': 'Vitamin A for immune system support',
      'kcal': '86 kcal',
      'protein': '1.6g',
      'category': 'Balanced',
      'image': 'assets/e547c39f73c3e1f4419e7311697a7bb6f6dd4995.png',
    },
    {
      'title': 'Chicken Breast',
      'subtitle': 'Lean protein for muscle growth',
      'kcal': '165 kcal',
      'protein': '31g',
      'category': 'High Protein',
      'image': 'assets/c3dad153c55231c842f9898947d4c491034baf16.png',
    },
    {
      'title': 'Oatmeal Porridge',
      'subtitle': 'Fiber & iron for steady energy',
      'kcal': '68 kcal',
      'protein': '2.4g',
      'category': 'Balanced',
      'image': 'assets/ac55af370e868c5639133b133a1f2dd64f5145c9.png',
    },
    {
      'title': 'Greek Yogurt',
      'subtitle': 'Calcium & probiotics for gut health',
      'kcal': '100 kcal',
      'protein': '17g',
      'category': 'Balanced',
      'image': 'assets/ece84a74433e1a8967c9458b2566bc4807a2900c.png',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, String>> get _filteredFoods {
    return _foods.where((food) {
      // 1. Check search query
      final queryLower = _searchQuery.toLowerCase();
      final titleMatch = food['title']!.toLowerCase().contains(queryLower);
      final subtitleMatch = food['subtitle']!.toLowerCase().contains(
        queryLower,
      );
      final matchesSearch = titleMatch || subtitleMatch;

      // 2. Check filter category
      final matchesCategory =
          _selectedFilter == 'All' || food['category'] == _selectedFilter;

      return matchesSearch && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            FoodHeader(onNavigate: widget.onNavigate),
            const SizedBox(height: 16),
            FoodSearchBar(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
            const SizedBox(height: 16),
            FoodCategoryFilters(
              filters: _filters,
              selectedFilter: _selectedFilter,
              onFilterSelected: (filter) {
                setState(() => _selectedFilter = filter);
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  bottom: 120,
                ),
                itemCount: _filteredFoods.length,
                itemBuilder: (context, index) {
                  return FoodListItem(foodItem: _filteredFoods[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

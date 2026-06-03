import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/providers/food_provider.dart';
import '../widgets/food/food_header.dart';
import '../widgets/food/food_search_bar.dart';
import '../widgets/food/food_category_filters.dart';
import '../widgets/food/food_list_item.dart';

class FoodScreen extends ConsumerStatefulWidget {
  const FoodScreen({super.key});

  @override
  ConsumerState<FoodScreen> createState() => _FoodScreenState();
}

class _FoodScreenState extends ConsumerState<FoodScreen> {
  final TextEditingController _searchController = TextEditingController();

  static const List<String> _filters = [
    'All',
    'Protein',
    'Carbo',
    'Vegetable',
    'Fruit',
    'Dairy',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(foodProvider.notifier).checkPendingCategory();
      ref.read(foodProvider.notifier).loadFoods();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final foodState = ref.watch(foodProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const FoodHeader(),
            const SizedBox(height: 16),
            FoodSearchBar(
              controller: _searchController,
              onChanged: (value) =>
                  ref.read(foodProvider.notifier).setSearch(value),
            ),
            const SizedBox(height: 16),
            FoodCategoryFilters(
              filters: _filters,
              selectedFilter: foodState.selectedFilter,
              onFilterSelected: (filter) =>
                  ref.read(foodProvider.notifier).setFilter(filter),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: foodState.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : foodState.error != null
                      ? Center(child: Text(foodState.error!))
                      : ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.only(
                            left: 20,
                            right: 20,
                            bottom: 120,
                          ),
                          itemCount: foodState.foods.length,
                          itemBuilder: (context, index) {
                            return FoodListItem(food: foodState.foods[index]);
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

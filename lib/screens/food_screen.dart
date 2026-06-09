import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/providers/food_provider.dart';
import '../widgets/food/food_header.dart';
import '../widgets/food/food_search_bar.dart';
import '../widgets/food/food_category_filters.dart';
import '../widgets/food/food_list_item.dart';

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 56, color: Color(0xFFB0C4BC)),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF6B8F80),
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF82),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF4CAF82),
                      ),
                    )
                  : foodState.error != null
                      ? _ErrorView(
                          message: foodState.error!,
                          onRetry: () =>
                              ref.read(foodProvider.notifier).loadFoods(),
                        )
                      : foodState.foods.isEmpty
                          ? const Center(
                              child: Text(
                                'No foods found.',
                                style: TextStyle(color: Color(0xFF6B8F80)),
                              ),
                            )
                          : ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.only(
                                left: 20,
                                right: 20,
                                bottom: 120,
                              ),
                              itemCount: foodState.foods.length,
                              itemBuilder: (context, index) {
                                return FoodListItem(
                                    food: foodState.foods[index]);
                              },
                            ),
            ),
          ],
        ),
      ),
    );
  }
}

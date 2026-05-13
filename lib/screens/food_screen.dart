import 'package:flutter/material.dart';
import '../widgets/food/food_header.dart';
import '../widgets/food/food_search_bar.dart';
import '../widgets/food/food_category_filters.dart';
import '../widgets/food/food_list_item.dart';
import '../core/models/food_model.dart';
import '../core/services/food_service.dart';

class FoodScreen extends StatefulWidget {
  final Function(int)? onNavigate;
  final bool isActive;

  const FoodScreen({super.key, this.onNavigate, this.isActive = false});

  @override
  State<FoodScreen> createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> {
  String _selectedFilter = 'All';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  List<Food> _foods = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void didUpdateWidget(FoodScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _fetchFoods();
    }
  }

  final List<String> _filters = [
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
    _fetchFoods();
  }

  Future<void> _fetchFoods() async {
    // Check if there is a pending category from another screen (e.g. analysis)
    if (FoodService.instance.pendingCategory != null) {
      _selectedFilter = FoodService.instance.pendingCategory!;
      FoodService.instance.pendingCategory = null; // Clear it
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final foods = await FoodService.instance.getFoods(
        category: _selectedFilter,
        search: _searchQuery,
      );
      setState(() {
        _foods = foods;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
                _fetchFoods(); // Fetch from API on search
              },
            ),
            const SizedBox(height: 16),
            FoodCategoryFilters(
              filters: _filters,
              selectedFilter: _selectedFilter,
              onFilterSelected: (filter) {
                setState(() => _selectedFilter = filter);
                _fetchFoods(); // Fetch from API on filter change
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _errorMessage != null
                      ? Center(child: Text(_errorMessage!))
                      : ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.only(
                            left: 20,
                            right: 20,
                            bottom: 120,
                          ),
                          itemCount: _foods.length,
                          itemBuilder: (context, index) {
                            return FoodListItem(food: _foods[index]);
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

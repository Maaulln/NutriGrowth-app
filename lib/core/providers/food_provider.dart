import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/food_model.dart';
import '../services/food_service.dart';

class FoodState {
  final List<Food> foods;
  final String selectedFilter;
  final String searchQuery;
  final bool isLoading;
  final String? error;

  const FoodState({
    this.foods = const [],
    this.selectedFilter = 'All',
    this.searchQuery = '',
    this.isLoading = false,
    this.error,
  });

  FoodState copyWith({
    List<Food>? foods,
    String? selectedFilter,
    String? searchQuery,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return FoodState(
      foods: foods ?? this.foods,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class FoodNotifier extends StateNotifier<FoodState> {
  FoodNotifier() : super(const FoodState());

  Future<void> loadFoods() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final foods = await FoodService.instance.getFoods(
        category: state.selectedFilter,
        search: state.searchQuery,
      );
      state = state.copyWith(foods: foods, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> setFilter(String filter) async {
    state = state.copyWith(selectedFilter: filter);
    await loadFoods();
  }

  Future<void> setSearch(String query) async {
    state = state.copyWith(searchQuery: query);
    await loadFoods();
  }

  void checkPendingCategory() {
    if (FoodService.instance.pendingCategory != null) {
      state = state.copyWith(selectedFilter: FoodService.instance.pendingCategory!);
      FoodService.instance.pendingCategory = null;
    }
  }
}

final foodProvider = StateNotifierProvider<FoodNotifier, FoodState>(
  (ref) => FoodNotifier(),
);

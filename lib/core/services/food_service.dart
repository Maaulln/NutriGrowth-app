import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/food_model.dart';
import 'api_service.dart';

class FoodService {
  FoodService._();
  static final FoodService _instance = FoodService._();
  static FoodService get instance => _instance;

  final http.Client _client = http.Client();
  String? pendingCategory;

  Future<List<Food>> getFoods({String? category, String? search}) async {
    final queryParameters = <String, String>{};
    if (category != null && category != 'All') {
      queryParameters['category'] = category.toLowerCase();
    }
    if (search != null && search.isNotEmpty) {
      queryParameters['search'] = search;
    }

    final uri = Uri.parse('${ApiService.baseUrl}/foods').replace(
      queryParameters: queryParameters,
    );

    try {
      final response = await _client.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        final List<dynamic> data = body['data'];
        return data.map((json) => Food.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load foods: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error connecting to backend: $e');
    }
  }
}

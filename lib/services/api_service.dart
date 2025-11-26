import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';
import '../models/meal.dart';
import '../models/meal_detail.dart';

class ApiService {
  static const String baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  static Future<List<Category>> fetchCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/categories.php'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Category> categories = [];

      for (var category in data['categories']) {
        categories.add(Category.fromJson(category));
      }

      return categories;
    } else {
      throw Exception('Failed to load categories');
    }
  }

  static Future<List<Meal>> searchMeals(String query) async {
    final response = await http.get(
      Uri.parse('$baseUrl/search.php?s=$query'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Meal> meals = [];

      if (data['meals'] != null) {
        for (var meal in data['meals']) {
          meals.add(Meal.fromJson(meal));
        }
      }

      return meals;
    } else {
      throw Exception('Failed to search meals');
    }
  }

  static Future<List<Meal>> fetchMealsByCategory(String category) async {
    final response = await http.get(
      Uri.parse('$baseUrl/filter.php?c=$category'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Meal> meals = [];

      if (data['meals'] != null) {
        for (var meal in data['meals']) {
          meals.add(Meal.fromJson(meal));
        }
      }

      return meals;
    } else {
      throw Exception('Failed to load meals');
    }
  }

  static Future<MealDetail?> fetchMealDetail(String id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/lookup.php?i=$id'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['meals'] != null && data['meals'].isNotEmpty) {
        return MealDetail.fromJson(data['meals'][0]);
      }
      return null;
    } else {
      throw Exception('Failed to load meal details');
    }
  }

  static Future<MealDetail?> fetchRandomMeal() async {
    final response = await http.get(
      Uri.parse('$baseUrl/random.php'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['meals'] != null && data['meals'].isNotEmpty) {
        return MealDetail.fromJson(data['meals'][0]);
      }
      return null;
    } else {
      throw Exception('Failed to load random meal');
    }
  }
}
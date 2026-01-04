// lib/services/meal_service.dart
import '../core/api_client.dart';
import '../models/meal.dart';

class MealService {
  final _client = ApiClient();

  Future<List<Meal>> listMeals() async {
    final res = await _client.get('meals/list.php');
    final list = (res['data'] as List).map((e) => Meal.fromJson(e)).toList();
    return list;
  }

  Future<bool> createMeal({
    required String title,
    required String ingredients,
    required int calories,
    int protein = 0,
    int carbs = 0,
    int fats = 0,
    required int userId,
  }) async {
    final res = await _client.post('meals/create.php', {
      'title': title,
      'ingredients': ingredients,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fats': fats,
      'user_id': userId,
    });
    return res['success'] == true;
  }

  Future<bool> updateMeal({
    required int id,
    required String title,
    required String ingredients,
    required int calories,
    int protein = 0,
    int carbs = 0,
    int fats = 0,
  }) async {
    final res = await _client.post('meals/update.php', {
      'id': id,
      'title': title,
      'ingredients': ingredients,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fats': fats,
    });
    return res['success'] == true;
  }

  Future<bool> deleteMeal(int id) async {
    final res = await _client.post('meals/delete.php', {'id': id});
    return res['success'] == true;
  }
}

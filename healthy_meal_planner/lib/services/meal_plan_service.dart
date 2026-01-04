// lib/services/meal_plan_service.dart
import '../core/api_client.dart';
import '../models/meal_plan.dart';

class MealPlanService {
  final _client = ApiClient();

  Future<List<MealPlan>> listByUser(int userId) async {
    final res = await _client.get('mealplans/list_by_user.php', query: {'user_id': '$userId'});
    final list = (res['data'] as List).map((e) => MealPlan.fromJson(e)).toList();
    return list;
  }

  Future<bool> createPlan({
    required int userId,
    required String weekStart,
    required String weekEnd,
    int totalCalories = 0,
  }) async {
    final res = await _client.post('mealplans/create.php', {
      'user_id': userId,
      'week_start': weekStart,
      'week_end': weekEnd,
      'total_calories': totalCalories,
    });
    return res['success'] == true;
  }

  Future<bool> updateTotals(int id, int totalCalories) async {
    final res = await _client.post('mealplans/update_totals.php', {
      'id': id,
      'total_calories': totalCalories,
    });
    return res['success'] == true;
  }

  Future<bool> deletePlan(int id) async {
    final res = await _client.post('mealplans/delete.php', {'id': id});
    return res['success'] == true;
  }
}

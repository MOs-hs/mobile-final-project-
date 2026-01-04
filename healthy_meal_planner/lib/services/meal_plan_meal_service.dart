// lib/services/meal_plan_meal_service.dart
import '../core/api_client.dart';
import '../models/meal_plan_meal.dart';

class MealPlanMealService {
  final _client = ApiClient();

  Future<bool> addToPlan({
    required int mealplanId,
    required int mealId,
    required String dayOfWeek,
    required String mealType,
  }) async {
    final res = await _client.post('mealplanmeals/add.php', {
      'mealplan_id': mealplanId,
      'meal_id': mealId,
      'day_of_week': dayOfWeek,
      'meal_type': mealType,
    });
    return res['success'] == true;
  }

  Future<List<MealPlanMeal>> listByPlan(int mealplanId) async {
    final res = await _client.get('mealplanmeals/list_by_plan.php', query: {'mealplan_id': '$mealplanId'});
    final list = (res['data'] as List).map((e) => MealPlanMeal.fromJson(e)).toList();
    return list;
  }

  Future<bool> removeFromPlan(int id) async {
    final res = await _client.post('mealplanmeals/delete.php', {'id': id});
    return res['success'] == true;
  }

  Future<List<MealPlanMeal>> weeklyView({
    required int userId,
    required String weekStart,
    required String weekEnd,
  }) async {
    final res = await _client.get('mealplanmeals/weekly_view.php', query: {
      'user_id': '$userId',
      'week_start': weekStart,
      'week_end': weekEnd,
    });
    final list = (res['data'] as List).map((e) => MealPlanMeal.fromJson(e)).toList();
    return list;
  }
}

// lib/models/meal_plan_meal.dart
class MealPlanMeal {
  final int id;
  final int mealplanId;
  final int mealId;
  final String dayOfWeek;
  final String mealType;
  final String? title;
  final int? calories;
  final int? protein;
  final int? carbs;
  final int? fats;

  MealPlanMeal({
    required this.id,
    required this.mealplanId,
    required this.mealId,
    required this.dayOfWeek,
    required this.mealType,
    this.title,
    this.calories,
    this.protein,
    this.carbs,
    this.fats,
  });

  factory MealPlanMeal.fromJson(Map<String, dynamic> json) {
    // Helper function to safely parse int values that might come as strings or null
    int? parseIntOrNull(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is String) return int.tryParse(value);
      return null;
    }

    int parseIntRequired(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    return MealPlanMeal(
      id: parseIntRequired(json['id']),
      mealplanId: parseIntRequired(json['mealplan_id']),
      mealId: parseIntRequired(json['meal_id']),
      dayOfWeek: json['day_of_week']?.toString() ?? '',
      mealType: json['meal_type']?.toString() ?? '',
      title: json['title']?.toString(),
      calories: parseIntOrNull(json['calories']),
      protein: parseIntOrNull(json['protein']),
      carbs: parseIntOrNull(json['carbs']),
      fats: parseIntOrNull(json['fats']),
    );
  }
}

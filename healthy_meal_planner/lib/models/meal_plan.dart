// lib/models/meal_plan.dart
class MealPlan {
  final int id;
  final int userId;
  final String weekStart;
  final String weekEnd;
  final int totalCalories;

  MealPlan({
    required this.id,
    required this.userId,
    required this.weekStart,
    required this.weekEnd,
    required this.totalCalories,
  });

  factory MealPlan.fromJson(Map<String, dynamic> json) => MealPlan(
        id: json['id'],
        userId: json['user_id'],
        weekStart: json['week_start'],
        weekEnd: json['week_end'],
        totalCalories: json['total_calories'],
      );
}

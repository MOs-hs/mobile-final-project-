// lib/models/meal.dart
class Meal {
  final int id;
  final String title;
  final String ingredients;
  final int calories;
  final int protein;
  final int carbs;
  final int fats;
  final int userId;

  Meal({
    required this.id,
    required this.title,
    required this.ingredients,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
    required this.userId,
  });

  factory Meal.fromJson(Map<String, dynamic> json) => Meal(
        id: json['id'],
        title: json['title'],
        ingredients: json['ingredients'],
        calories: json['calories'],
        protein: json['protein'],
        carbs: json['carbs'],
        fats: json['fats'],
        userId: json['user_id'],
      );
}

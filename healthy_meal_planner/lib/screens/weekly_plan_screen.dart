// lib/screens/weekly_plan_screen.dart
import 'package:flutter/material.dart';
import '../services/meal_plan_service.dart';
import '../services/meal_plan_meal_service.dart';
import '../services/meal_service.dart';
import '../models/meal_plan.dart';
import '../models/meal_plan_meal.dart';
import '../models/meal.dart';

class WeeklyPlanScreen extends StatefulWidget {
  const WeeklyPlanScreen({super.key});
  @override
  State<WeeklyPlanScreen> createState() => _WeeklyPlanScreenState();
}

class _WeeklyPlanScreenState extends State<WeeklyPlanScreen> {
  final _planService = MealPlanService();
  final _itemService = MealPlanMealService();
  final _mealService = MealService();

  List<MealPlanMeal> _items = [];
  List<Meal> _availableMeals = [];
  int? _mealPlanId;
  bool _loading = true;
  String? _error;

  final int _userId = 3;
  final String _weekStart = '2025-12-31';
  final String _weekEnd = '2026-01-04';

  final List<String> _days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
  final List<String> _mealTypes = ['breakfast', 'lunch', 'dinner', 'snack'];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      // Get or create meal plan for this week
      final plans = await _planService.listByUser(_userId);
      final activePlan = plans.firstWhere(
        (p) => p.weekStart == _weekStart && p.weekEnd == _weekEnd,
        orElse: () => MealPlan(id: 0, userId: 0, weekStart: '', weekEnd: '', totalCalories: 0),
      );
      
      if (activePlan.id == 0) {
        // Create new plan for this week
        await _planService.createPlan(
          userId: _userId,
          weekStart: _weekStart,
          weekEnd: _weekEnd,
        );
        // Fetch again to get the new plan ID
        final newPlans = await _planService.listByUser(_userId);
        _mealPlanId = newPlans.firstWhere(
          (p) => p.weekStart == _weekStart && p.weekEnd == _weekEnd,
        ).id;
      } else {
        _mealPlanId = activePlan.id;
      }
      
      _items = await _itemService.weeklyView(userId: _userId, weekStart: _weekStart, weekEnd: _weekEnd);
      _availableMeals = await _mealService.listMeals();
    } catch (e) {
      _error = e.toString();
    } finally {
      setState(() { _loading = false; });
    }
  }

  List<MealPlanMeal> _getMealsForDayAndType(String day, String type) {
    return _items.where((item) => 
      item.dayOfWeek.toLowerCase() == day.toLowerCase() && 
      item.mealType.toLowerCase() == type.toLowerCase()
    ).toList();
  }

  Future<void> _showAddMealDialog(String day, String mealType) async {
    final selected = await showDialog<Meal>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add $mealType for $day'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _availableMeals.length,
            itemBuilder: (_, i) {
              final meal = _availableMeals[i];
              return ListTile(
                title: Text(meal.title),
                subtitle: Text('${meal.calories} kcal • ${meal.protein}g protein'),
                trailing: Icon(Icons.add_circle, color: Colors.green),
                onTap: () => Navigator.pop(context, meal),
              );
            },
          ),
        ),
      ),
    );

    if (selected != null && _mealPlanId != null) {
      try {
        await _itemService.addToPlan(
          mealplanId: _mealPlanId!,
          mealId: selected.id,
          dayOfWeek: day,
          mealType: mealType,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${selected.title} added to $day $mealType!'), backgroundColor: Colors.green),
        );
        _load();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add meal: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weekly Meal Plan'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: _error != null
          ? Center(child: Text(_error!, style: TextStyle(color: Colors.red)))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Week Info Card
                  Card(
                    color: Colors.green.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today, color: Colors.green),
                          SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Current Week',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Text('$_weekStart to $_weekEnd', style: TextStyle(color: Colors.grey[700])),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Weekly Calendar Grid
                  ..._days.map((day) => _buildDayCard(day)),
                ],
              ),
            ),
    );
  }

  Widget _buildDayCard(String day) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: ExpansionTile(
        title: Row(
          children: [
            Container(
              width: 8,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            SizedBox(width: 12),
            Text(
              day,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        children: _mealTypes.map((type) => _buildMealTypeSection(day, type)).toList(),
      ),
    );
  }

  Widget _buildMealTypeSection(String day, String mealType) {
    final meals = _getMealsForDayAndType(day, mealType);
    final icon = mealType == 'breakfast' ? Icons.free_breakfast :
                 mealType == 'lunch' ? Icons.lunch_dining :
                 mealType == 'dinner' ? Icons.dinner_dining :
                 Icons.fastfood;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: Colors.green.shade700),
              SizedBox(width: 8),
              Text(
                mealType.toUpperCase(),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Colors.grey[700],
                  letterSpacing: 0.5,
                ),
              ),
              Spacer(),
              IconButton(
                icon: Icon(Icons.add_circle_outline, color: Colors.green),
                onPressed: () => _showAddMealDialog(day, mealType),
                tooltip: 'Add $mealType',
              ),
            ],
          ),
          if (meals.isEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 28, bottom: 8),
              child: Text(
                'No meals planned',
                style: TextStyle(color: Colors.grey, fontSize: 13, fontStyle: FontStyle.italic),
              ),
            )
          else
            ...meals.map((meal) => _buildMealCard(meal)),
        ],
      ),
    );
  }

  Widget _buildMealCard(MealPlanMeal meal) {
    return Container(
      margin: const EdgeInsets.only(left: 28, bottom: 8, right: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.restaurant, color: Colors.green, size: 20),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meal.title ?? 'Meal #${meal.mealId}',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.local_fire_department, size: 14, color: Colors.orange),
                    SizedBox(width: 4),
                    Text(
                      '${meal.calories ?? 0} kcal',
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                    if (meal.protein != null) ...[
                      SizedBox(width: 12),
                      Icon(Icons.fitness_center, size: 14, color: Colors.blue),
                      SizedBox(width: 4),
                      Text(
                        '${meal.protein}g protein',
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.delete_outline, color: Colors.red.shade300),
            onPressed: () async {
              // Confirm delete
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Remove Meal'),
                  content: Text('Remove "${meal.title}" from this meal plan?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: Text('Remove', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                try {
                  await _itemService.removeFromPlan(meal.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Meal removed!'), backgroundColor: Colors.red),
                  );
                  _load();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to remove meal: $e'), backgroundColor: Colors.red),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }
}

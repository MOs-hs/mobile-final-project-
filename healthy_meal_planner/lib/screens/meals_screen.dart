// lib/screens/meals_screen.dart
import 'package:flutter/material.dart';
import '../services/meal_service.dart';
import '../models/meal.dart';
import '../models/user.dart';

class MealsScreen extends StatefulWidget {
  const MealsScreen({super.key});
  @override
  State<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  final _service = MealService();
  List<Meal> _meals = [];
  bool _loading = true;
  String? _error;
  User? _user;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get user from route arguments
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is User) {
      _user = args;
    }
    _load();
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      _meals = await _service.listMeals();
    } catch (e) {
      _error = e.toString();
    } finally {
      setState(() { _loading = false; });
    }
  }

  Future<void> _showCreateMealDialog() async {
    final titleController = TextEditingController();
    final ingredientsController = TextEditingController();
    final caloriesController = TextEditingController();
    final proteinController = TextEditingController();
    final carbsController = TextEditingController();
    final fatsController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.restaurant_menu, color: Colors.green.shade700, size: 28),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Text(
                          'Create New Meal',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Meal Title
                  TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: 'Meal Title',
                      hintText: 'e.g., Grilled Chicken Salad',
                      prefixIcon: const Icon(Icons.fastfood),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a meal title';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Ingredients
                  TextFormField(
                    controller: ingredientsController,
                    decoration: InputDecoration(
                      labelText: 'Ingredients',
                      hintText: 'e.g., Chicken, lettuce, tomatoes',
                      prefixIcon: const Icon(Icons.list_alt),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                    ),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter ingredients';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Nutrition Header
                  Row(
                    children: [
                      Icon(Icons.monitor_weight, color: Colors.green.shade700, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Nutrition Information',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Calories
                  TextFormField(
                    controller: caloriesController,
                    decoration: InputDecoration(
                      labelText: 'Calories (kcal)',
                      prefixIcon: const Icon(Icons.local_fire_department, color: Colors.orange),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: Colors.orange.shade50,
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Required';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Enter a valid number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  // Protein, Carbs, Fats Row
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: proteinController,
                          decoration: InputDecoration(
                            labelText: 'Protein (g)',
                            prefixIcon: const Icon(Icons.egg, color: Colors.blue),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            filled: true,
                            fillColor: Colors.blue.shade50,
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          controller: carbsController,
                          decoration: InputDecoration(
                            labelText: 'Carbs (g)',
                            prefixIcon: const Icon(Icons.grass, color: Colors.green),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            filled: true,
                            fillColor: Colors.green.shade50,
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          controller: fatsController,
                          decoration: InputDecoration(
                            labelText: 'Fats (g)',
                            prefixIcon: const Icon(Icons.water_drop, color: Colors.amber),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            filled: true,
                            fillColor: Colors.amber.shade50,
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Create Button
                  ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        Navigator.pop(context);
                        await _createMeal(
                          title: titleController.text.trim(),
                          ingredients: ingredientsController.text.trim(),
                          calories: int.parse(caloriesController.text),
                          protein: int.tryParse(proteinController.text) ?? 0,
                          carbs: int.tryParse(carbsController.text) ?? 0,
                          fats: int.tryParse(fatsController.text) ?? 0,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 2,
                    ),
                    child: const Text(
                      'Create Meal',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _createMeal({
    required String title,
    required String ingredients,
    required int calories,
    int protein = 0,
    int carbs = 0,
    int fats = 0,
  }) async {
    try {
      // Use logged-in user ID or default to 3
      final userId = _user?.id ?? 3;
      await _service.createMeal(
        title: title,
        ingredients: ingredients,
        calories: calories,
        protein: protein,
        carbs: carbs,
        fats: fats,
        userId: userId,
      );
      await _load();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Meal created successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create meal: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _delete(int id) async {
    await _service.deleteMeal(id);
    await _load();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Meal deleted'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Colors.green),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('My Meals', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month),
            onPressed: () => Navigator.pushNamed(context, '/weekly'),
          ),
        ],
      ),
      body: _error != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
                  const SizedBox(height: 16),
                  Text(_error!, style: TextStyle(color: Colors.red.shade700)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _load,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
          : _meals.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.restaurant, size: 80, color: Colors.grey.shade300),
                      const SizedBox(height: 16),
                      Text(
                        'No meals yet',
                        style: TextStyle(fontSize: 20, color: Colors.grey.shade600),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tap the + button to create your first meal',
                        style: TextStyle(color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _meals.length,
                  itemBuilder: (_, i) {
                    final m = _meals[i];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade200,
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        leading: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.restaurant_menu, color: Colors.green.shade700),
                        ),
                        title: Text(
                          m.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Row(
                            children: [
                              _NutritionBadge(
                                icon: Icons.local_fire_department,
                                label: '${m.calories} kcal',
                                color: Colors.orange,
                              ),
                              const SizedBox(width: 8),
                              _NutritionBadge(
                                icon: Icons.egg,
                                label: 'P:${m.protein}',
                                color: Colors.blue,
                              ),
                              const SizedBox(width: 8),
                              _NutritionBadge(
                                icon: Icons.grass,
                                label: 'C:${m.carbs}',
                                color: Colors.green,
                              ),
                              const SizedBox(width: 8),
                              _NutritionBadge(
                                icon: Icons.water_drop,
                                label: 'F:${m.fats}',
                                color: Colors.amber,
                              ),
                            ],
                          ),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red.shade400),
                          onPressed: () => _delete(m.id),
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreateMealDialog,
        backgroundColor: Colors.green,
        icon: const Icon(Icons.add),
        label: const Text('Add Meal', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}

class _NutritionBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _NutritionBadge({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

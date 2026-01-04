// lib/main.dart
import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/meals_screen.dart';
import 'screens/weekly_plan_screen.dart';

void main() {
  runApp(const HealthyMealPlanner());
}

class HealthyMealPlanner extends StatelessWidget {
  const HealthyMealPlanner({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Healthy Meal Planner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      initialRoute: '/login',
      routes: {
        '/login': (_) => const LoginScreen(),
        '/signup': (_) => const SignupScreen(),
        '/meals': (_) => const MealsScreen(),
        '/weekly': (_) => const WeeklyPlanScreen(),
      },
    );
  }
}

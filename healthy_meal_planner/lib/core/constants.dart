// lib/core/constants.dart
class Constants {
  // ===== CONFIGURATION =====
  // For LOCAL development with XAMPP: use localhost
  // For ONLINE deployment: replace with your hosting URL
  
  // LOCAL (XAMPP):
  // For Chrome (Web), use localhost directly
  static const String apiBase = 'http://localhost/healthy_meal_planner_api';
  
  // For Android Emulator, use 10.0.2.2:
  // static const String apiBase = 'http://10.0.2.2/healthy_meal_planner_api';
  
  // For Physical Android Device, use your PC's IP address:
  // static const String apiBase = 'http://192.168.1.5/healthy_meal_planner_api';
  
  static const Duration timeout = Duration(seconds: 15);
}

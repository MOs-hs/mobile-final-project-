-- Database schema for Healthy Meal Planner
CREATE DATABASE IF NOT EXISTS healthy_meal_planner;
USE healthy_meal_planner;

-- Users table
CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  role ENUM('user', 'admin') DEFAULT 'user',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Meals table
CREATE TABLE IF NOT EXISTS meals (
  id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(200) NOT NULL,
  ingredients TEXT NOT NULL,
  calories INT NOT NULL,
  protein INT DEFAULT 0,
  carbs INT DEFAULT 0,
  fats INT DEFAULT 0,
  user_id INT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Meal Plans table
CREATE TABLE IF NOT EXISTS mealplans (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  week_start DATE NOT NULL,
  week_end DATE NOT NULL,
  total_calories INT DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Meal Plan Meals (junction table)
CREATE TABLE IF NOT EXISTS mealplanmeals (
  id INT AUTO_INCREMENT PRIMARY KEY,
  mealplan_id INT NOT NULL,
  meal_id INT NOT NULL,
  day_of_week VARCHAR(20) NOT NULL,
  meal_type ENUM('breakfast', 'lunch', 'dinner', 'snack') DEFAULT 'lunch',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (mealplan_id) REFERENCES mealplans(id) ON DELETE CASCADE,
  FOREIGN KEY (meal_id) REFERENCES meals(id) ON DELETE CASCADE
);

-- Sample data
INSERT INTO users (name, email, password, role) VALUES
('Admin User', 'admin@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin'),
('John Doe', 'john@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'user'),
('Mohamad', 'mohamad@gmail.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'user');

INSERT INTO meals (title, ingredients, calories, protein, carbs, fats, user_id) VALUES
('Grilled Chicken Salad', 'Chicken breast, lettuce, tomatoes, olive oil', 350, 30, 15, 18, 3),
('Salmon with Vegetables', 'Salmon fillet, broccoli, carrots, lemon', 450, 35, 20, 25, 3),
('Greek Yogurt Bowl', 'Greek yogurt, berries, honey, granola', 280, 15, 40, 8, 2);

INSERT INTO mealplans (user_id, week_start, week_end, total_calories) VALUES
(3, '2025-12-31', '2026-01-04', 2100);

INSERT INTO mealplanmeals (mealplan_id, meal_id, day_of_week, meal_type) VALUES
(1, 1, 'Monday', 'lunch'),
(1, 2, 'Monday', 'dinner'),
(1, 3, 'Tuesday', 'breakfast');

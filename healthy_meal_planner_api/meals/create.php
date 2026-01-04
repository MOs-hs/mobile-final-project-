<?php
// healthy_meal_planner_api/meals/create.php
require_once '../config/db.php';
require_once '../utils/response.php';

$body = read_json();
$title = trim($body['title'] ?? '');
$ingredients = trim($body['ingredients'] ?? '');
$calories = (int)($body['calories'] ?? 0);
$protein = (int)($body['protein'] ?? 0);
$carbs   = (int)($body['carbs'] ?? 0);
$fats    = (int)($body['fats'] ?? 0);
$userId  = (int)($body['user_id'] ?? 0);

if ($title === '' || $ingredients === '' || $calories <= 0 || $userId <= 0) {
  fail('title, ingredients, calories, user_id required');
}

$stmt = $pdo->prepare('INSERT INTO meals (title, ingredients, calories, protein, carbs, fats, user_id) VALUES (?, ?, ?, ?, ?, ?, ?)');
$stmt->execute([$title, $ingredients, $calories, $protein, $carbs, $fats, $userId]);

ok([], 'Meal created');

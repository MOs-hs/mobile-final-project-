<?php
// healthy_meal_planner_api/meals/update.php
require_once '../config/db.php';
require_once '../utils/response.php';

$body = read_json();
$id = (int)($body['id'] ?? 0);
$title = trim($body['title'] ?? '');
$ingredients = trim($body['ingredients'] ?? '');
$calories = (int)($body['calories'] ?? 0);
$protein = (int)($body['protein'] ?? 0);
$carbs   = (int)($body['carbs'] ?? 0);
$fats    = (int)($body['fats'] ?? 0);

if ($id <= 0 || $title === '' || $ingredients === '' || $calories <= 0) {
  fail('id, title, ingredients, calories required');
}

$stmt = $pdo->prepare('UPDATE meals SET title=?, ingredients=?, calories=?, protein=?, carbs=?, fats=? WHERE id=?');
$stmt->execute([$title, $ingredients, $calories, $protein, $carbs, $fats, $id]);

ok([], 'Meal updated');

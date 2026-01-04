<?php
// healthy_meal_planner_api/mealplanmeals/add.php
require_once '../config/db.php';
require_once '../utils/response.php';

$body = read_json();
$mealplanId = (int)($body['mealplan_id'] ?? 0);
$mealId     = (int)($body['meal_id'] ?? 0);
$dayOfWeek  = trim($body['day_of_week'] ?? '');
$mealType   = trim($body['meal_type'] ?? 'lunch');

if ($mealplanId <= 0 || $mealId <= 0 || $dayOfWeek === '' || $mealType === '') {
  fail('mealplan_id, meal_id, day_of_week, meal_type required');
}

$stmt = $pdo->prepare('INSERT INTO mealplanmeals (mealplan_id, meal_id, day_of_week, meal_type) VALUES (?, ?, ?, ?)');
$stmt->execute([$mealplanId, $mealId, $dayOfWeek, $mealType]);

ok([], 'Meal added to plan');

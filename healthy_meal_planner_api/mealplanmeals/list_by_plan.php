<?php
// healthy_meal_planner_api/mealplanmeals/list_by_plan.php
require_once '../config/db.php';
require_once '../utils/response.php';

$planId = (int)($_GET['mealplan_id'] ?? 0);
if ($planId <= 0) fail('mealplan_id required');

$stmt = $pdo->prepare('
  SELECT mpm.id, mpm.mealplan_id, mpm.meal_id, mpm.day_of_week, mpm.meal_type,
         meals.title, meals.calories, meals.protein, meals.carbs, meals.fats
  FROM mealplanmeals mpm
  JOIN meals ON meals.id = mpm.meal_id
  WHERE mpm.mealplan_id = ?
  ORDER BY FIELD(mpm.day_of_week, "Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"), mpm.meal_type
');
$stmt->execute([$planId]);
ok($stmt->fetchAll());

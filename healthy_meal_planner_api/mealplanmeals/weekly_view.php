<?php
// healthy_meal_planner_api/mealplanmeals/weekly_view.php
require_once '../config/db.php';
require_once '../utils/response.php';

// user_id + week range -> grouped weekly plan with meal details
$userId = (int)($_GET['user_id'] ?? 0);
$weekStart = $_GET['week_start'] ?? '';
$weekEnd   = $_GET['week_end'] ?? '';

if ($userId <= 0 || $weekStart === '' || $weekEnd === '') {
  fail('user_id, week_start, week_end required');
}

$stmt = $pdo->prepare('
  SELECT mpm.id, mpm.mealplan_id, mpm.meal_id,
         mpm.day_of_week, mpm.meal_type,
         meals.title, meals.calories, meals.protein, meals.carbs, meals.fats
  FROM mealplans mp
  LEFT JOIN mealplanmeals mpm ON mpm.mealplan_id = mp.id
  LEFT JOIN meals ON meals.id = mpm.meal_id
  WHERE mp.user_id = ? AND mp.week_start = ? AND mp.week_end = ?
  ORDER BY FIELD(mpm.day_of_week, "Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"), mpm.meal_type
');
$stmt->execute([$userId, $weekStart, $weekEnd]);

ok($stmt->fetchAll());

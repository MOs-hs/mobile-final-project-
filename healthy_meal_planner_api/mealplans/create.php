<?php
// healthy_meal_planner_api/mealplans/create.php
require_once '../config/db.php';
require_once '../utils/response.php';

$body = read_json();
$userId = (int)($body['user_id'] ?? 0);
$weekStart = $body['week_start'] ?? '';
$weekEnd   = $body['week_end'] ?? '';
$totalCalories = (int)($body['total_calories'] ?? 0);

if ($userId <= 0 || $weekStart === '' || $weekEnd === '') {
  fail('user_id, week_start, week_end required');
}

$stmt = $pdo->prepare('INSERT INTO mealplans (user_id, week_start, week_end, total_calories) VALUES (?, ?, ?, ?)');
$stmt->execute([$userId, $weekStart, $weekEnd, $totalCalories]);

ok([], 'Mealplan created');

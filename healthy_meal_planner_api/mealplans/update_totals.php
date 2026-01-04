<?php
// healthy_meal_planner_api/mealplans/update_totals.php
require_once '../config/db.php';
require_once '../utils/response.php';

$body = read_json();
$id = (int)($body['id'] ?? 0);
$totalCalories = (int)($body['total_calories'] ?? 0);

if ($id <= 0) fail('id required');

$stmt = $pdo->prepare('UPDATE mealplans SET total_calories=? WHERE id=?');
$stmt->execute([$totalCalories, $id]);

ok([], 'Mealplan totals updated');

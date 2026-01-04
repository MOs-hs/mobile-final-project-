<?php
// healthy_meal_planner_api/mealplans/list_by_user.php
require_once '../config/db.php';
require_once '../utils/response.php';

$userId = (int)($_GET['user_id'] ?? 0);
if ($userId <= 0) fail('user_id required');

$stmt = $pdo->prepare('SELECT id, user_id, week_start, week_end, total_calories, created_at FROM mealplans WHERE user_id = ? ORDER BY id DESC');
$stmt->execute([$userId]);
ok($stmt->fetchAll());

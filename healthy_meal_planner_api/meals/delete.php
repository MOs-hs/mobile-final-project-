<?php
// healthy_meal_planner_api/meals/delete.php
require_once '../config/db.php';
require_once '../utils/response.php';

$body = read_json();
$id = (int)($body['id'] ?? 0);
if ($id <= 0) fail('Valid id required');

$stmt = $pdo->prepare('DELETE FROM meals WHERE id = ?');
$stmt->execute([$id]);

ok([], 'Meal deleted');

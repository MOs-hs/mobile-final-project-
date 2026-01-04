<?php
// healthy_meal_planner_api/meals/list.php
require_once '../config/db.php';
require_once '../utils/response.php';

$stmt = $pdo->query('SELECT id, title, ingredients, calories, protein, carbs, fats, user_id, created_at FROM meals ORDER BY id DESC');
ok($stmt->fetchAll());

<?php
// Simplified database connection (backup version)
declare(strict_types=1);

header('Content-Type: application/json; charset=UTF-8');

// Database configuration
$host = '127.0.0.1';
$db   = 'healthy_meal_planner';
$user = 'root';
$pass = '';
$charset = 'utf8mb4';

$dsn = "mysql:host=$host;dbname=$db;charset=$charset";

// Simple PDO options without persistent connections
$options = [
  PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
  PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
  PDO::ATTR_EMULATE_PREPARES   => false,
];

try {
  $pdo = new PDO($dsn, $user, $pass, $options);
} catch (PDOException $e) {
  http_response_code(500);
  echo json_encode([
    'success' => false, 
    'message' => 'Database connection failed: ' . $e->getMessage()
  ]);
  exit;
}

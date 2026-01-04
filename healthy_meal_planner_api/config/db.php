<?php
// healthy_meal_planner_api/config/db.php
declare(strict_types=1);

// Check if we're in online/production environment
$isOnline = !empty(getenv('DB_HOST')) || !empty($_ENV['DB_HOST']);

if ($isOnline) {
  // Online Database Configuration (Railway or other hosting)
  $host = getenv('DB_HOST') ?: $_ENV['DB_HOST'] ?? 'localhost';
  $port = getenv('DB_PORT') ?: $_ENV['DB_PORT'] ?? '3306';
  $db   = getenv('DB_NAME') ?: $_ENV['DB_NAME'] ?? 'healthy_meal_planner';
  $user = getenv('DB_USER') ?: $_ENV['DB_USER'] ?? 'root';
  $pass = getenv('DB_PASS') ?: $_ENV['DB_PASS'] ?? '';
} else {
  // Localhost XAMPP MySQL Database Configuration
  $host = 'localhost';
  $port = '3306';
  $db   = 'healthy_meal_planner';
  $user = 'root';
  $pass = '';  // Default XAMPP has no password
}

$charset = 'utf8mb4';
$dsn = "mysql:host=$host;port=$port;dbname=$db;charset=$charset";

// PDO options
$options = [
  PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
  PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
  PDO::ATTR_EMULATE_PREPARES   => false,
];

try {
  $pdo = new PDO($dsn, $user, $pass, $options);
} catch (PDOException $e) {
  error_log("Database connection failed: " . $e->getMessage());
  http_response_code(500);
  header('Content-Type: application/json');
  echo json_encode([
    'success' => false,
    'message' => 'Database connection failed',
    'error' => $e->getMessage(),
    'environment' => $isOnline ? 'online' : 'local'
  ]);
  exit;
}


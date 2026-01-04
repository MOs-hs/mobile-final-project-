<?php
// healthy_meal_planner_api/utils/response.php
declare(strict_types=1);

// Start output buffering to prevent any output before JSON
ob_start();

// Disable error display but enable error logging
ini_set('display_errors', '0');
ini_set('log_errors', '1');
error_reporting(E_ALL);

// Send CORS headers immediately
if (isset($_SERVER['HTTP_ORIGIN'])) {
  header("Access-Control-Allow-Origin: {$_SERVER['HTTP_ORIGIN']}");
  header('Access-Control-Allow-Credentials: true');
  header('Access-Control-Max-Age: 86400');
}

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
  if (isset($_SERVER['HTTP_ACCESS_CONTROL_REQUEST_METHOD'])) {
    header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
  }
  if (isset($_SERVER['HTTP_ACCESS_CONTROL_REQUEST_HEADERS'])) {
    header("Access-Control-Allow-Headers: {$_SERVER['HTTP_ACCESS_CONTROL_REQUEST_HEADERS']}");
  }
  http_response_code(200);
  exit(0);
}

header('Content-Type: application/json; charset=UTF-8');

function ok($data = [], string $message = 'OK'): void {
  ob_clean(); // Clear any buffered output
  echo json_encode(['success' => true, 'message' => $message, 'data' => $data]);
  exit;
}

function fail(string $message = 'Error', int $code = 400): void {
  ob_clean(); // Clear any buffered output
  http_response_code($code);
  echo json_encode(['success' => false, 'message' => $message]);
  exit;
}

function read_json(): array {
  $raw = file_get_contents('php://input');
  $data = json_decode($raw ?? '', true);
  return is_array($data) ? $data : [];
}

// Set global error handler to return JSON errors
set_error_handler(function($errno, $errstr, $errfile, $errline) {
  ob_clean();
  http_response_code(500);
  echo json_encode([
    'success' => false,
    'message' => 'Server error occurred'
  ]);
  error_log("PHP Error [$errno]: $errstr in $errfile on line $errline");
  exit;
});

// Set global exception handler to return JSON errors
set_exception_handler(function($exception) {
  ob_clean();
  http_response_code(500);
  echo json_encode([
    'success' => false,
    'message' => 'Server error occurred'
  ]);
  error_log("Uncaught Exception: " . $exception->getMessage());
  exit;
});


<?php
// healthy_meal_planner_api/auth/login.php
require_once '../config/db.php';
require_once '../utils/response.php';
require_once '../utils/auth.php';

try {
  $body = read_json();
  $email = trim($body['email'] ?? '');
  $password = $body['password'] ?? '';

  if ($email === '' || $password === '') {
    fail('Email and password are required', 400);
  }

  // Validate email format
  if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
    fail('Invalid email format', 400);
  }

  $stmt = $pdo->prepare('SELECT id, name, email, password, role, created_at FROM users WHERE email = ? LIMIT 1');
  $stmt->execute([$email]);
  $user = $stmt->fetch();

  if (!$user || !password_verify($password, $user['password'])) {
    fail('Invalid credentials', 401);
  }

  $token = make_token((int)$user['id']);
  unset($user['password']); // Don't send password hash to client
  $user['token'] = $token;

  ok(['user' => $user], 'Login successful');
} catch (PDOException $e) {
  error_log("Database error in login.php: " . $e->getMessage());
  fail('Database error occurred', 500);
} catch (Throwable $e) {
  error_log("Error in login.php: " . $e->getMessage());
  fail('Login failed', 500);
}


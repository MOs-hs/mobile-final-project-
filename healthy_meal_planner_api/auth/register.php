<?php
// healthy_meal_planner_api/auth/register.php
require_once '../config/db.php';
require_once '../utils/response.php';

try {
  $body = read_json();
  $name = trim($body['name'] ?? '');
  $email = trim($body['email'] ?? '');
  $password = $body['password'] ?? '';

  if ($name === '' || $email === '' || $password === '') {
    fail('Name, email, and password are required', 400);
  }

  // Validate email format
  if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
    fail('Invalid email format', 400);
  }

  // Check if email already exists
  $exists = $pdo->prepare('SELECT id FROM users WHERE email = ? LIMIT 1');
  $exists->execute([$email]);
  if ($exists->fetch()) {
    fail('Email already exists', 409);
  }

  // Hash password and insert user
  $hash = password_hash($password, PASSWORD_BCRYPT);
  $ins = $pdo->prepare('INSERT INTO users (name, email, password, role) VALUES (?, ?, ?, ?)');
  $ins->execute([$name, $email, $hash, 'user']);

  ok([], 'Registration successful');
} catch (PDOException $e) {
  error_log("Database error in register.php: " . $e->getMessage());
  fail('Database error occurred', 500);
} catch (Throwable $e) {
  error_log("Error in register.php: " . $e->getMessage());
  fail('Registration failed', 500);
}


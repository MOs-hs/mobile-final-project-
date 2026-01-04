<?php
// healthy_meal_planner_api/utils/auth.php
declare(strict_types=1);

function make_token(int $userId): string {
  // Simple stateless token (replace with JWT in production)
  return base64_encode($userId . '|' . time());
}

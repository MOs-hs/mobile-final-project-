-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jan 04, 2026 at 04:33 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `healthy_meal_planner`
--

-- --------------------------------------------------------

--
-- Table structure for table `mealplanmeals`
--

CREATE TABLE `mealplanmeals` (
  `id` int(11) NOT NULL,
  `mealplan_id` int(11) NOT NULL,
  `meal_id` int(11) NOT NULL,
  `day_of_week` varchar(20) NOT NULL,
  `meal_type` enum('breakfast','lunch','dinner','snack') DEFAULT 'lunch',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `mealplanmeals`
--

INSERT INTO `mealplanmeals` (`id`, `mealplan_id`, `meal_id`, `day_of_week`, `meal_type`, `created_at`) VALUES
(22, 3, 28, 'Monday', 'breakfast', '2026-01-04 15:21:28'),
(23, 3, 27, 'Monday', 'lunch', '2026-01-04 15:21:37');

-- --------------------------------------------------------

--
-- Table structure for table `mealplans`
--

CREATE TABLE `mealplans` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `week_start` date NOT NULL,
  `week_end` date NOT NULL,
  `total_calories` int(11) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `mealplans`
--

INSERT INTO `mealplans` (`id`, `user_id`, `week_start`, `week_end`, `total_calories`, `created_at`) VALUES
(3, 3, '2025-12-31', '2026-01-04', 5510, '2026-01-03 19:52:49');

-- --------------------------------------------------------

--
-- Table structure for table `meals`
--

CREATE TABLE `meals` (
  `id` int(11) NOT NULL,
  `title` varchar(200) NOT NULL,
  `ingredients` text NOT NULL,
  `calories` int(11) NOT NULL,
  `protein` int(11) DEFAULT 0,
  `carbs` int(11) DEFAULT 0,
  `fats` int(11) DEFAULT 0,
  `user_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `meals`
--

INSERT INTO `meals` (`id`, `title`, `ingredients`, `calories`, `protein`, `carbs`, `fats`, `user_id`, `created_at`) VALUES
(27, 'shawarma', 'chiken toum kabis', 300, 50, 10, 5, 4, '2026-01-04 14:50:28'),
(28, 'pizza', 'tomato cheeze ..', 400, 60, 40, 20, 4, '2026-01-04 15:17:38');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('user','admin') DEFAULT 'user',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `password`, `role`, `created_at`) VALUES
(1, 'Admin User', 'admin@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin', '2026-01-03 17:43:07'),
(2, 'John Doe', 'john@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'user', '2026-01-03 17:43:07'),
(3, 'Mohamad', 'mohamad@gmail.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'user', '2026-01-03 17:43:07'),
(4, 'mohamad hajj sleiman', 'mohamad1@gmail.com', '$2y$10$iKTN4rbbHoccgYIX1QIB5uzyZHdpTiNgWah/QxViiJ//6hlmQCmfW', 'user', '2026-01-03 18:03:51'),
(5, 'Test User', 'test@example.com', '$2y$10$AmY13P4MLqf6XPqTeANm1OFwRgbARiEBm5RkV.4DeMG9GrTpoVTO.', 'user', '2026-01-03 20:03:07');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `mealplanmeals`
--
ALTER TABLE `mealplanmeals`
  ADD PRIMARY KEY (`id`),
  ADD KEY `mealplan_id` (`mealplan_id`),
  ADD KEY `meal_id` (`meal_id`);

--
-- Indexes for table `mealplans`
--
ALTER TABLE `mealplans`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `meals`
--
ALTER TABLE `meals`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `mealplanmeals`
--
ALTER TABLE `mealplanmeals`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT for table `mealplans`
--
ALTER TABLE `mealplans`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `meals`
--
ALTER TABLE `meals`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `mealplanmeals`
--
ALTER TABLE `mealplanmeals`
  ADD CONSTRAINT `mealplanmeals_ibfk_1` FOREIGN KEY (`mealplan_id`) REFERENCES `mealplans` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `mealplanmeals_ibfk_2` FOREIGN KEY (`meal_id`) REFERENCES `meals` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `mealplans`
--
ALTER TABLE `mealplans`
  ADD CONSTRAINT `mealplans_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `meals`
--
ALTER TABLE `meals`
  ADD CONSTRAINT `meals_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

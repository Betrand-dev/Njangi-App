-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 04, 2026 at 05:58 PM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `ncap_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `contributions`
--

CREATE TABLE `contributions` (
  `id` int(10) UNSIGNED NOT NULL,
  `group_id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED DEFAULT NULL,
  `amount` decimal(12,2) NOT NULL,
  `note` varchar(512) DEFAULT NULL,
  `status` enum('pending','confirmed','rejected') DEFAULT 'pending',
  `confirmed_by` int(10) UNSIGNED DEFAULT NULL,
  `confirmed_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `contributions`
--

INSERT INTO `contributions` (`id`, `group_id`, `user_id`, `amount`, `note`, `status`, `confirmed_by`, `confirmed_at`, `created_at`) VALUES
(1, 4, 2, 1000.00, NULL, 'confirmed', 2, '2025-12-22 23:57:44', '2025-12-22 23:57:33'),
(2, 4, 1, 1000.00, NULL, 'confirmed', 2, '2025-12-23 00:02:02', '2025-12-23 00:00:53'),
(3, 1, 2, 1000.00, NULL, 'confirmed', 1, '2025-12-23 00:14:55', '2025-12-23 00:13:35'),
(4, 1, 2, 1000.00, NULL, 'confirmed', 1, '2025-12-25 15:28:31', '2025-12-23 00:13:39'),
(5, 1, 2, 1000.00, NULL, 'confirmed', 1, '2025-12-23 00:14:49', '2025-12-23 00:13:43'),
(6, 2, 2, 10000.00, NULL, 'confirmed', 1, '2025-12-23 00:15:07', '2025-12-23 00:13:50'),
(7, 2, 2, 10000.00, NULL, 'pending', NULL, NULL, '2025-12-23 00:13:52'),
(8, 3, 2, 2500.00, NULL, 'confirmed', 1, '2025-12-23 00:15:16', '2025-12-23 00:13:59'),
(9, 3, 2, 2500.00, NULL, 'pending', NULL, NULL, '2025-12-23 00:14:02'),
(10, 3, 3, 2500.00, NULL, 'pending', NULL, NULL, '2025-12-24 11:03:23'),
(11, 1, 2, 1000.00, NULL, 'confirmed', 1, '2025-12-25 15:28:34', '2025-12-25 13:33:33'),
(21, 4, 2, 1000.00, NULL, 'pending', NULL, NULL, '2025-12-25 14:12:07'),
(22, 2, 2, 10000.00, NULL, 'pending', NULL, NULL, '2025-12-25 15:01:49'),
(23, 2, 2, 10000.00, NULL, 'pending', NULL, NULL, '2026-01-17 11:58:41'),
(24, 3, 2, 2500.00, NULL, 'pending', NULL, NULL, '2026-01-17 12:11:38'),
(25, 1, 7, 1000.00, NULL, 'pending', NULL, NULL, '2026-03-03 23:42:54'),
(26, 1, 7, 1000.00, NULL, 'pending', NULL, NULL, '2026-03-03 23:44:46');

-- --------------------------------------------------------

--
-- Table structure for table `expenses`
--

CREATE TABLE `expenses` (
  `id` int(10) UNSIGNED NOT NULL,
  `tracking_id` int(10) UNSIGNED NOT NULL,
  `amount` decimal(12,2) NOT NULL CHECK (`amount` >= 0),
  `description` text DEFAULT NULL,
  `merchant` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `expenses`
--

INSERT INTO `expenses` (`id`, `tracking_id`, `amount`, `description`, `merchant`, `created_at`) VALUES
(6, 1, 200.00, 'I bought bread to eat', 'Bread', '2025-12-24 16:02:04'),
(9, 4, 5000.00, 'blalaaa', 'beans', '2026-01-17 11:56:10');

-- --------------------------------------------------------

--
-- Table structure for table `expense_trackings`
--

CREATE TABLE `expense_trackings` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `expense_trackings`
--

INSERT INTO `expense_trackings` (`id`, `user_id`, `name`, `description`, `created_at`, `updated_at`) VALUES
(1, 2, 'Monthly internet connection ', 'I want to track all my expenditures on internet connection ', '2025-12-24 09:31:39', '2025-12-24 09:31:39'),
(3, 4, 'Data', 'Møñěÿ for data', '2025-12-27 10:30:48', '2025-12-27 10:30:48'),
(4, 2, 'chop', 'to eat\n', '2026-01-17 11:53:51', '2026-01-17 11:53:51');

-- --------------------------------------------------------

--
-- Table structure for table `groups`
--

CREATE TABLE `groups` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `code` varchar(32) NOT NULL,
  `description` text DEFAULT NULL,
  `admin_id` int(10) UNSIGNED DEFAULT NULL,
  `balance` decimal(12,2) DEFAULT 0.00,
  `frequency` varchar(50) DEFAULT NULL,
  `start_date` datetime DEFAULT NULL,
  `contribution_amount` decimal(12,2) DEFAULT NULL,
  `group_type` varchar(50) DEFAULT NULL,
  `penalty` decimal(12,2) DEFAULT NULL,
  `contribution_time` time DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `end_date` date NOT NULL DEFAULT '2027-12-31',
  `max_members` int(11) NOT NULL DEFAULT 10
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `groups`
--

INSERT INTO `groups` (`id`, `name`, `code`, `description`, `admin_id`, `balance`, `frequency`, `start_date`, `contribution_amount`, `group_type`, `penalty`, `contribution_time`, `created_at`, `end_date`, `max_members`) VALUES
(1, 'Betrand', 'SRC0NX', 'Fuck you ai', 1, 4000.00, 'daily', '2025-12-27 00:00:00', 1000.00, 'savings', 200.00, '20:15:00', '2025-12-21 23:37:52', '2026-12-27', 12),
(2, '2026 contribution ', 'O17FDP', 'Another group I created for testing ', 1, 10000.00, 'monthly', '2025-12-31 00:00:00', 10000.00, 'njangi', 500.00, '13:30:00', '2025-12-22 00:20:28', '2026-12-31', 20),
(3, 'Delvaney', 'VSII83', 'We empower youths', 1, 2500.00, 'weekly', '2025-12-22 00:00:00', 2500.00, 'njangi', 250.00, '15:02:05', '2025-12-22 15:03:12', '2026-10-24', 15),
(4, 'My first ever group ', '24GOQK', 'My first ever group to try ', 2, 2000.00, 'weekly', '2025-12-23 00:00:00', 1000.00, 'savings', 200.00, '13:55:00', '2025-12-22 23:32:48', '2026-02-25', 12),
(5, 'Tryers', '0DF74J', 'I trying to see if the group code works', 2, 0.00, 'monthly', '2026-01-01 00:00:00', 10000.00, 'njangi', 5000.00, '20:30:00', '2025-12-26 15:17:11', '2026-12-31', 12),
(10, 'B4 grill', 'L38U6B', 'b4 for grill group for contribution', 2, 0.00, 'weekly', '2026-01-08 00:00:00', 10000.00, 'njangi', 100.00, '00:30:00', '2026-01-08 10:16:10', '2026-01-10', 12);

-- --------------------------------------------------------

--
-- Table structure for table `group_members`
--

CREATE TABLE `group_members` (
  `id` int(10) UNSIGNED NOT NULL,
  `group_id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `role` enum('member','admin') NOT NULL DEFAULT 'member',
  `joined_at` datetime DEFAULT current_timestamp(),
  `active` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `group_members`
--

INSERT INTO `group_members` (`id`, `group_id`, `user_id`, `role`, `joined_at`, `active`) VALUES
(1, 1, 1, 'admin', '2025-12-21 23:37:52', 1),
(2, 2, 1, 'admin', '2025-12-22 00:20:28', 1),
(3, 1, 2, 'member', '2025-12-22 00:33:15', 1),
(4, 2, 2, 'member', '2025-12-22 00:34:43', 1),
(5, 3, 1, 'admin', '2025-12-22 15:03:12', 1),
(6, 3, 2, 'member', '2025-12-22 15:06:16', 1),
(7, 4, 2, 'admin', '2025-12-22 23:32:48', 1),
(9, 4, 1, 'member', '2025-12-23 00:09:43', 1),
(11, 5, 2, 'admin', '2025-12-26 15:17:11', 1),
(17, 10, 2, 'admin', '2026-01-08 10:16:10', 1),
(18, 10, 5, 'member', '2026-01-08 10:29:32', 1),
(19, 1, 7, 'member', '2026-03-03 23:41:55', 1);

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `group_id` int(10) UNSIGNED DEFAULT NULL,
  `actor_id` int(10) UNSIGNED DEFAULT NULL,
  `type` varchar(50) NOT NULL,
  `payload` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`payload`)),
  `read_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `notifications`
--

INSERT INTO `notifications` (`id`, `user_id`, `group_id`, `actor_id`, `type`, `payload`, `read_at`, `created_at`) VALUES
(1, 1, 1, 2, 'joined_group', '{\"member_id\":2}', NULL, '2025-12-22 00:33:15'),
(2, 1, 2, 2, 'joined_group', '{\"member_id\":2}', NULL, '2025-12-22 00:34:43'),
(3, 1, 3, 2, 'joined_group', '{\"member_id\":2}', NULL, '2025-12-22 15:06:17'),
(4, 2, 4, 2, 'contribution_pending', '{\"contribution_id\":1}', NULL, '2025-12-22 23:57:33'),
(5, 2, 4, 2, 'contribution_confirmed', '{\"contribution_id\":1}', NULL, '2025-12-22 23:57:44'),
(6, 2, 4, 1, 'joined_group', '{\"member_id\":1}', NULL, '2025-12-23 00:00:10'),
(7, 1, 4, 1, 'contribution_pending', '{\"contribution_id\":2}', NULL, '2025-12-23 00:00:53'),
(8, 2, 4, 1, 'contribution_pending', '{\"contribution_id\":2}', NULL, '2025-12-23 00:00:53'),
(9, 1, 4, 2, 'contribution_confirmed', '{\"contribution_id\":2}', NULL, '2025-12-23 00:02:03'),
(10, 2, 4, 2, 'contribution_confirmed', '{\"contribution_id\":2}', NULL, '2025-12-23 00:02:03'),
(11, 1, 4, 2, 'removed_from_group', '{}', NULL, '2025-12-23 00:02:24'),
(12, 2, 4, 1, 'joined_group', '{\"member_id\":1}', NULL, '2025-12-23 00:09:43'),
(13, 1, 1, 2, 'contribution_pending', '{\"contribution_id\":3}', NULL, '2025-12-23 00:13:35'),
(14, 2, 1, 2, 'contribution_pending', '{\"contribution_id\":3}', NULL, '2025-12-23 00:13:35'),
(15, 1, 1, 2, 'contribution_pending', '{\"contribution_id\":4}', NULL, '2025-12-23 00:13:39'),
(16, 2, 1, 2, 'contribution_pending', '{\"contribution_id\":4}', NULL, '2025-12-23 00:13:39'),
(17, 1, 1, 2, 'contribution_pending', '{\"contribution_id\":5}', NULL, '2025-12-23 00:13:43'),
(18, 2, 1, 2, 'contribution_pending', '{\"contribution_id\":5}', NULL, '2025-12-23 00:13:43'),
(19, 1, 2, 2, 'contribution_pending', '{\"contribution_id\":6}', NULL, '2025-12-23 00:13:50'),
(20, 2, 2, 2, 'contribution_pending', '{\"contribution_id\":6}', NULL, '2025-12-23 00:13:50'),
(21, 1, 2, 2, 'contribution_pending', '{\"contribution_id\":7}', NULL, '2025-12-23 00:13:52'),
(22, 2, 2, 2, 'contribution_pending', '{\"contribution_id\":7}', NULL, '2025-12-23 00:13:52'),
(23, 1, 3, 2, 'contribution_pending', '{\"contribution_id\":8}', NULL, '2025-12-23 00:13:59'),
(24, 2, 3, 2, 'contribution_pending', '{\"contribution_id\":8}', NULL, '2025-12-23 00:13:59'),
(25, 1, 3, 2, 'contribution_pending', '{\"contribution_id\":9}', NULL, '2025-12-23 00:14:02'),
(26, 2, 3, 2, 'contribution_pending', '{\"contribution_id\":9}', NULL, '2025-12-23 00:14:02'),
(27, 1, 1, 1, 'contribution_confirmed', '{\"contribution_id\":5}', NULL, '2025-12-23 00:14:49'),
(28, 2, 1, 1, 'contribution_confirmed', '{\"contribution_id\":5}', NULL, '2025-12-23 00:14:49'),
(29, 1, 1, 1, 'contribution_confirmed', '{\"contribution_id\":3}', NULL, '2025-12-23 00:14:55'),
(30, 2, 1, 1, 'contribution_confirmed', '{\"contribution_id\":3}', NULL, '2025-12-23 00:14:55'),
(31, 1, 2, 1, 'contribution_confirmed', '{\"contribution_id\":6}', NULL, '2025-12-23 00:15:07'),
(32, 2, 2, 1, 'contribution_confirmed', '{\"contribution_id\":6}', NULL, '2025-12-23 00:15:07'),
(33, 1, 3, 1, 'contribution_confirmed', '{\"contribution_id\":8}', NULL, '2025-12-23 00:15:17'),
(34, 2, 3, 1, 'contribution_confirmed', '{\"contribution_id\":8}', NULL, '2025-12-23 00:15:17'),
(35, 1, 3, 3, 'joined_group', '{\"member_id\":3}', NULL, '2025-12-24 11:03:02'),
(36, 2, 3, 3, 'joined_group', '{\"member_id\":3}', NULL, '2025-12-24 11:03:02'),
(37, 1, 3, 3, 'contribution_pending', '{\"contribution_id\":10}', NULL, '2025-12-24 11:03:23'),
(38, 2, 3, 3, 'contribution_pending', '{\"contribution_id\":10}', NULL, '2025-12-24 11:03:23'),
(39, 3, 3, 3, 'contribution_pending', '{\"contribution_id\":10}', NULL, '2025-12-24 11:03:23'),
(40, 1, 1, 2, 'contribution_pending', '{\"contribution_id\":11}', NULL, '2025-12-25 13:33:33'),
(41, 2, 1, 2, 'contribution_pending', '{\"contribution_id\":11}', NULL, '2025-12-25 13:33:33'),
(60, 1, 4, 2, 'contribution_pending', '{\"contribution_id\":21}', NULL, '2025-12-25 14:12:07'),
(61, 2, 4, 2, 'contribution_pending', '{\"contribution_id\":21}', NULL, '2025-12-25 14:12:07'),
(62, 1, 2, 2, 'contribution_pending', '{\"contribution_id\":22}', NULL, '2025-12-25 15:01:49'),
(63, 2, 2, 2, 'contribution_pending', '{\"contribution_id\":22}', NULL, '2025-12-25 15:01:49'),
(64, 1, 1, 1, 'contribution_confirmed', '{\"contribution_id\":4}', NULL, '2025-12-25 15:28:31'),
(65, 2, 1, 1, 'contribution_confirmed', '{\"contribution_id\":4}', NULL, '2025-12-25 15:28:31'),
(66, 1, 1, 1, 'contribution_confirmed', '{\"contribution_id\":11}', NULL, '2025-12-25 15:28:35'),
(67, 2, 1, 1, 'contribution_confirmed', '{\"contribution_id\":11}', NULL, '2025-12-25 15:28:35'),
(68, 3, 3, 1, 'removed_from_group', '{}', NULL, '2025-12-25 15:38:09'),
(69, 1, 4, 4, 'joined_group', '{\"member_id\":4}', NULL, '2025-12-27 10:32:23'),
(70, 2, 4, 4, 'joined_group', '{\"member_id\":4}', NULL, '2025-12-27 10:32:23'),
(71, 4, 4, 2, 'removed_from_group', '{}', NULL, '2025-12-27 10:33:20'),
(72, 2, 10, 5, 'joined_group', '{\"member_id\":5}', NULL, '2026-01-08 10:29:32'),
(73, 1, 2, 2, 'contribution_pending', '{\"contribution_id\":23}', NULL, '2026-01-17 11:58:41'),
(74, 2, 2, 2, 'contribution_pending', '{\"contribution_id\":23}', NULL, '2026-01-17 11:58:41'),
(75, 1, 3, 2, 'contribution_pending', '{\"contribution_id\":24}', NULL, '2026-01-17 12:11:38'),
(76, 2, 3, 2, 'contribution_pending', '{\"contribution_id\":24}', NULL, '2026-01-17 12:11:38'),
(77, 1, 1, 7, 'joined_group', '{\"member_id\":7}', NULL, '2026-03-03 23:41:55'),
(78, 2, 1, 7, 'joined_group', '{\"member_id\":7}', NULL, '2026-03-03 23:41:55'),
(79, 1, 1, 7, 'contribution_pending', '{\"contribution_id\":25}', NULL, '2026-03-03 23:42:54'),
(80, 2, 1, 7, 'contribution_pending', '{\"contribution_id\":25}', NULL, '2026-03-03 23:42:54'),
(81, 7, 1, 7, 'contribution_pending', '{\"contribution_id\":25}', NULL, '2026-03-03 23:42:54'),
(82, 1, 1, 7, 'contribution_pending', '{\"contribution_id\":26}', NULL, '2026-03-03 23:44:46'),
(83, 2, 1, 7, 'contribution_pending', '{\"contribution_id\":26}', NULL, '2026-03-03 23:44:46'),
(84, 7, 1, 7, 'contribution_pending', '{\"contribution_id\":26}', NULL, '2026-03-03 23:44:46');

-- --------------------------------------------------------

--
-- Table structure for table `refresh_tokens`
--

CREATE TABLE `refresh_tokens` (
  `id` int(10) UNSIGNED NOT NULL,
  `jti` varchar(255) NOT NULL,
  `token` text NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `revoked` tinyint(1) DEFAULT 0,
  `expires_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `refresh_tokens`
--

INSERT INTO `refresh_tokens` (`id`, `jti`, `token`, `user_id`, `revoked`, `expires_at`, `created_at`) VALUES
(1, '43a389f9-8311-40b4-87e4-3e413ab93389', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjM1MDc0MCwianRpIjoiNDNhMzg5ZjktODMxMS00MGI0LTg3ZTQtM2U0MTNhYjkzMzg5IiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIxIiwibmJmIjoxNzY2MzUwNzQwLCJjc3JmIjoiZWVhNDgzYmYtYjdjMC00ZGNiLWI3ODQtZjBiODBlM2E0Y2E5IiwiZXhwIjoxNzY4OTQyNzQwfQ.pxm3k_oWpbVBC5hoEml3mSYaDTZEU1r3KuJk6vM_bOg', 1, 1, '2026-01-20 20:59:00', '2025-12-21 21:59:00'),
(2, '49a1978d-b138-4271-b4ea-87c248e9feb7', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjM1MDgwMSwianRpIjoiNDlhMTk3OGQtYjEzOC00MjcxLWI0ZWEtODdjMjQ4ZTlmZWI3IiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIxIiwibmJmIjoxNzY2MzUwODAxLCJjc3JmIjoiMmRkNTVlNDctZTQ3OS00OGEzLTk4OTYtZDAxYzM5MWEzY2RhIiwiZXhwIjoxNzY4OTQyODAxfQ.oHdQbL1NNJUjhnaf4-UNokvjDZEx6er89g20dv3I3_k', 1, 0, '2026-01-20 21:00:01', '2025-12-21 22:00:01'),
(3, '364d6d8a-d1a0-452d-81b9-7345b23e0f36', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjM1MzU0MiwianRpIjoiMzY0ZDZkOGEtZDFhMC00NTJkLTgxYjktNzM0NWIyM2UwZjM2IiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIxIiwibmJmIjoxNzY2MzUzNTQyLCJjc3JmIjoiYzhhM2FjNjgtNGJiNC00ODBkLWExODYtZTE5ZmM2M2FmNDAxIiwiZXhwIjoxNzY4OTQ1NTQyfQ.Kqna6e0NuR2jEUhdqTo4ShEqoEsEAngW1r2pSnNY3Jk', 1, 1, '2026-01-20 21:45:42', '2025-12-21 22:45:42'),
(4, 'e5879c1e-d1e4-47be-b7d4-4a4526caa572', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjM1NDE5OSwianRpIjoiZTU4NzljMWUtZDFlNC00N2JlLWI3ZDQtNGE0NTI2Y2FhNTcyIiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIxIiwibmJmIjoxNzY2MzU0MTk5LCJjc3JmIjoiYjlkM2UwM2QtZDNhZC00NjEwLWI1NmQtYjE0MzM2Nzk4ODA2IiwiZXhwIjoxNzY4OTQ2MTk5fQ.XPHrcguVcIwr92G76eNAm_bCngQNZ7lKwG4pLFmIn_U', 1, 0, '2026-01-20 21:56:39', '2025-12-21 22:56:39'),
(5, '6ac408ec-ad58-4418-ae53-da20ec05a044', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjM1NDYzNiwianRpIjoiNmFjNDA4ZWMtYWQ1OC00NDE4LWFlNTMtZGEyMGVjMDVhMDQ0IiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIxIiwibmJmIjoxNzY2MzU0NjM2LCJjc3JmIjoiYzlkMTM0NTctNGQ5OC00NDk0LWE0OGYtZmJhMWQ2YzVlYTcyIiwiZXhwIjoxNzY4OTQ2NjM2fQ.-Lk-UXKt2VRvRRvvaiEnmsAHvZJRX3KXaKM4CMLrWVo', 1, 0, '2026-01-20 22:03:56', '2025-12-21 23:03:56'),
(6, '002a6a4d-3138-489c-8c19-96d9a93f50c1', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjM1NDYzNywianRpIjoiMDAyYTZhNGQtMzEzOC00ODljLThjMTktOTZkOWE5M2Y1MGMxIiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIxIiwibmJmIjoxNzY2MzU0NjM3LCJjc3JmIjoiZTJlZGE3ZmYtZGY4Ni00MThhLWIwOGYtODNkODMxNzdlN2E4IiwiZXhwIjoxNzY4OTQ2NjM3fQ.w-pm6THvoo7xo3-MViqb46jWQs_I8PiC_f_ZwH-d6U8', 1, 0, '2026-01-20 22:03:57', '2025-12-21 23:03:57'),
(7, '6b24ff20-1a87-4e53-a640-3f074630d717', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjM1NTU0MywianRpIjoiNmIyNGZmMjAtMWE4Ny00ZTUzLWE2NDAtM2YwNzQ2MzBkNzE3IiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIxIiwibmJmIjoxNzY2MzU1NTQzLCJjc3JmIjoiM2E0NzA3ZDUtNjE3ZC00MjRmLWJjMDgtNjNjOTE0ZGZiOTVlIiwiZXhwIjoxNzY4OTQ3NTQzfQ.p2K3R-BXG_4dONIa5xT9tWCn405MJAl1VlexAKJYo_U', 1, 0, '2026-01-20 22:19:03', '2025-12-21 23:19:03'),
(8, 'd3ea6a51-e310-440f-bcdb-7fb4aa4c39bc', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjM1NjU3MywianRpIjoiZDNlYTZhNTEtZTMxMC00NDBmLWJjZGItN2ZiNGFhNGMzOWJjIiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIxIiwibmJmIjoxNzY2MzU2NTczLCJjc3JmIjoiYWU2OThiNGItYWYwMC00ZWE1LTg5OGEtYzJhZWQ3OGIzMzFiIiwiZXhwIjoxNzY4OTQ4NTczfQ.T-G7IvH9YV_VYC7ESHw2uP9B5AZGmFWfQ-fRvByox5A', 1, 0, '2026-01-20 22:36:13', '2025-12-21 23:36:13'),
(9, 'bf581720-b711-4aa3-b6ee-7c616da44a66', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjM1ODczMCwianRpIjoiYmY1ODE3MjAtYjcxMS00YWEzLWI2ZWUtN2M2MTZkYTQ0YTY2IiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIxIiwibmJmIjoxNzY2MzU4NzMwLCJjc3JmIjoiOTljYWVhNTgtZDliNy00ZmY3LTg3OTEtMzhlMGM1ZmNlNzc5IiwiZXhwIjoxNzY4OTUwNzMwfQ.6zOgaGXENMePYfQdb3EL4fK2ycCs2Bnr8Jk69nAlVH0', 1, 0, '2026-01-20 23:12:10', '2025-12-22 00:12:10'),
(10, 'b5d1c0dd-8152-4797-89f3-cc60a923c34a', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjM1ODczMSwianRpIjoiYjVkMWMwZGQtODE1Mi00Nzk3LTg5ZjMtY2M2MGE5MjNjMzRhIiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIxIiwibmJmIjoxNzY2MzU4NzMxLCJjc3JmIjoiZjUyMWVlYjEtMDYyNC00MjE0LWJmOTAtNmRjNjMzMTgwMGFhIiwiZXhwIjoxNzY4OTUwNzMxfQ.R6v-dMKQ3-w4h30I9dBOFYWN3F3gQKgXfsQwUztSreU', 1, 1, '2026-01-20 23:12:11', '2025-12-22 00:12:11'),
(11, '05bc6da4-a920-48c7-a9d2-3e5683c7f574', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjM1ODgyOCwianRpIjoiMDViYzZkYTQtYTkyMC00OGM3LWE5ZDItM2U1NjgzYzdmNTc0IiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIxIiwibmJmIjoxNzY2MzU4ODI4LCJjc3JmIjoiNmNkNzA5NjAtOGFiYi00MDY3LWIwMWMtNDQwZjI2NzE2OTZhIiwiZXhwIjoxNzY4OTUwODI4fQ.PRL4HTSMFap01Cwv5UFXF2RODS0lSTkUs8gK_DxDhxs', 1, 1, '2026-01-20 23:13:48', '2025-12-22 00:13:48'),
(12, 'e702061a-6cc1-49b2-b2cd-835b01d41e64', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjM1OTI3MiwianRpIjoiZTcwMjA2MWEtNmNjMS00OWIyLWIyY2QtODM1YjAxZDQxZTY0IiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIxIiwibmJmIjoxNzY2MzU5MjcyLCJjc3JmIjoiNjlkYTI0YjYtYmM5NC00YTUwLWFhNTctMmU1YmE2OWUwZDc0IiwiZXhwIjoxNzY4OTUxMjcyfQ.0RjsrY_awLg3J415FXRGEobAvHH2iZ0tLpNAN4hjK_w', 1, 0, '2026-01-20 23:21:12', '2025-12-22 00:21:12'),
(13, '8e3cd05c-c2ae-400f-b0d5-95e9b51753a3', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjM1OTY5NywianRpIjoiOGUzY2QwNWMtYzJhZS00MDBmLWIwZDUtOTVlOWI1MTc1M2EzIiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIxIiwibmJmIjoxNzY2MzU5Njk3LCJjc3JmIjoiZDIzNDc2MGMtM2MwZC00YmNmLWJmMDMtZTgxYWYwZWQ3ZGI3IiwiZXhwIjoxNzY4OTUxNjk3fQ.u1-ym2uGcfs26eVXHI6oC8WgV2uqr5zWwaDI555SB8U', 1, 0, '2026-01-20 23:28:17', '2025-12-22 00:28:17'),
(14, '6c20de05-6d1f-4ef7-a99b-c725adc6098a', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjM1OTgyNywianRpIjoiNmMyMGRlMDUtNmQxZi00ZWY3LWE5OWItYzcyNWFkYzYwOThhIiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIxIiwibmJmIjoxNzY2MzU5ODI3LCJjc3JmIjoiYTY2MmRjOTktNDcwYy00ZjczLTg0YTMtNmIxMzE1MmFjMmVjIiwiZXhwIjoxNzY4OTUxODI3fQ.jWERWlHRr6a2-Tn2tqgFCpLFkiXVHt54vfMSnZaLvUU', 1, 1, '2026-01-20 23:30:27', '2025-12-22 00:30:27'),
(15, '1306d0b3-6eb1-4cdb-8a4a-be580893616b', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjM1OTk0NCwianRpIjoiMTMwNmQwYjMtNmViMS00Y2RiLThhNGEtYmU1ODA4OTM2MTZiIiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2MzU5OTQ0LCJjc3JmIjoiOTUwYTBkODItYmNjMS00MTFhLWFhOWMtNGRkY2NjZDgyM2U4IiwiZXhwIjoxNzY4OTUxOTQ0fQ.6vmCrhQkL0CiHY7kM1GzybXOd9JmchaUMjw--dCz_fY', 2, 0, '2026-01-20 23:32:24', '2025-12-22 00:32:24'),
(16, '1e13a406-ac10-45f0-80bb-09a7ced542fc', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjQwODA4MywianRpIjoiMWUxM2E0MDYtYWMxMC00NWYwLTgwYmItMDlhN2NlZDU0MmZjIiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIxIiwibmJmIjoxNzY2NDA4MDgzLCJjc3JmIjoiZTU5MmY1YzgtZDY3YS00Y2RiLTgzYmMtNTI3Mjg0OGQ1ZDRiIiwiZXhwIjoxNzY5MDAwMDgzfQ.Bsqbr-BzH2M7ADAPps41dfef2UUkYMaCyvcYoc2oyxs', 1, 0, '2026-01-21 12:54:43', '2025-12-22 13:54:43'),
(17, '4eec8d15-b040-45a7-b0c0-a07a201c10e9', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjQwODcwOCwianRpIjoiNGVlYzhkMTUtYjA0MC00NWE3LWIwYzAtYTA3YTIwMWMxMGU5IiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIxIiwibmJmIjoxNzY2NDA4NzA4LCJjc3JmIjoiMDc5MmYxM2ItN2QwOC00ZTVkLThjNTYtNDMzN2RmNzNiNDE3IiwiZXhwIjoxNzY5MDAwNzA4fQ.ApSvQ83mYBelMnd6NUQ9j-rNYBm6w39UtwHgzrcNXRg', 1, 0, '2026-01-21 13:05:08', '2025-12-22 14:05:08'),
(18, '47e9e150-4523-4846-acc8-011106dcc7e7', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjQxMDg0NiwianRpIjoiNDdlOWUxNTAtNDUyMy00ODQ2LWFjYzgtMDExMTA2ZGNjN2U3IiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIxIiwibmJmIjoxNzY2NDEwODQ2LCJjc3JmIjoiNzQyMDk5NTktNWM3NS00ZGZlLWE0NDQtMTMwYjI3YmFkMmY3IiwiZXhwIjoxNzY5MDAyODQ2fQ.UWAQLJeDdVWXPZavY3GrHVoBY941rC1zRLi1i1rtTBE', 1, 0, '2026-01-21 13:40:46', '2025-12-22 14:40:46'),
(19, '4f4958e9-c17a-4267-bd11-4dd74d71b719', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjQxMTQ2NCwianRpIjoiNGY0OTU4ZTktYzE3YS00MjY3LWJkMTEtNGRkNzRkNzFiNzE5IiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIxIiwibmJmIjoxNzY2NDExNDY0LCJjc3JmIjoiZGJjZDcxMmQtMWI1Mi00ODExLWFmMmItNGI1Yjc2Y2I1NTg2IiwiZXhwIjoxNzY5MDAzNDY0fQ.K6YIbA5i14I0F2SLfz4Leqzv-2-k71L0H7C87X61rsI', 1, 1, '2026-01-21 13:51:04', '2025-12-22 14:51:04'),
(20, '1b3b37c8-1faf-442a-8fca-ae1bcc675698', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjQxMTk4MywianRpIjoiMWIzYjM3YzgtMWZhZi00NDJhLThmY2EtYWUxYmNjNjc1Njk4IiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIxIiwibmJmIjoxNzY2NDExOTgzLCJjc3JmIjoiMjFmOWU0MzctOTU4MC00MzQxLWEyNjUtMjFmN2VlMjVhOTlmIiwiZXhwIjoxNzY5MDAzOTgzfQ.WLlmwxqQh4xxUx-2fjPbS7bV8v4SBmFxeQoVxxg590E', 1, 1, '2026-01-21 13:59:43', '2025-12-22 14:59:43'),
(21, '883c8308-9800-48f1-8da5-6b82df509707', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjQxMjIzNywianRpIjoiODgzYzgzMDgtOTgwMC00OGYxLThkYTUtNmI4MmRmNTA5NzA3IiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2NDEyMjM3LCJjc3JmIjoiNTM0YjllM2EtNmUwNy00NjExLWFjNzMtYzYzNGQ2MjA5ZTI5IiwiZXhwIjoxNzY5MDA0MjM3fQ.W2HaLYKmNnIfeqc-dMKOyqK-amyBAM77O-RhSdUzTYw', 2, 1, '2026-01-21 14:03:57', '2025-12-22 15:03:57'),
(22, '490e897f-16aa-497a-aae9-8b0b3d63f7df', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjQxMjQ1MiwianRpIjoiNDkwZTg5N2YtMTZhYS00OTdhLWFhZTktOGIwYjNkNjNmN2RmIiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIxIiwibmJmIjoxNzY2NDEyNDUyLCJjc3JmIjoiMDdlM2ViZGQtMGRkMC00YzhlLWJmYmUtOWYzMDIzZTFkYmUxIiwiZXhwIjoxNzY5MDA0NDUyfQ.aUbZ_4rhsuSKOqassaurfvp7IlnXwLLT_zxdRinB0Ig', 1, 0, '2026-01-21 14:07:32', '2025-12-22 15:07:32'),
(23, 'da8e5f7a-830b-4ea1-8fab-53273ca714fe', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjQxMjUzMCwianRpIjoiZGE4ZTVmN2EtODMwYi00ZWExLThmYWItNTMyNzNjYTcxNGZlIiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIxIiwibmJmIjoxNzY2NDEyNTMwLCJjc3JmIjoiMzQ3ZmNjM2YtNjZhZS00YjU4LThkMjYtMmE1OGFmNWRjMmNjIiwiZXhwIjoxNzY5MDA0NTMwfQ.l1VN2JRmARMlOrod2nw5g8TkOrV2iXtzMPC7cEUW2XY', 1, 1, '2026-01-21 14:08:50', '2025-12-22 15:08:50'),
(24, '21c3caff-a2b2-4ede-83ba-d593c185b54b', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjQxMjYxMywianRpIjoiMjFjM2NhZmYtYTJiMi00ZWRlLTgzYmEtZDU5M2MxODViNTRiIiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2NDEyNjEzLCJjc3JmIjoiZGMyMzhiODAtNTUyMS00ZDY1LWExZjgtNjU1YjZhZjg2YzNmIiwiZXhwIjoxNzY5MDA0NjEzfQ.MalZVmcmzMq5NyRV6zcWmkgnBU8FV1J7DnRB3LuNEBs', 2, 0, '2026-01-21 14:10:13', '2025-12-22 15:10:13'),
(25, '92890757-5b95-40bf-9f8b-66901784b8a4', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjQxMzYyNiwianRpIjoiOTI4OTA3NTctNWI5NS00MGJmLTlmOGItNjY5MDE3ODRiOGE0IiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2NDEzNjI2LCJjc3JmIjoiNjQ3MTk2NzYtYWZiNy00ZWI2LWExMTAtYWMyZDNhM2NjOWEyIiwiZXhwIjoxNzY5MDA1NjI2fQ.SbRcncbwGSu0JjJKqgUf5bkWOv6IqPZyjA5EPGepVzY', 2, 0, '2026-01-21 14:27:06', '2025-12-22 15:27:06'),
(26, 'b6bcd7bb-cce3-49a4-a9bc-7ab19931d3bb', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjQxNDU4OCwianRpIjoiYjZiY2Q3YmItY2NlMy00OWE0LWE5YmMtN2FiMTk5MzFkM2JiIiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2NDE0NTg4LCJjc3JmIjoiYmYzODkxYjQtODM2OC00OTMyLWE4ZTgtNjkyZmUxMmI0ZWVlIiwiZXhwIjoxNzY5MDA2NTg4fQ.qY1jBnh6k3IH3Yio4FpfWVb-zDj1Pw6CkhCnFO4GeiI', 2, 0, '2026-01-21 14:43:08', '2025-12-22 15:43:08'),
(27, 'fbbff5be-2081-4147-947e-95e5d4e67b6a', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjQxNTYwNCwianRpIjoiZmJiZmY1YmUtMjA4MS00MTQ3LTk0N2UtOTVlNWQ0ZTY3YjZhIiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIxIiwibmJmIjoxNzY2NDE1NjA0LCJjc3JmIjoiZGFkZDVmNTYtMDA5Mi00NDIzLTkxZTktMDVjMDY0NzU2OTVlIiwiZXhwIjoxNzY5MDA3NjA0fQ.Zr3OVuCqVnQxgl1suTeXG50vRvE9FeV8nGizbOPOACk', 1, 0, '2026-01-21 15:00:04', '2025-12-22 16:00:04'),
(28, 'fb415048-aec5-4dcd-81a6-7ee90b1c8a79', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjQxNTg4MywianRpIjoiZmI0MTUwNDgtYWVjNS00ZGNkLTgxYTYtN2VlOTBiMWM4YTc5IiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2NDE1ODgzLCJjc3JmIjoiMTk5ZWNiM2EtZTU5Yi00NmIwLWIwM2ItMDAxMDMwMmYxMTA3IiwiZXhwIjoxNzY5MDA3ODgzfQ.Y2pFVqRDYT1ox8innSHP74d-9nUICZ96yX1jiHPZqj0', 2, 0, '2026-01-21 15:04:43', '2025-12-22 16:04:43'),
(29, '71726209-0b61-47d4-b71a-ca83ad3c6b4c', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjQxNjA5MywianRpIjoiNzE3MjYyMDktMGI2MS00N2Q0LWI3MWEtY2E4M2FkM2M2YjRjIiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2NDE2MDkzLCJjc3JmIjoiN2NlMGU4MTctOWIwNy00NTVjLTk3MDItYjk3YjU1ZTJjNWNlIiwiZXhwIjoxNzY5MDA4MDkzfQ.A4ppbQE8b-21LiRSuESh41_EPxIqUqp6e-DycBTLToo', 2, 0, '2026-01-21 15:08:13', '2025-12-22 16:08:13'),
(30, '79ac6ec6-daff-492c-bafa-649cac33d0f5', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjQxNjE3NSwianRpIjoiNzlhYzZlYzYtZGFmZi00OTJjLWJhZmEtNjQ5Y2FjMzNkMGY1IiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2NDE2MTc1LCJjc3JmIjoiM2QzMmI3YmMtMzEzNC00MThjLWFjYzgtZWYyY2E1MTVkNTY4IiwiZXhwIjoxNzY5MDA4MTc1fQ.4PvYQXkShVoNql-UvpbUiazpV_V4SaPQP5H2wq00_4E', 2, 0, '2026-01-21 15:09:35', '2025-12-22 16:09:35'),
(31, 'e1d2368c-9d0d-4dd8-a3ae-91e19b896be6', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjQxNzA3OCwianRpIjoiZTFkMjM2OGMtOWQwZC00ZGQ4LWEzYWUtOTFlMTliODk2YmU2IiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2NDE3MDc4LCJjc3JmIjoiZjhkZWQzNDgtYWMzMi00MjYzLTlhYTMtYmQzMTdjZmQ1NDMxIiwiZXhwIjoxNzY5MDA5MDc4fQ.FgR4BEk56flW96FzGPgKEijvUOtJid37csw49QO5HIg', 2, 0, '2026-01-21 15:24:38', '2025-12-22 16:24:38'),
(32, 'cba1e3e0-d3a9-4242-bba8-48ef293aece5', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjQxNzYxNywianRpIjoiY2JhMWUzZTAtZDNhOS00MjQyLWJiYTgtNDhlZjI5M2FlY2U1IiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2NDE3NjE3LCJjc3JmIjoiYzQ5M2E5MmMtZWU0Zi00ODhkLWE4YTItODQ3YjAzOWY3N2FlIiwiZXhwIjoxNzY5MDA5NjE3fQ.3cXuN4L9AxAQJPOIUxgdoBUNNk7RG8mBfdud_rB-Das', 2, 0, '2026-01-21 15:33:37', '2025-12-22 16:33:37'),
(33, 'b6e1869f-e2b5-4d14-83bd-a88de3f94e91', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjQxNzc3NywianRpIjoiYjZlMTg2OWYtZTJiNS00ZDE0LTgzYmQtYTg4ZGUzZjk0ZTkxIiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2NDE3Nzc3LCJjc3JmIjoiNTIxYjAwMTAtOTExZC00ZjdiLWJhNzgtMWU0NWJiODZkOThmIiwiZXhwIjoxNzY5MDA5Nzc3fQ.kQKOqFDV37nyikE6PXe6Gd3mZUidDjk18-UuYBv4H8A', 2, 0, '2026-01-21 15:36:17', '2025-12-22 16:36:17'),
(34, 'e83889cc-0028-44e0-9b82-b94a0f48b40d', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjQxODA4OSwianRpIjoiZTgzODg5Y2MtMDAyOC00NGUwLTliODItYjk0YTBmNDhiNDBkIiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2NDE4MDg5LCJjc3JmIjoiM2E0MmNjNWUtNmEwMC00NTRlLThhNWItZTBkNWM1NDA4MTUzIiwiZXhwIjoxNzY5MDEwMDg5fQ.KkAfUEOoKgat8_1x9h6B5B4i-WkAZlD1eQSzbaa22-E', 2, 0, '2026-01-21 15:41:29', '2025-12-22 16:41:29'),
(35, '1fe5ab06-00fd-412d-b34c-c1d00063399f', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjQzNTk5OSwianRpIjoiMWZlNWFiMDYtMDBmZC00MTJkLWIzNGMtYzFkMDAwNjMzOTlmIiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2NDM1OTk5LCJjc3JmIjoiNzUzYThjYTgtYjk0Yi00ZDM0LWI1N2UtMjZmMzc4MjM3OWNmIiwiZXhwIjoxNzY5MDI3OTk5fQ.zZc_Cp69aRGiyl3fknSAJErPXv3BCe1Sv4qq5TnU56Q', 2, 0, '2026-01-21 20:39:59', '2025-12-22 21:39:59'),
(36, 'c8ae2f50-10ad-44cf-aa78-7cdfec228296', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjQzNjI1OSwianRpIjoiYzhhZTJmNTAtMTBhZC00NGNmLWFhNzgtN2NkZmVjMjI4Mjk2IiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2NDM2MjU5LCJjc3JmIjoiY2YxNjdiNzItMTFhYS00ZTRmLWEyOGUtYjg5ZDM0NGEyMTJmIiwiZXhwIjoxNzY5MDI4MjU5fQ.LUqxkY9ASsZYadh3539Z7XfxjxOLwR5aTntS4hry_gI', 2, 0, '2026-01-21 20:44:19', '2025-12-22 21:44:19'),
(37, 'd7f76a09-2228-4a4b-ba76-af612589359a', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjQzODIwMCwianRpIjoiZDdmNzZhMDktMjIyOC00YTRiLWJhNzYtYWY2MTI1ODkzNTlhIiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2NDM4MjAwLCJjc3JmIjoiMWQ3NGQ0N2YtZDg4YS00MzI4LWJiMWYtNmY1MzFhODBjNzYyIiwiZXhwIjoxNzY5MDMwMjAwfQ.CD9JFpdO09_HptxnvoqcjVrZgK5YtriHb_GhPrCORhI', 2, 0, '2026-01-21 21:16:40', '2025-12-22 22:16:40'),
(38, '252ec082-f7a6-4716-9ff2-892607b86dd2', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjQzODY3NywianRpIjoiMjUyZWMwODItZjdhNi00NzE2LTlmZjItODkyNjA3Yjg2ZGQyIiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2NDM4Njc3LCJjc3JmIjoiMDExNGEwYzAtZDY4Ni00OGJhLWE0ZWUtNDk1OTJmNGM2NWFjIiwiZXhwIjoxNzY5MDMwNjc3fQ.L7VGcNvDtIKBh8wpLVgH7wyO0lcwKnFLJLC96VJD-qg', 2, 0, '2026-01-21 21:24:37', '2025-12-22 22:24:37'),
(39, 'fcfd8e34-ccda-41cf-b9c7-5bdee216a298', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjQzOTI2NiwianRpIjoiZmNmZDhlMzQtY2NkYS00MWNmLWI5YzctNWJkZWUyMTZhMjk4IiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2NDM5MjY2LCJjc3JmIjoiYmIwZjYwMDUtNzhlYy00MDViLWE5ODktYzUwNDBlZGQwMTkyIiwiZXhwIjoxNzY5MDMxMjY2fQ.7MLGktlcMBoAMRid7RTIf4OMh-kUapYhogpAUQfIY64', 2, 1, '2026-01-21 21:34:26', '2025-12-22 22:34:26'),
(40, '7936404e-a453-4b46-b4ce-06d8f011e5df', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjQ0MTIxNywianRpIjoiNzkzNjQwNGUtYTQ1My00YjQ2LWI0Y2UtMDZkOGYwMTFlNWRmIiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIxIiwibmJmIjoxNzY2NDQxMjE3LCJjc3JmIjoiM2ZmOTg5MTMtNmNjZC00NzNiLWE1YzItMzU5YzFlNzU0NjExIiwiZXhwIjoxNzY5MDMzMjE3fQ.g-TBYMa0nTXtxI324SDXD6z6Bn9mdBqR8gM58BhYSnw', 1, 0, '2026-01-21 22:06:57', '2025-12-22 23:06:57'),
(41, '093c8c8a-952e-4004-b38a-def489b793a9', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjQ0MTc2MiwianRpIjoiMDkzYzhjOGEtOTUyZS00MDA0LWIzOGEtZGVmNDg5Yjc5M2E5IiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIxIiwibmJmIjoxNzY2NDQxNzYyLCJjc3JmIjoiMDZmYTQ2ZjEtZWIxNi00N2JlLThjZjEtMjQ1OWIwOWExNTkxIiwiZXhwIjoxNzY5MDMzNzYyfQ.3gaaVqkEwd0CyHI6FFXpgcQ1g6CiTnsBi94OgldfViY', 1, 1, '2026-01-21 22:16:02', '2025-12-22 23:16:02'),
(42, 'a444d343-52ae-4c3f-b0f6-a4416c759abc', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjQ0MTgxOCwianRpIjoiYTQ0NGQzNDMtNTJhZS00YzNmLWIwZjYtYTQ0MTZjNzU5YWJjIiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIxIiwibmJmIjoxNzY2NDQxODE4LCJjc3JmIjoiNjUyMzk1NjAtMDU1NC00ZDg2LWFhOTAtOWU3NDkyMzlmNzY4IiwiZXhwIjoxNzY5MDMzODE4fQ.ILacUglTPw_-IAQ2EhOYafeaCxIHgFXaOITqvYOyBPE', 1, 0, '2026-01-21 22:16:58', '2025-12-22 23:16:58'),
(43, 'fcd541ff-4ea6-4800-8270-af15ebf470e5', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjQ0MjYzOCwianRpIjoiZmNkNTQxZmYtNGVhNi00ODAwLTgyNzAtYWYxNWViZjQ3MGU1IiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIxIiwibmJmIjoxNzY2NDQyNjM4LCJjc3JmIjoiZTBmNGM2NGMtMDM3ZS00OWQwLWI2YjgtZDBmNjc2NDBmZmQ1IiwiZXhwIjoxNzY5MDM0NjM4fQ.u1ojwfFgOO7ZVxAUJDG4wtrKX7xjASav2Mb0v_wUVF0', 1, 1, '2026-01-21 22:30:38', '2025-12-22 23:30:38'),
(44, '0c3a5570-3827-4d58-9e64-ec84ffc28e91', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjQ0MjY4NywianRpIjoiMGMzYTU1NzAtMzgyNy00ZDU4LTllNjQtZWM4NGZmYzI4ZTkxIiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2NDQyNjg3LCJjc3JmIjoiMjM4YWMwODMtMzAwMS00MTNjLWJlY2EtOGZhOWYyMjgzZGVlIiwiZXhwIjoxNzY5MDM0Njg3fQ.SKElOdhj92N85gTKU8XA3EpbYafVggHEbfekcRqk2ek', 2, 1, '2026-01-21 22:31:27', '2025-12-22 23:31:27'),
(45, 'c60638a4-e025-4f35-ac97-04941ce134b7', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjQ0NDM2NSwianRpIjoiYzYwNjM4YTQtZTAyNS00ZjM1LWFjOTctMDQ5NDFjZTEzNGI3IiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIxIiwibmJmIjoxNzY2NDQ0MzY1LCJjc3JmIjoiMDVjMWJiODMtYWU5Yi00NjQzLTk3MjktNWM2NjkyMDFiOTRjIiwiZXhwIjoxNzY5MDM2MzY1fQ.zBXfWQFTKRxUc1d3UpVBA7kF4CcG4MgxNQzAr1s1p-w', 1, 1, '2026-01-21 22:59:25', '2025-12-22 23:59:25'),
(46, '3b1ccdfa-5cbe-4be9-8a30-2791a47d9b80', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjQ0NDQ4NSwianRpIjoiM2IxY2NkZmEtNWNiZS00YmU5LThhMzAtMjc5MWE0N2Q5YjgwIiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2NDQ0NDg1LCJjc3JmIjoiNDlhOTQ3Y2ItZjMxNi00ODNjLWE5NzYtMzY3Y2Q3YTUyMTRmIiwiZXhwIjoxNzY5MDM2NDg1fQ.GneoCovc67ucOY-TpTc6ITpAWoy5HS1xlZz4eAsZmOU', 2, 1, '2026-01-21 23:01:25', '2025-12-23 00:01:25'),
(47, '06558b01-a14c-4a74-95b8-97275e12724d', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjQ0NDU3MywianRpIjoiMDY1NThiMDEtYTE0Yy00YTc0LTk1YjgtOTcyNzVlMTI3MjRkIiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIxIiwibmJmIjoxNzY2NDQ0NTczLCJjc3JmIjoiMjIxZDZhNGUtMmQ3MC00MDEwLTkyN2YtNTYxMmViMzYxMzc3IiwiZXhwIjoxNzY5MDM2NTczfQ.enNS5x5HAAyWytoVhwZsM5uy9SA3aq3XA-Kd8ffwVxU', 1, 1, '2026-01-21 23:02:53', '2025-12-23 00:02:53'),
(48, '33026457-a25a-40f3-9c04-0bc5fe557c0d', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjQ0NTAzNSwianRpIjoiMzMwMjY0NTctYTI1YS00MGYzLTljMDQtMGJjNWZlNTU3YzBkIiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2NDQ1MDM1LCJjc3JmIjoiOTY5OTg2OTctZjEwNi00NmUwLWI4NmItNjczYmQ2YTY1MzUxIiwiZXhwIjoxNzY5MDM3MDM1fQ.mqw1U7hFQx4_nbc0Z8qKdYOFzjS_IiwQDWuQlgMGZ8A', 2, 1, '2026-01-21 23:10:35', '2025-12-23 00:10:35'),
(49, 'a03883e2-3ff9-4262-9bdf-fc8b83561d4a', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjQ0NTI2NiwianRpIjoiYTAzODgzZTItM2ZmOS00MjYyLTliZGYtZmM4YjgzNTYxZDRhIiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIxIiwibmJmIjoxNzY2NDQ1MjY2LCJjc3JmIjoiMGMyNjUzYWYtZmM5ZC00OGNjLWIzZDktNmUyY2U1NTY0Y2U1IiwiZXhwIjoxNzY5MDM3MjY2fQ.xuYmdrpnDWCbFjLpzbXkETvQ0tj9G1HCLmFPDOAxUns', 1, 0, '2026-01-21 23:14:26', '2025-12-23 00:14:26'),
(50, '25e3b883-91ec-4e73-92f7-c4798fa90bf0', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjQ4NTU1OSwianRpIjoiMjVlM2I4ODMtOTFlYy00ZTczLTkyZjctYzQ3OThmYTkwYmYwIiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2NDg1NTU5LCJjc3JmIjoiZDcyYmRkZGQtNTMwMy00MzQ5LThmMjAtYjhjYmVlNWRkNDQ3IiwiZXhwIjoxNzY5MDc3NTU5fQ.xrmbxfemSmFN13gWozqTeGg-FQtAU6SIvZLjzXIwaoY', 2, 0, '2026-01-22 10:25:59', '2025-12-23 11:25:59'),
(51, '40cdf7cf-9af9-42fd-88c1-c103ee14fe11', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjQ4NTcwNSwianRpIjoiNDBjZGY3Y2YtOWFmOS00MmZkLTg4YzEtYzEwM2VlMTRmZTExIiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2NDg1NzA1LCJjc3JmIjoiNDJlNzhmMjEtNTcxYy00ZGNiLWE2NWEtZmJlZjdhMjc4MzE1IiwiZXhwIjoxNzY5MDc3NzA1fQ.C49fHXy9HD7hshQsmbq51PC1t8uGOm9iOMAdR79qhnA', 2, 0, '2026-01-22 10:28:25', '2025-12-23 11:28:25'),
(52, '16cda4a8-4d03-446c-a471-c019fe8b3509', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjQ4NTk3NSwianRpIjoiMTZjZGE0YTgtNGQwMy00NDZjLWE0NzEtYzAxOWZlOGIzNTA5IiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2NDg1OTc1LCJjc3JmIjoiOWNkOWZiZDYtMDkzNC00MjQ3LTk1N2ItZjBkM2RkNjYwY2EwIiwiZXhwIjoxNzY5MDc3OTc1fQ.nfr0pyZ9IKD7_H4_taNAdpjCvtpOtS5o-wZk7YJsff0', 2, 0, '2026-01-22 10:32:55', '2025-12-23 11:32:55'),
(53, 'd47c9861-df64-485a-b51f-fa66acff6197', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjQ4NjI2NSwianRpIjoiZDQ3Yzk4NjEtZGY2NC00ODVhLWI1MWYtZmE2NmFjZmY2MTk3IiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2NDg2MjY1LCJjc3JmIjoiY2YzYjUzM2MtYzU5Ni00MjkyLWIyMDgtOWYyMDhiZjgwOTQ5IiwiZXhwIjoxNzY5MDc4MjY1fQ.XGifjdx3o5lnRi4LzELdxw3lBOSMRSYWYiu85jUVjP4', 2, 0, '2026-01-22 10:37:45', '2025-12-23 11:37:45'),
(54, '47adedf6-7111-4602-a319-1fd2d0d6f730', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjQ4NjYyOSwianRpIjoiNDdhZGVkZjYtNzExMS00NjAyLWEzMTktMWZkMmQwZDZmNzMwIiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIxIiwibmJmIjoxNzY2NDg2NjI5LCJjc3JmIjoiYjg1MTA3ZmYtNjlmZS00YzVjLTk1NjUtOTg4MGIxZmNmNThiIiwiZXhwIjoxNzY5MDc4NjI5fQ.nEutmk6Rv72453W6UiilVzioiutNbe3Y9MBSJovuQBE', 1, 0, '2026-01-22 10:43:49', '2025-12-23 11:43:49'),
(55, 'bfcc7f42-22bc-41e8-bbf8-542c5881c989', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjQ4NzYwNywianRpIjoiYmZjYzdmNDItMjJiYy00MWU4LWJiZjgtNTQyYzU4ODFjOTg5IiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2NDg3NjA3LCJjc3JmIjoiOWY0OGU1NWQtYjU3MS00YjYyLTk2ODAtZjJhODA1ZmFmZGY3IiwiZXhwIjoxNzY5MDc5NjA3fQ.FCSC6NSrQPPKSTfKyMNPIv_yM-gTy2_TXoLARrQa0uA', 2, 0, '2026-01-22 11:00:07', '2025-12-23 12:00:07'),
(56, '920e615e-f7fc-4ad2-8e44-b9df165a1a56', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjQ4Nzg2NCwianRpIjoiOTIwZTYxNWUtZjdmYy00YWQyLThlNDQtYjlkZjE2NWExYTU2IiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2NDg3ODY0LCJjc3JmIjoiOWU0ZjdjNDEtOTQ3OS00MmY5LTliNmQtMGNiNzNiMWQ3Y2I1IiwiZXhwIjoxNzY5MDc5ODY0fQ.ozsd_Ho2xMmRbMmP49rFa5KahlC2c2OG5QlbF299fgU', 2, 0, '2026-01-22 11:04:24', '2025-12-23 12:04:24'),
(57, '99ff847a-7166-4e35-8bf3-1d8e9f61ac3a', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjQ4ODEzMSwianRpIjoiOTlmZjg0N2EtNzE2Ni00ZTM1LThiZjMtMWQ4ZTlmNjFhYzNhIiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIxIiwibmJmIjoxNzY2NDg4MTMxLCJjc3JmIjoiNWY2MWJhNDUtYmVlMy00NThlLWE4MDItYjJlZDBhNjVlZWIwIiwiZXhwIjoxNzY5MDgwMTMxfQ.E9ryfGPwvx695fuwc5XcWVMJ96LWv-n81OhtZIVaQQw', 1, 0, '2026-01-22 11:08:51', '2025-12-23 12:08:51'),
(58, '05383724-ce40-4a73-99a0-a4882bd6d8fd', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjQ4ODg4NCwianRpIjoiMDUzODM3MjQtY2U0MC00YTczLTk5YTAtYTQ4ODJiZDZkOGZkIiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2NDg4ODg0LCJjc3JmIjoiZjA5NTdhOGMtZjI4Zi00YTc1LTllZTMtOTY0MjRlMzUyYjllIiwiZXhwIjoxNzY5MDgwODg0fQ.0hitL8JcJG-80EAgl3b0cCpyqYLMYJbpqof2P209Dxk', 2, 0, '2026-01-22 11:21:24', '2025-12-23 12:21:24'),
(59, 'c2ad55bb-030a-453f-892a-a58ac74fe35c', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjQ4OTAxNywianRpIjoiYzJhZDU1YmItMDMwYS00NTNmLTg5MmEtYTU4YWM3NGZlMzVjIiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2NDg5MDE3LCJjc3JmIjoiY2VlZTk2ZGUtMmI3ZS00ZWE5LTk4MDMtM2Q2MDYzY2Y1NzlhIiwiZXhwIjoxNzY5MDgxMDE3fQ.RNeoIHjw_gNf4_KjIhNY2A1J43Pe5W0Rt7ol_4lqJQ8', 2, 0, '2026-01-22 11:23:37', '2025-12-23 12:23:37'),
(60, 'd82503c5-5e56-420b-b866-9871f2e3c1fa', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjQ4OTA5MCwianRpIjoiZDgyNTAzYzUtNWU1Ni00MjBiLWI4NjYtOTg3MWYyZTNjMWZhIiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIxIiwibmJmIjoxNzY2NDg5MDkwLCJjc3JmIjoiM2RhZTJmYTAtMTZlYS00NTkxLWE5NTEtN2MxOTc3NTVkZWRiIiwiZXhwIjoxNzY5MDgxMDkwfQ.DHw9Zsdhr9Y4zyrUxKYdMXktXGpwnw7VfJ4gKXSBfzc', 1, 0, '2026-01-22 11:24:50', '2025-12-23 12:24:50'),
(61, '7a3d55ed-583e-4f55-b6f0-c7e1faf2a6d4', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjQ4OTM1NywianRpIjoiN2EzZDU1ZWQtNTgzZS00ZjU1LWI2ZjAtYzdlMWZhZjJhNmQ0IiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2NDg5MzU3LCJjc3JmIjoiYjg4MDg5ODgtNzRiMi00ZTU1LTlhZTUtNjdkMDRiMTg4OTM3IiwiZXhwIjoxNzY5MDgxMzU3fQ.Kze8ZXDchb2LKCqpaEvSY7X_btlwkg9WqDgkTvM2HkQ', 2, 0, '2026-01-22 11:29:17', '2025-12-23 12:29:17'),
(62, '1f06ea33-e2e4-4a53-9ff8-a8b26002fc8f', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjQ4OTc2MSwianRpIjoiMWYwNmVhMzMtZTJlNC00YTUzLTlmZjgtYThiMjYwMDJmYzhmIiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2NDg5NzYxLCJjc3JmIjoiZGUwYjBhOGUtMWQxZi00ZTEzLWJkZjItOThhOWY2NjNkYWVmIiwiZXhwIjoxNzY5MDgxNzYxfQ.GkN19DewOz9ynSeBw2o3X9ZRuRHxr-eRWMEXDTxvcuE', 2, 0, '2026-01-22 11:36:01', '2025-12-23 12:36:01'),
(63, '46642b84-47bf-4595-a10d-b5e4e73bccb3', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjQ4OTg2NCwianRpIjoiNDY2NDJiODQtNDdiZi00NTk1LWExMGQtYjVlNGU3M2JjY2IzIiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2NDg5ODY0LCJjc3JmIjoiNDk4MjQ4MTItMWRlYS00NTY5LTlhZTctZTE1MzgzMmIzNzQ1IiwiZXhwIjoxNzY5MDgxODY0fQ.2gEmUsXq8QMCU5ysmfKyRsnVx48X690foQnEZqHMyDQ', 2, 0, '2026-01-22 11:37:44', '2025-12-23 12:37:44'),
(64, 'cb710102-015d-4076-887b-b782b6d86315', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjQ5MDE2NiwianRpIjoiY2I3MTAxMDItMDE1ZC00MDc2LTg4N2ItYjc4MmI2ZDg2MzE1IiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2NDkwMTY2LCJjc3JmIjoiYTg0NDBhMzUtNjQ1Yi00ZGE5LWJkYTgtMDQwYTRiMTFjOWRkIiwiZXhwIjoxNzY5MDgyMTY2fQ.RBRKhRc-_LYiKZOzRmcsCOoy0j3qqRLru8MWpgrvDY4', 2, 0, '2026-01-22 11:42:46', '2025-12-23 12:42:46'),
(65, 'e2f149fc-2867-4e3c-8a4d-4f7adcc43ebe', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjQ5MTAwNSwianRpIjoiZTJmMTQ5ZmMtMjg2Ny00ZTNjLThhNGQtNGY3YWRjYzQzZWJlIiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2NDkxMDA1LCJjc3JmIjoiZTc4ZTBkYjctNzRkYi00YmM3LTgzNmQtNzFkZjczMzkzYzliIiwiZXhwIjoxNzY5MDgzMDA1fQ.sak8-cIT_TUEWa7LHE9BfqREMPOOkXzK7FdYAdnNS_s', 2, 0, '2026-01-22 11:56:45', '2025-12-23 12:56:45'),
(66, '5403f016-65f0-48b9-add2-78ce9edea2c1', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjQ5MTIyNCwianRpIjoiNTQwM2YwMTYtNjVmMC00OGI5LWFkZDItNzhjZTllZGVhMmMxIiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2NDkxMjI0LCJjc3JmIjoiOGFkY2U0MGQtYjJkNC00MDA4LTgwMzgtNzVmNTY1ZmQ2Yzg2IiwiZXhwIjoxNzY5MDgzMjI0fQ.5ZjRM3_AOVl2y4Cescq5o3I11by77Hlh_53UOnt2b0w', 2, 0, '2026-01-22 12:00:24', '2025-12-23 13:00:24'),
(67, 'de9425af-12ec-49af-abf3-4e23304aa726', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjQ5MTMxNywianRpIjoiZGU5NDI1YWYtMTJlYy00OWFmLWFiZjMtNGUyMzMwNGFhNzI2IiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2NDkxMzE3LCJjc3JmIjoiMzVhOTI1NjAtZTRkYS00M2NlLWI0MjctNTVmYjQ1NjBkMjcxIiwiZXhwIjoxNzY5MDgzMzE3fQ.tFAOnIf5_DceLW5EV1ocQ9Zy2rWJI-qivfLIuu03zgw', 2, 0, '2026-01-22 12:01:57', '2025-12-23 13:01:57'),
(68, '779a6e08-9177-422d-95b6-104cac0a8dd0', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjQ5MTY4NCwianRpIjoiNzc5YTZlMDgtOTE3Ny00MjJkLTk1YjYtMTA0Y2FjMGE4ZGQwIiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2NDkxNjg0LCJjc3JmIjoiNTY2ZThkZTktOGJlNC00OTQ5LWJlZDItNTJhNTRlNDg0Yjk4IiwiZXhwIjoxNzY5MDgzNjg0fQ.MHKnwzyRDDyqgTE9H50Pt5s9cQqBnA4M01GgEEMEFR8', 2, 0, '2026-01-22 12:08:04', '2025-12-23 13:08:04'),
(69, 'b24a9dd5-5a91-4019-bdf1-4977cc26f151', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjQ5NDQ2MSwianRpIjoiYjI0YTlkZDUtNWE5MS00MDE5LWJkZjEtNDk3N2NjMjZmMTUxIiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2NDk0NDYxLCJjc3JmIjoiNjhmZWYwM2EtNTk3Zi00ZWVhLWFiOTQtZGU1MWExMWE3NTlkIiwiZXhwIjoxNzY5MDg2NDYxfQ.XT0Sk108AF433pkTpKMaSZdhtCbgAqHCfR_y8MsTnbs', 2, 0, '2026-01-22 12:54:21', '2025-12-23 13:54:21'),
(70, 'a06b5bad-c40e-4252-8edb-8be90d4c7dc2', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjQ5NDUyMiwianRpIjoiYTA2YjViYWQtYzQwZS00MjUyLThlZGItOGJlOTBkNGM3ZGMyIiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2NDk0NTIyLCJjc3JmIjoiYTIyNDUxYTYtMzdjMC00ODAzLTk0OTYtM2E3ZGJlMzYzMjFmIiwiZXhwIjoxNzY5MDg2NTIyfQ.4CwfUTh91038cVoQmuL_7-AXpdqFHS5LXcoQa6EgGJc', 2, 0, '2026-01-22 12:55:22', '2025-12-23 13:55:22'),
(71, '00157e22-8ba1-4c69-94ae-f748aaafcf9e', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjQ5NDkwOSwianRpIjoiMDAxNTdlMjItOGJhMS00YzY5LTk0YWUtZjc0OGFhYWZjZjllIiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2NDk0OTA5LCJjc3JmIjoiODAzY2NmZDMtNGUzNC00ZWJmLTkyNTMtZjQzN2NhOWFjMTU2IiwiZXhwIjoxNzY5MDg2OTA5fQ.LexC54Z7osIkmK4Lp3AkO4aNo8nPAhoRCXfoTL8T8OI', 2, 0, '2026-01-22 13:01:49', '2025-12-23 14:01:49'),
(72, '81c4ca46-d583-438c-8a6e-51c5a2b9e3b7', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjQ5NDk2MCwianRpIjoiODFjNGNhNDYtZDU4My00MzhjLThhNmUtNTFjNWEyYjllM2I3IiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2NDk0OTYwLCJjc3JmIjoiMGYwYzgyYzYtZjU2Ny00NGU0LWFhOTUtOTc3NTA2NzQwYmQ0IiwiZXhwIjoxNzY5MDg2OTYwfQ.YNzsLrPDqC4a7Fq2qmqfEycXF-a8pToytkg8neeU3NI', 2, 0, '2026-01-22 13:02:41', '2025-12-23 14:02:41'),
(73, '91843266-0d08-4c63-ba59-11437651d135', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjUwMTY5NiwianRpIjoiOTE4NDMyNjYtMGQwOC00YzYzLWJhNTktMTE0Mzc2NTFkMTM1IiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2NTAxNjk2LCJjc3JmIjoiYWNmOGU3NGMtMmIyNy00MTEyLTgzYmYtZDc2ZjEwY2IzN2U5IiwiZXhwIjoxNzY5MDkzNjk2fQ.0UyN9HdEUyAeHMr0BlmtS1zW7zT7t8iUDZ0GPIBz6Q0', 2, 0, '2026-01-22 14:54:56', '2025-12-23 15:54:56'),
(74, '4fde1317-3617-463b-82e7-b923cde88500', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjUwMzE0NiwianRpIjoiNGZkZTEzMTctMzYxNy00NjNiLTgyZTctYjkyM2NkZTg4NTAwIiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2NTAzMTQ2LCJjc3JmIjoiNWExOWRmZDItNDcxNS00ZWRiLTk1NGQtZjUwMmRkMGMzNjIwIiwiZXhwIjoxNzY5MDk1MTQ2fQ.nzFX_2sGThV0J6QQvtypNWI7USXWLtqrbiQOquFmfO4', 2, 0, '2026-01-22 15:19:06', '2025-12-23 16:19:06'),
(75, '35297e61-9038-4f1a-b16c-464d118e29a5', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjUwMzMwNiwianRpIjoiMzUyOTdlNjEtOTAzOC00ZjFhLWIxNmMtNDY0ZDExOGUyOWE1IiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2NTAzMzA2LCJjc3JmIjoiMmI2OWU3ZDItZmZlMy00YmMwLWJjYjMtNWMxNmQxYWMyN2Y4IiwiZXhwIjoxNzY5MDk1MzA2fQ.FbqWkk7ii6LNFkkDTlVCg1rdsQpNCH522ArUQ5Mh39U', 2, 0, '2026-01-22 15:21:46', '2025-12-23 16:21:46'),
(76, '718f0c74-07b0-4be9-9b03-3e0bc5f76ea1', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjUwMzM4MCwianRpIjoiNzE4ZjBjNzQtMDdiMC00YmU5LTliMDMtM2UwYmM1Zjc2ZWExIiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2NTAzMzgwLCJjc3JmIjoiNDJiZThlNjQtMDk4MS00ZjcwLThkNTEtYjg0YWM5MjBjNGFmIiwiZXhwIjoxNzY5MDk1MzgwfQ.pQ7749DYi2RRI_AwPFsJJW-yfR7YiGXOR-yFUIpkP5Y', 2, 0, '2026-01-22 15:23:00', '2025-12-23 16:23:00'),
(77, '364283f4-f532-4bed-8820-74ecd47909a9', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjUwMzQ2NywianRpIjoiMzY0MjgzZjQtZjUzMi00YmVkLTg4MjAtNzRlY2Q0NzkwOWE5IiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIxIiwibmJmIjoxNzY2NTAzNDY3LCJjc3JmIjoiYWQ1OTIyY2UtOWNjNC00ZDlkLTgxNDMtZGZlNjUzMzhmMTczIiwiZXhwIjoxNzY5MDk1NDY3fQ.AjSk5UoqHkVCBSFke0aUcaEepCASJBLsnccsx9jSBGo', 1, 1, '2026-01-22 15:24:27', '2025-12-23 16:24:27'),
(78, '2cd990d4-9d65-47af-acdb-2648061d9146', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjUwMzc0NiwianRpIjoiMmNkOTkwZDQtOWQ2NS00N2FmLWFjZGItMjY0ODA2MWQ5MTQ2IiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIxIiwibmJmIjoxNzY2NTAzNzQ2LCJjc3JmIjoiNDE0NDkxNTUtZDcxNy00MGY4LThjZTEtYWY4MDdkNTE0NmU2IiwiZXhwIjoxNzY5MDk1NzQ2fQ.9bamPnHpf9CKBybz_264Bu57Jl3PHyGhSWJjLAvXmJo', 1, 0, '2026-01-22 15:29:06', '2025-12-23 16:29:06'),
(79, 'b0b77261-463a-4f23-ad88-5d8091ff9f8a', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjU2NDY2OCwianRpIjoiYjBiNzcyNjEtNDYzYS00ZjIzLWFkODgtNWQ4MDkxZmY5ZjhhIiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2NTY0NjY4LCJjc3JmIjoiYzFmMDc0NzEtMzMxNC00ZjllLWE0ODEtZWJmMjc0MDc3ZjQwIiwiZXhwIjoxNzY5MTU2NjY4fQ.o_b4Q_KWVmb-ZxiBluhXEaqS6Dl_QqG3BVXBeIVH0HI', 2, 0, '2026-01-23 08:24:28', '2025-12-24 09:24:28'),
(80, 'aa870dd6-b0a9-4892-9921-2121008256a7', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjU2NDczNiwianRpIjoiYWE4NzBkZDYtYjBhOS00ODkyLTk5MjEtMjEyMTAwODI1NmE3IiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2NTY0NzM2LCJjc3JmIjoiZGZhMDRkZWQtYTk4MS00OThhLTkzZTYtMDBlNzhjMDA5ZmVkIiwiZXhwIjoxNzY5MTU2NzM2fQ.ZMJ3ZkW9JBt87mvCneGHTB6ELKN-J0BSn3h1w1iwhug', 2, 0, '2026-01-23 08:25:36', '2025-12-24 09:25:36'),
(81, '35f77ee5-3b6d-4e3f-9647-56fa079e7722', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjU2NDc4MCwianRpIjoiMzVmNzdlZTUtM2I2ZC00ZTNmLTk2NDctNTZmYTA3OWU3NzIyIiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2NTY0NzgwLCJjc3JmIjoiOTJiODdiYzctMTBlNS00OWNiLWE3MTQtNDhjODdhMDAwNzI2IiwiZXhwIjoxNzY5MTU2NzgwfQ.muBbor068gFMWLSR4dsoXYdxeP20K7xGpGfPuGuudA4', 2, 0, '2026-01-23 08:26:20', '2025-12-24 09:26:20'),
(82, 'e6b50f9a-54c3-4224-8458-c2dd2a0040eb', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjU2NzkzNCwianRpIjoiZTZiNTBmOWEtNTRjMy00MjI0LTg0NTgtYzJkZDJhMDA0MGViIiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2NTY3OTM0LCJjc3JmIjoiOGVhMDBlNzgtYmYyOC00ODA1LTg5YmUtN2M1ZWQ4NWU4NjUyIiwiZXhwIjoxNzY5MTU5OTM0fQ.4UWHntsn31sAMvm7kJ7War9JqRFjMZ9GiDAW7ODuMJo', 2, 0, '2026-01-23 09:18:55', '2025-12-24 10:18:55'),
(83, 'dc91aade-0c6a-41c8-9a63-0622b29d4a86', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjU2ODQwNywianRpIjoiZGM5MWFhZGUtMGM2YS00MWM4LTlhNjMtMDYyMmIyOWQ0YTg2IiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2NTY4NDA3LCJjc3JmIjoiZDI3NGM2MGEtMWM0ZS00NThhLWEzMTUtMDVlNTY1MWE4ZDVmIiwiZXhwIjoxNzY5MTYwNDA3fQ.9RJadOKWZQD_KOZdKG8_Pxx5AbtkrpTzsn_8ZR0HwyU', 2, 0, '2026-01-23 09:26:47', '2025-12-24 10:26:47'),
(84, 'd45b9536-e9d7-4a1f-bab4-11211ea269ea', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjU2OTE4OCwianRpIjoiZDQ1Yjk1MzYtZTlkNy00YTFmLWJhYjQtMTEyMTFlYTI2OWVhIiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2NTY5MTg4LCJjc3JmIjoiNTYwNzU5MTItZjllNS00Yzc0LWI4ZDAtYjI0NzdhOTlkNDcxIiwiZXhwIjoxNzY5MTYxMTg4fQ.Llb1mBIyic775-ohWgw2Z9N8RoTq_dgi1zz18WyAA1A', 2, 0, '2026-01-23 09:39:48', '2025-12-24 10:39:48'),
(85, 'ccf190bf-c723-455b-9e8e-fcf889ed96b4', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjU2OTQxOCwianRpIjoiY2NmMTkwYmYtYzcyMy00NTViLTllOGUtZmNmODg5ZWQ5NmI0IiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2NTY5NDE4LCJjc3JmIjoiNTdiN2FiOGItMGVlMy00ZTFhLTg0MjMtMDFkNzhjMGE2OWM0IiwiZXhwIjoxNzY5MTYxNDE4fQ.gNQwerSN1M7R3p6XDBZ-GHlzKSDiol2-0I0cd0-Evak', 2, 0, '2026-01-23 09:43:38', '2025-12-24 10:43:38'),
(86, '01206a02-8322-42d3-9595-c3bf0a3dedd5', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjU3MDE1NiwianRpIjoiMDEyMDZhMDItODMyMi00MmQzLTk1OTUtYzNiZjBhM2RlZGQ1IiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIxIiwibmJmIjoxNzY2NTcwMTU2LCJjc3JmIjoiNmU5MTI1MWYtNjM4Mi00NzU0LWI2YTEtNDc2ODhmMmMwZTJlIiwiZXhwIjoxNzY5MTYyMTU2fQ.U550KetZ8iDRleXqgy9TxuadIpMRBPwXhMs2jnmHktw', 1, 1, '2026-01-23 09:55:56', '2025-12-24 10:55:56'),
(87, '79bc66f7-8641-4530-aa73-7ed8ee210494', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjU3MDUxNSwianRpIjoiNzliYzY2ZjctODY0MS00NTMwLWFhNzMtN2VkOGVlMjEwNDk0IiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIzIiwibmJmIjoxNzY2NTcwNTE1LCJjc3JmIjoiYmNkYTk5ZmMtYzliZC00M2JlLTk4YmMtMzM1MGI5M2M4MWM3IiwiZXhwIjoxNzY5MTYyNTE1fQ.6CQpSS-TShabj5Q9Kp56vJ25J9HkjxL9I8nOlO6TLrM', 3, 1, '2026-01-23 10:01:55', '2025-12-24 11:01:55'),
(88, 'd9c986ca-aafd-4c26-87a5-4d1c1ca84661', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjU3MDc4NiwianRpIjoiZDljOTg2Y2EtYWFmZC00YzI2LTg3YTUtNGQxYzFjYTg0NjYxIiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2NTcwNzg2LCJjc3JmIjoiNmU2MmFjZDItYzY1My00NDU4LTkwMTgtMzBkZDgzN2NhYTFkIiwiZXhwIjoxNzY5MTYyNzg2fQ.vccVSGyiObTnulVU_iOf15Ql7Sfa7YUumhZSapZbT7A', 2, 0, '2026-01-23 10:06:26', '2025-12-24 11:06:26'),
(89, '5f3fc278-0f82-471d-aa4e-1fe338140327', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjU3MTA2NywianRpIjoiNWYzZmMyNzgtMGY4Mi00NzFkLWFhNGUtMWZlMzM4MTQwMzI3IiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2NTcxMDY3LCJjc3JmIjoiNDU3NWIwNWUtZTc0MS00OTNhLTg1N2MtMzU3YzdiYmIwM2Y1IiwiZXhwIjoxNzY5MTYzMDY3fQ.sa_lOEAAKmq6_F0KgU_AfKvBRuq-exA4G9h6xRjQVU8', 2, 0, '2026-01-23 10:11:07', '2025-12-24 11:11:07'),
(90, '927ee564-8d37-4c70-9ffe-dcc52480a6e1', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjU3MTU0NCwianRpIjoiOTI3ZWU1NjQtOGQzNy00YzcwLTlmZmUtZGNjNTI0ODBhNmUxIiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIxIiwibmJmIjoxNzY2NTcxNTQ0LCJjc3JmIjoiNDVkYTZlNmUtNWZmMC00NjI4LTg1OTEtNWRlNjI0ODU4MDYyIiwiZXhwIjoxNzY5MTYzNTQ0fQ.nVM4hGmByUhmB-w2GoFjjYxzc76lpDA33msibshID9A', 1, 1, '2026-01-23 10:19:04', '2025-12-24 11:19:04'),
(91, '5623738a-4e14-4c94-8b05-e1b76f1ace4d', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjU3MjU1NCwianRpIjoiNTYyMzczOGEtNGUxNC00Yzk0LThiMDUtZTFiNzZmMWFjZTRkIiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2NTcyNTU0LCJjc3JmIjoiNTQyNWExOTMtYmUyMC00NmNhLTk0ZTYtN2M3YjFjMGVlYjlhIiwiZXhwIjoxNzY5MTY0NTU0fQ.N9FaMB7KDSCfj35IdZMXmTc46zzJemJO3NJtOVUvWDw', 2, 0, '2026-01-23 10:35:54', '2025-12-24 11:35:54'),
(92, 'a793c044-f34e-4771-8548-3ea6524c9866', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjU3MzI0MiwianRpIjoiYTc5M2MwNDQtZjM0ZS00NzcxLTg1NDgtM2VhNjUyNGM5ODY2IiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2NTczMjQyLCJjc3JmIjoiZTcxMjk5ZTAtNjlkOC00NGIzLThlYWUtOWYwNWQzYTdkY2EzIiwiZXhwIjoxNzY5MTY1MjQyfQ.xSE5lGcu0_O3iXTUouFZfHVT0E7_-kBiL2AJcSps6go', 2, 0, '2026-01-23 10:47:22', '2025-12-24 11:47:22'),
(93, '75e8dfbc-2d67-4d47-b638-e451f2052191', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjU3MzM5NywianRpIjoiNzVlOGRmYmMtMmQ2Ny00ZDQ3LWI2MzgtZTQ1MWYyMDUyMTkxIiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2NTczMzk3LCJjc3JmIjoiMDZlN2M5NmQtZTYxNy00NTJlLTkwZGUtZTliNmQ5ZGEwZjAyIiwiZXhwIjoxNzY5MTY1Mzk3fQ.uQkcnWEccKAfcpCpHQGmuHIebvKkv1KyOhKlkvT6lS8', 2, 0, '2026-01-23 10:49:57', '2025-12-24 11:49:57'),
(94, '57f154f5-27d0-4042-8ef0-53f5ecdd1ad4', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjU3MzQwNSwianRpIjoiNTdmMTU0ZjUtMjdkMC00MDQyLThlZjAtNTNmNWVjZGQxYWQ0IiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2NTczNDA1LCJjc3JmIjoiYjA0MTBhMWItMWM4YS00MTA4LWFmYzktMTJkMzM2MzUxZGM3IiwiZXhwIjoxNzY5MTY1NDA1fQ.I_D-r_CMEKHkFHgtWiiLJviCkTVyKcDCyL9WaZnX46E', 2, 0, '2026-01-23 10:50:05', '2025-12-24 11:50:05'),
(95, 'c8bb90ca-5d19-4dc4-bd7f-5d6ab891bb9c', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjU3Mzk2NiwianRpIjoiYzhiYjkwY2EtNWQxOS00ZGM0LWJkN2YtNWQ2YWI4OTFiYjljIiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2NTczOTY2LCJjc3JmIjoiOGU2ODZhMTYtY2YxMS00ZGQ4LTgxNjYtM2M3ZTllYmFiMzI0IiwiZXhwIjoxNzY5MTY1OTY2fQ._pfU2Hoy3ohMV67jRCPAcYWjfNnUp_jna7BtMOOqqPw', 2, 0, '2026-01-23 10:59:26', '2025-12-24 11:59:26'),
(96, '6105952f-404d-4e08-a568-149ef3a4924a', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjU3NDMwMiwianRpIjoiNjEwNTk1MmYtNDA0ZC00ZTA4LWE1NjgtMTQ5ZWYzYTQ5MjRhIiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2NTc0MzAyLCJjc3JmIjoiZDBkNzkxMDctNmUxMC00NmVmLTg4ZTItMzQ4YTNiYTRkNDM5IiwiZXhwIjoxNzY5MTY2MzAyfQ.srPKBewVfJy_MPwIonf7XwNPAutCrsPvJlEJBzhYuW4', 2, 0, '2026-01-23 11:05:02', '2025-12-24 12:05:02'),
(97, '99819705-05c7-466f-a5b4-6c436b116998', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjU3NTI2NCwianRpIjoiOTk4MTk3MDUtMDVjNy00NjZmLWE1YjQtNmM0MzZiMTE2OTk4IiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIzIiwibmJmIjoxNzY2NTc1MjY0LCJjc3JmIjoiMzQ0Y2ExOTMtMWFmMy00M2IxLTg1MTQtODljMTQ5N2Y5NjYwIiwiZXhwIjoxNzY5MTY3MjY0fQ.tve2LwgvdQ593hFS1yrdvVS62Rg2B8hsLrxmEl42lLE', 3, 0, '2026-01-23 11:21:04', '2025-12-24 12:21:04'),
(98, 'f574d726-5b8d-426f-a27d-11d712427bdb', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjU3NTU4MCwianRpIjoiZjU3NGQ3MjYtNWI4ZC00MjZmLWEyN2QtMTFkNzEyNDI3YmRiIiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2NTc1NTgwLCJjc3JmIjoiZjNhZGVmYjItZDE2MS00ODJlLTlhYmItYTk0MzQ2OWNkN2VkIiwiZXhwIjoxNzY5MTY3NTgwfQ.9y3OjWOuQJM8Dkf2dQ6Uq_15gFFw6_r0xlAsVsPv-68', 2, 1, '2026-01-23 11:26:20', '2025-12-24 12:26:20'),
(99, 'b7c65c6c-c0ce-4c49-ad35-c02de43c31e3', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjU3NjE0OSwianRpIjoiYjdjNjVjNmMtYzBjZS00YzQ5LWFkMzUtYzAyZGU0M2MzMWUzIiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIxIiwibmJmIjoxNzY2NTc2MTQ5LCJjc3JmIjoiOTI4YTViN2EtNzI0Yi00Y2I0LTkyODAtZTg0OTIzMWJkZGMzIiwiZXhwIjoxNzY5MTY4MTQ5fQ.Z0vsw2fa0Vb9761-bOi-7_0XBPWFqKTqJAbqKw5TejI', 1, 0, '2026-01-23 11:35:49', '2025-12-24 12:35:49'),
(100, '70b33a34-cde6-4f8b-9d0a-008b97446dc6', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjU4NjQwNywianRpIjoiNzBiMzNhMzQtY2RlNi00ZjhiLTlkMGEtMDA4Yjk3NDQ2ZGM2IiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2NTg2NDA3LCJjc3JmIjoiZDAwNmU1ZTYtNTMxMC00OTJlLWE4ZGMtNTliYWRiODNhNzU1IiwiZXhwIjoxNzY5MTc4NDA3fQ.PGSfTcY8qJymG9o5-x3Ykf5ZkhP8HMem5c5ZgCw81xg', 2, 0, '2026-01-23 14:26:49', '2025-12-24 15:26:49'),
(101, '7d7dfdcf-0bc9-4023-9371-c67da89573b7', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjU5MTA3MCwianRpIjoiN2Q3ZGZkY2YtMGJjOS00MDIzLTkzNzEtYzY3ZGE4OTU3M2I3IiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2NTkxMDcwLCJjc3JmIjoiNTdjZTA1NDktYjZiMi00YTZhLTkxNTEtODMxYTFhMWZkYWI2IiwiZXhwIjoxNzY5MTgzMDcwfQ.4-Cdl-RYkmTguUyW40mAWNN5Rp3_uF4YabBYquWU6l4', 2, 0, '2026-01-23 15:44:30', '2025-12-24 16:44:30'),
(102, 'c5de691d-ec5f-478a-9a0b-9727e39132b6', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjU5MjI1NywianRpIjoiYzVkZTY5MWQtZWM1Zi00NzhhLTlhMGItOTcyN2UzOTEzMmI2IiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2NTkyMjU3LCJjc3JmIjoiNzY0ZWIwYzEtN2ExMy00ZjM1LTk0YjctYmViZTRhMzFlZGJjIiwiZXhwIjoxNzY5MTg0MjU3fQ.0PXfFiA-xzJL9eOLlkZ1hrSrbCPogj4GX_3SzZE6fSo', 2, 0, '2026-01-23 16:04:17', '2025-12-24 17:04:17'),
(103, 'b131225f-a0ae-4b50-b04b-8a1df69daa6b', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjU5MjUzOSwianRpIjoiYjEzMTIyNWYtYTBhZS00YjUwLWIwNGItOGExZGY2OWRhYTZiIiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2NTkyNTM5LCJjc3JmIjoiNjBhZGQyNmUtMDgxMi00ZjNlLWE0OGMtMmYwZGRmYzRlNmYzIiwiZXhwIjoxNzY5MTg0NTM5fQ.czGIuo1_fFQSKmicu_-YgNUTfV4w7e72SM1JCUV6WjU', 2, 0, '2026-01-23 16:08:59', '2025-12-24 17:08:59'),
(104, 'f1aeaf44-3395-4d40-8496-be2b062258f8', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjU5MzM2MywianRpIjoiZjFhZWFmNDQtMzM5NS00ZDQwLTg0OTYtYmUyYjA2MjI1OGY4IiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2NTkzMzYzLCJjc3JmIjoiNmMyMjAyYjMtYzM0Mi00YmM4LThhMDctYTY1MjQ0NjQ5ZDU4IiwiZXhwIjoxNzY5MTg1MzYzfQ.ZnNZ9ZF3dhNKklWRzPduArA6mMsaLuN6GfMMY70sfnU', 2, 0, '2026-01-23 16:22:43', '2025-12-24 17:22:43'),
(105, 'a155ef62-fbbe-4b77-9b78-5d37b3c38ed2', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjU5MzQyMCwianRpIjoiYTE1NWVmNjItZmJiZS00Yjc3LTliNzgtNWQzN2IzYzM4ZWQyIiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2NTkzNDIwLCJjc3JmIjoiNjU5M2M3MTUtZGIzZS00MmI4LWEwYzItOGUyNTFiMDBhYWE0IiwiZXhwIjoxNzY5MTg1NDIwfQ.QqT-xszYTePwzdEn6RWWFCNNiZCZc6p8rnK4Eyt5jrQ', 2, 0, '2026-01-23 16:23:40', '2025-12-24 17:23:40'),
(106, 'f2169492-9429-4b29-983b-365a0ab00bf1', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjU5Mzk2NiwianRpIjoiZjIxNjk0OTItOTQyOS00YjI5LTk4M2ItMzY1YTBhYjAwYmYxIiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2NTkzOTY2LCJjc3JmIjoiZGUyMTRjNzMtMDQ5Ny00YTFjLTg5ZjAtZmIyM2E1NTk5NzM0IiwiZXhwIjoxNzY5MTg1OTY2fQ.4QxBBTnJk7GPL7Yx_5j3zOeNshwIVmbRmLd6ys9UyqQ', 2, 0, '2026-01-23 16:32:46', '2025-12-24 17:32:46'),
(107, 'f1bf1139-2c26-4404-ac58-3aec0cd59ce0', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjU5NTIxNSwianRpIjoiZjFiZjExMzktMmMyNi00NDA0LWFjNTgtM2FlYzBjZDU5Y2UwIiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2NTk1MjE1LCJjc3JmIjoiMGNkY2ZhNTgtOGJiMS00NTViLTg2NDEtOTJkZjdkM2RhZDhhIiwiZXhwIjoxNzY5MTg3MjE1fQ.ObjQyPbKZ0q75jMmtTrvvePQ_knkgSprD7Qkf1Ep4Z8', 2, 0, '2026-01-23 16:53:35', '2025-12-24 17:53:35'),
(108, 'be928205-2926-48a8-8258-f348a0c98d39', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjU5NTM2NiwianRpIjoiYmU5MjgyMDUtMjkyNi00OGE4LTgyNTgtZjM0OGEwYzk4ZDM5IiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2NTk1MzY2LCJjc3JmIjoiNjI0MDllZmUtMDcwNi00ZjZhLWJmY2EtZDdiNWZiNWNkZDUxIiwiZXhwIjoxNzY5MTg3MzY2fQ.oWhy-UDIuQEC-CMtxjhmRHfMZ1DSM9K5FoZJ9v7QtTA', 2, 1, '2026-01-23 16:56:06', '2025-12-24 17:56:06'),
(109, 'ab088f17-dc53-4e77-a5e5-df33d4ccecdb', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjYxNDQwNSwianRpIjoiYWIwODhmMTctZGM1My00ZTc3LWE1ZTUtZGYzM2Q0Y2NlY2RiIiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2NjE0NDA1LCJjc3JmIjoiZGFhNjY3NjQtY2ZkNS00NGQwLWFmMWUtNzFkN2I5OWE2NjhlIiwiZXhwIjoxNzY5MjA2NDA1fQ.V5NSwbh66V1-aB_yerZeqYgMsAuKD2adgX_Pf_mvdvA', 2, 0, '2026-01-23 22:13:25', '2025-12-24 23:13:25'),
(110, 'a3deb550-db3a-458c-9c3b-587ad639f802', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjYxNjQyMywianRpIjoiYTNkZWI1NTAtZGIzYS00NThjLTljM2ItNTg3YWQ2MzlmODAyIiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2NjE2NDIzLCJjc3JmIjoiNTJlZWQ3NjUtYWFiYi00YjExLWI4MzgtM2Y4MTUwNDZhOWQ3IiwiZXhwIjoxNzY5MjA4NDIzfQ.2r2oQwUpXPYscGhfT0dhRErdxbH5isrYCnL8sGXI6iw', 2, 0, '2026-01-23 22:47:03', '2025-12-24 23:47:03'),
(111, '22df5e74-c7b4-4db8-ba05-69b9595f7311', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjYxNjgzMiwianRpIjoiMjJkZjVlNzQtYzdiNC00ZGI4LWJhMDUtNjliOTU5NWY3MzExIiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2NjE2ODMyLCJjc3JmIjoiMzI0MzA3Y2YtNTM0ZS00OTU1LWJmOTctZDUxOTc0YjZiYmY5IiwiZXhwIjoxNzY5MjA4ODMyfQ.UmAoBxsn1HnEjO0LjKx0Gr6EBGsIvjr6dpUIsxUt7L0', 2, 0, '2026-01-23 22:53:52', '2025-12-24 23:53:52'),
(112, 'b37d90b2-a5f4-467a-8817-071c8df218a8', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjYxNzYzNCwianRpIjoiYjM3ZDkwYjItYTVmNC00NjdhLTg4MTctMDcxYzhkZjIxOGE4IiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2NjE3NjM0LCJjc3JmIjoiYjE5OTg1OGQtMDIzNi00YWUwLWFhMjUtYzdmODE0NjRhMWU0IiwiZXhwIjoxNzY5MjA5NjM0fQ.ZN6RJLJZ7t32h3mr_1HHP443OPjKrbm7uOgmTg0ve90', 2, 0, '2026-01-23 23:07:14', '2025-12-25 00:07:14'),
(113, '320b97f2-8781-4c67-a9d1-f67f4db3558e', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjYyMDM2NywianRpIjoiMzIwYjk3ZjItODc4MS00YzY3LWE5ZDEtZjY3ZjRkYjM1NThlIiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2NjIwMzY3LCJjc3JmIjoiZTg0MmQyNTUtNDNmZS00M2UxLTljODEtMjk2YThkYzEzZjQ2IiwiZXhwIjoxNzY5MjEyMzY3fQ.3mqXnX2Fly-qAf0bHIKOR7zNfwt_cwYoNPYVwWs1SPI', 2, 0, '2026-01-23 23:52:47', '2025-12-25 00:52:47'),
(114, '3613d31b-ed5f-4bc4-a127-f7d3f41c335d', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjYyMjcwOSwianRpIjoiMzYxM2QzMWItZWQ1Zi00YmM0LWExMjctZjdkM2Y0MWMzMzVkIiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2NjIyNzA5LCJjc3JmIjoiY2Q5MmMyMTQtMWQ1Yy00YmI1LTkyM2YtM2Q0ZTdkM2RkYmE5IiwiZXhwIjoxNzY5MjE0NzA5fQ.qB59LtuRVElRtafs5BGgYbgpi06UJTxww2TySp8os18', 2, 0, '2026-01-24 00:31:49', '2025-12-25 01:31:49'),
(115, '9aec26ff-7458-45d5-a221-a20bc65092b3', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjY1ODc5NCwianRpIjoiOWFlYzI2ZmYtNzQ1OC00NWQ1LWEyMjEtYTIwYmM2NTA5MmIzIiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2NjU4Nzk0LCJjc3JmIjoiMTk0ZjMwMGEtNzRhNi00ZjgwLWFmMTQtZWM4YWU0MjExNGU5IiwiZXhwIjoxNzY5MjUwNzk0fQ.zhO29TMZJO0c96xPVKjntiN-hNjmKZi56HmyuTRGXFk', 2, 0, '2026-01-24 10:33:14', '2025-12-25 11:33:14'),
(116, 'e4d46070-7f57-4436-b72d-8bb6f0cfe54f', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjY2NDk0MiwianRpIjoiZTRkNDYwNzAtN2Y1Ny00NDM2LWI3MmQtOGJiNmYwY2ZlNTRmIiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2NjY0OTQyLCJjc3JmIjoiODc1NmMwOGEtOGExNS00MzNmLWE0NGMtYjYyNzJhNmRiMWNiIiwiZXhwIjoxNzY5MjU2OTQyfQ.TMT7uTwzHDdqD0t7-ikWoeB4-HgyjMaAq_bwQUsv7UE', 2, 1, '2026-01-24 12:15:42', '2025-12-25 13:15:42');
INSERT INTO `refresh_tokens` (`id`, `jti`, `token`, `user_id`, `revoked`, `expires_at`, `created_at`) VALUES
(117, '6edde99a-8dab-4493-9132-2aa0161488f5', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjY2NTA4NCwianRpIjoiNmVkZGU5OWEtOGRhYi00NDkzLTkxMzItMmFhMDE2MTQ4OGY1IiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2NjY1MDg0LCJjc3JmIjoiYmIxNDUxYzQtNDY1MS00M2UxLTkzNGMtZTNiOGY2OTBhYWEyIiwiZXhwIjoxNzY5MjU3MDg0fQ.eEKsjzFunAgDerFVAwD9JbJXncbAB9g5P2hQde_Rxts', 2, 1, '2026-01-24 12:18:04', '2025-12-25 13:18:04'),
(118, 'fd299d08-3e96-48e1-97c2-43e5efec3f9e', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjY2NTUxNywianRpIjoiZmQyOTlkMDgtM2U5Ni00OGUxLTk3YzItNDNlNWVmZWMzZjllIiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2NjY1NTE3LCJjc3JmIjoiN2M2Y2RlYmEtMDMyYS00ZGM4LWFlOTItYWM0ZGMwZTUwYTliIiwiZXhwIjoxNzY5MjU3NTE3fQ.rbT0pfCAPYhb83wSex7PBXbX1HUgdkqjMR_Pgvq9ru0', 2, 1, '2026-01-24 12:25:17', '2025-12-25 13:25:17'),
(119, '1e8e988b-aefc-4f70-9db2-27dc8c54951f', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjY2NzEzOSwianRpIjoiMWU4ZTk4OGItYWVmYy00ZjcwLTlkYjItMjdkYzhjNTQ5NTFmIiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2NjY3MTM5LCJjc3JmIjoiMWQxNjVkYmEtYTcyNS00ZjQ2LThkZmItMmQ5ZmJjMzY4NmM4IiwiZXhwIjoxNzY5MjU5MTM5fQ.5XyKwA9RMD8CnWolWewkeKnGdXX9LRikdGsg-dUp0yI', 2, 0, '2026-01-24 12:52:19', '2025-12-25 13:52:19'),
(120, 'facac961-e29f-4984-bd36-4bcfd68f443c', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjY3MDU4NCwianRpIjoiZmFjYWM5NjEtZTI5Zi00OTg0LWJkMzYtNGJjZmQ2OGY0NDNjIiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2NjcwNTg0LCJjc3JmIjoiNDhlNTlmOGUtNWFkYi00YTc5LTg3MjctZDYxNjBiMTJkNTVjIiwiZXhwIjoxNzY5MjYyNTg0fQ.Zgs2dCl5Fs7Y3TV6SK2VjAxeWHkJb_Kg0SHHHkk75qU', 2, 0, '2026-01-24 13:49:44', '2025-12-25 14:49:44'),
(121, 'c51bade4-5fa9-4375-a4b8-b84371343007', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjY3MDY4MSwianRpIjoiYzUxYmFkZTQtNWZhOS00Mzc1LWE0YjgtYjg0MzcxMzQzMDA3IiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2NjcwNjgxLCJjc3JmIjoiODMzNmVjYTgtOGMwNy00M2FkLWJmZDgtNzcxMjY3OWE1ZDJkIiwiZXhwIjoxNzY5MjYyNjgxfQ.TPQ54kzGLDtO4bvnOw287hwH_f9aypzKU2JDCrW7khU', 2, 1, '2026-01-24 13:51:21', '2025-12-25 14:51:21'),
(122, 'eea250a5-ba13-4d73-b80a-de5e71b98807', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjY3MDc2MiwianRpIjoiZWVhMjUwYTUtYmExMy00ZDczLWI4MGEtZGU1ZTcxYjk4ODA3IiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2NjcwNzYyLCJjc3JmIjoiYmFmMTg0OGYtZDM0OC00NmNkLWE5ODItNjE2N2E5YmFjZDExIiwiZXhwIjoxNzY5MjYyNzYyfQ.SepgJEtkOYq-S6by7DCxbVuCMebbIOnz0y-s6FpjLVU', 2, 1, '2026-01-24 13:52:42', '2025-12-25 14:52:42'),
(123, '88b63e86-5f9a-440c-8e79-b1144045906e', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjY3MDgyNSwianRpIjoiODhiNjNlODYtNWY5YS00NDBjLThlNzktYjExNDQwNDU5MDZlIiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2NjcwODI1LCJjc3JmIjoiMTY3Yjc5N2ItMDAyOC00NWQxLWE4ZmItZGY3ZjY4NWFiYTg3IiwiZXhwIjoxNzY5MjYyODI1fQ.3j4coDLpG3wKL078jwXSaVGIJVuhFVXyBTl0o1tmZ90', 2, 0, '2026-01-24 13:53:45', '2025-12-25 14:53:45'),
(124, 'b44edd3b-1e33-4bd0-b58c-bb37aa331c6a', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjY3MTIwOSwianRpIjoiYjQ0ZWRkM2ItMWUzMy00YmQwLWI1OGMtYmIzN2FhMzMxYzZhIiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2NjcxMjA5LCJjc3JmIjoiNTk3YzUxYzQtMTZmOC00NTBjLTg3ODYtOWQ2ZmUyNTNhMGRiIiwiZXhwIjoxNzY5MjYzMjA5fQ._tH8emW_Uq8cLZUzvZ3S7qM8XlH9U6KMSm7789zM3_g', 2, 0, '2026-01-24 14:00:09', '2025-12-25 15:00:09'),
(125, '539dc750-bf09-46ce-8922-35d96f798e56', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjY3MTIzNywianRpIjoiNTM5ZGM3NTAtYmYwOS00NmNlLTg5MjItMzVkOTZmNzk4ZTU2IiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2NjcxMjM3LCJjc3JmIjoiOTY1YmU0YzMtM2I1Ny00MDZkLWJhNWUtNGU5MWFhOTBkNjc1IiwiZXhwIjoxNzY5MjYzMjM3fQ.mvPuauCLoSCuzyHtgNRO5jYRVT-uXfpB0qLGxC3ftD8', 2, 1, '2026-01-24 14:00:37', '2025-12-25 15:00:37'),
(126, '68dbafbc-a71f-4d9c-8ee9-d38980ac8af1', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjY3MTU3NiwianRpIjoiNjhkYmFmYmMtYTcxZi00ZDljLThlZTktZDM4OTgwYWM4YWYxIiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIxIiwibmJmIjoxNzY2NjcxNTc2LCJjc3JmIjoiODE2ZTQ2MWEtMTQzOS00ZDE5LWFiMDAtZTA2MmRjNjg5Y2I2IiwiZXhwIjoxNzY5MjYzNTc2fQ.oM99O8m-U_10KNc6JoTX_fKqmJLiLprBp57w-A0nuYY', 1, 0, '2026-01-24 14:06:16', '2025-12-25 15:06:17'),
(127, '770fdd97-66a5-42d8-88e5-59687ad830bb', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjY3MjE1MiwianRpIjoiNzcwZmRkOTctNjZhNS00MmQ4LTg4ZTUtNTk2ODdhZDgzMGJiIiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIxIiwibmJmIjoxNzY2NjcyMTUyLCJjc3JmIjoiODRmYmYxNTAtZmU3Yy00YjUwLWIxNWItN2E3NWU0MTk4NTljIiwiZXhwIjoxNzY5MjY0MTUyfQ.2DAo_Nn53sNrUo4Nxmrnzy4Pc13kI0ftCk8DrlWbUSM', 1, 0, '2026-01-24 14:15:52', '2025-12-25 15:15:52'),
(128, '4b274bdc-8aa8-4b85-a987-52ce2691a508', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjY3MjgyNywianRpIjoiNGIyNzRiZGMtOGFhOC00Yjg1LWE5ODctNTJjZTI2OTFhNTA4IiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIxIiwibmJmIjoxNzY2NjcyODI3LCJjc3JmIjoiYjY0ZTVmMmQtZWFhZC00ODk1LThiNjItNTE2NGYyYjFmMGViIiwiZXhwIjoxNzY5MjY0ODI3fQ.zbQjemWpHHICg3Gg7-1kQM5WG3eRksH6Lbf2PC-rccc', 1, 0, '2026-01-24 14:27:07', '2025-12-25 15:27:07'),
(129, '61a94740-ebe5-4c5c-a5dd-b40d744ef45b', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2Njc1MzUxOCwianRpIjoiNjFhOTQ3NDAtZWJlNS00YzVjLWE1ZGQtYjQwZDc0NGVmNDViIiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2NzUzNTE4LCJjc3JmIjoiMWUyZGM3NGItMWZjYy00NzdlLWExMDgtM2RlNDA4YmRkMGMzIiwiZXhwIjoxNzY5MzQ1NTE4fQ.hoMZxiP2LfckMpMK_xfq8OgB2F-O1vBhGVA-gIgi9BY', 2, 0, '2026-01-25 12:51:58', '2025-12-26 13:51:58'),
(130, 'dc982d58-cb39-4bab-8349-e9b71f380a02', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2Njc1MzgxNiwianRpIjoiZGM5ODJkNTgtY2IzOS00YmFiLTgzNDktZTliNzFmMzgwYTAyIiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2NzUzODE2LCJjc3JmIjoiYTYwMjhmN2EtZmMwNi00MDA1LWIzMGEtYzEwYjUyNjM2MTYwIiwiZXhwIjoxNzY5MzQ1ODE2fQ.PpDFCdBof5JbKZOifBHJnYdXF2EaUl18zyt0_8Xjy5Q', 2, 0, '2026-01-25 12:56:56', '2025-12-26 13:56:56'),
(131, '7b35837e-6897-481c-96c1-14f4eaf7e59a', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2Njc1NDc4NSwianRpIjoiN2IzNTgzN2UtNjg5Ny00ODFjLTk2YzEtMTRmNGVhZjdlNTlhIiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2NzU0Nzg1LCJjc3JmIjoiNWI2MmYxZWMtODI0Ny00YzFjLWFmMGMtY2QzNWU4NTMwY2ExIiwiZXhwIjoxNzY5MzQ2Nzg1fQ.SIIIT4F9ZdxS43OlLGQscgr97DP30UHiDUo0hIHX2fI', 2, 0, '2026-01-25 13:13:05', '2025-12-26 14:13:05'),
(132, '241a15e8-680f-481f-9ef6-527451dd2dc4', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2Njc1NjI1NiwianRpIjoiMjQxYTE1ZTgtNjgwZi00ODFmLTllZjYtNTI3NDUxZGQyZGM0IiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2NzU2MjU2LCJjc3JmIjoiZTBmMGVjMjEtYWQ2ZC00ZTI4LWFjNDYtMmNjYmE3NTg0YmRiIiwiZXhwIjoxNzY5MzQ4MjU2fQ.-ddjeVlFux9DBv33NdmabqQbrwdCfkQAWwMc0Q8ilW0', 2, 1, '2026-01-25 13:37:36', '2025-12-26 14:37:36'),
(133, '623df3fb-235a-45a1-ac05-8a2dccae8e36', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2Njc1ODQ4NSwianRpIjoiNjIzZGYzZmItMjM1YS00NWExLWFjMDUtOGEyZGNjYWU4ZTM2IiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2NzU4NDg1LCJjc3JmIjoiMTMwNDhmNmMtOTYyMy00MDVmLTkyMzktMDFjNmM1ZGZjYjA5IiwiZXhwIjoxNzY5MzUwNDg1fQ.mBNUIJQl5_RTm6PQ92hBcKqu16svOqkQqAwqgw0dErM', 2, 0, '2026-01-25 14:14:45', '2025-12-26 15:14:45'),
(134, '0c4c21e7-2e24-4ade-acf5-4dcce0a9f163', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2Njc2MDM1OSwianRpIjoiMGM0YzIxZTctMmUyNC00YWRlLWFjZjUtNGRjY2UwYTlmMTYzIiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2NzYwMzU5LCJjc3JmIjoiNjNmMjU2YmYtMmVkMy00OTRhLWI5ODgtMmVmMzQ5OTIwZTgwIiwiZXhwIjoxNzY5MzUyMzU5fQ.sA3uqFDeSfclRj5v_26c0B_8dQn_40J7AyB81Q5H3D8', 2, 0, '2026-01-25 14:45:59', '2025-12-26 15:45:59'),
(135, '65ab850b-dcbc-44c6-92cb-87fd16e03948', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2Njc4NTM1OSwianRpIjoiNjVhYjg1MGItZGNiYy00NGM2LTkyY2ItODdmZDE2ZTAzOTQ4IiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2Nzg1MzU5LCJjc3JmIjoiMzMzNDI4MDktNjI5OC00NzM2LWFjZjQtNDJkMGVjYzEzZWJjIiwiZXhwIjoxNzY5Mzc3MzU5fQ.tA-lK-XsQY5KyJUzPs39Pijdu1MvHt0n0efQPEEmW-Q', 2, 1, '2026-01-25 21:42:39', '2025-12-26 22:42:39'),
(136, '958a8d3b-e4fc-409b-94ca-ff1999e3fb10', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2Njc4NjU2OSwianRpIjoiOTU4YThkM2ItZTRmYy00MDliLTk0Y2EtZmYxOTk5ZTNmYjEwIiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2Nzg2NTY5LCJjc3JmIjoiZDM2MDYzYWQtNWMxNi00YTM5LWIwMDEtODBjNzdmYzRiNjJmIiwiZXhwIjoxNzY5Mzc4NTY5fQ.LAVt331uSLtzo8oDQ6WTp7vj7UFAF0MSJQ4mDYNvOAE', 2, 1, '2026-01-25 22:02:49', '2025-12-26 23:02:49'),
(137, '85b7a377-650d-4f8f-b690-eade4596b859', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2Njc4NjY2NiwianRpIjoiODViN2EzNzctNjUwZC00ZjhmLWI2OTAtZWFkZTQ1OTZiODU5IiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2Nzg2NjY2LCJjc3JmIjoiNjk2ZWI4MjUtZDNiMy00NjdlLWE1OGItNWFmZjgxODAwZTJiIiwiZXhwIjoxNzY5Mzc4NjY2fQ.snSz87nU0qrrIOyZwwq3qwNS6sVfNUL6ZJo6X3dU4wQ', 2, 1, '2026-01-25 22:04:26', '2025-12-26 23:04:26'),
(138, '0daab8bf-1d8e-48a0-b5e6-85340f9af241', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2Njc4Nzk3NSwianRpIjoiMGRhYWI4YmYtMWQ4ZS00OGEwLWI1ZTYtODUzNDBmOWFmMjQxIiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2Nzg3OTc1LCJjc3JmIjoiNTFkYTM4MzAtODBiNC00N2RlLWE3MmQtNTBlNjExY2M4MDQ5IiwiZXhwIjoxNzY5Mzc5OTc1fQ.hdMUX4eT_eNA78UPdk3OkbPqoAgUAAFqbMvF3sk6WFI', 2, 0, '2026-01-25 22:26:15', '2025-12-26 23:26:15'),
(139, '8a8f1392-7e63-494b-95a6-a408b103baa9', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjgyNzU0MCwianRpIjoiOGE4ZjEzOTItN2U2My00OTRiLTk1YTYtYTQwOGIxMDNiYWE5IiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiI0IiwibmJmIjoxNzY2ODI3NTQwLCJjc3JmIjoiNGNhYzFjZDQtNGEyNi00NjZlLThmY2EtOTU5NGQ3OGFiODUxIiwiZXhwIjoxNzY5NDE5NTQwfQ.4diEN56Od2Nxl7fdW5Zx0vkwJBqvbKouOvCkVyJte4w', 4, 1, '2026-01-26 09:25:40', '2025-12-27 10:25:40'),
(140, '9398cb9e-bebf-4aa9-95bc-8ce97e6f5f6d', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2NjgyNzU1NiwianRpIjoiOTM5OGNiOWUtYmViZi00YWE5LTk1YmMtOGNlOTdlNmY1ZjZkIiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY2ODI3NTU2LCJjc3JmIjoiNmYzYWI1ZjQtN2E2Mi00ZTM1LTg0ZTctZmFjYjQ0ZmU3NzI2IiwiZXhwIjoxNzY5NDE5NTU2fQ.a_TO-1xjQjEdV7M0UpG4gmGAH5b93MxXdO0-r1UZkcM', 2, 1, '2026-01-26 09:25:56', '2025-12-27 10:25:56'),
(141, '54260f91-c4c3-41e0-86cc-2c9e99710ca2', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2Nzg2MzE5OSwianRpIjoiNTQyNjBmOTEtYzRjMy00MWUwLTg2Y2MtMmM5ZTk5NzEwY2EyIiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY3ODYzMTk5LCJjc3JmIjoiZmEwYjkxZjYtMmQ4MS00ZDFhLWE2MDctNzU4MzI4YTRjODRjIiwiZXhwIjoxNzcwNDU1MTk5fQ.aEbXhqzo7VYhfOet0qs-7N-D9O4l6BU_n4whYXJsOvQ', 2, 1, '2026-02-07 09:06:39', '2026-01-08 10:06:39'),
(142, '2b0d3a48-6058-4759-9f10-b00980b95c3f', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2Nzg2NDQ4MCwianRpIjoiMmIwZDNhNDgtNjA1OC00NzU5LTlmMTAtYjAwOTgwYjk1YzNmIiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiI1IiwibmJmIjoxNzY3ODY0NDgwLCJjc3JmIjoiNDY0NTUzZDItMDdjMy00OGY0LWEzY2EtMTg0OGU3ZTNlYjgzIiwiZXhwIjoxNzcwNDU2NDgwfQ.DPsaOx3xNmVNJ0amT4OKfAgNi6yKtD7z4MAzCvS9sB4', 5, 1, '2026-02-07 09:28:00', '2026-01-08 10:28:00'),
(143, '9df318e0-521b-4fe8-9503-e47e237884b2', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2ODA1NzEyOCwianRpIjoiOWRmMzE4ZTAtNTIxYi00ZmU4LTk1MDMtZTQ3ZTIzNzg4NGIyIiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY4MDU3MTI4LCJjc3JmIjoiODc4N2Y2NzUtOWRlMy00ZGVhLWEwYzctYTU0ZjhhNWRhNzgyIiwiZXhwIjoxNzcwNjQ5MTI4fQ.MtLCzBpb-0s2pNUUtvX9OZgykgdGR3O8YnPmCpXhcQU', 2, 0, '2026-02-09 14:58:48', '2026-01-10 15:58:48'),
(144, '002067a3-072b-4538-84d5-cbadcd66d322', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2ODY0NjgyMiwianRpIjoiMDAyMDY3YTMtMDcyYi00NTM4LTg0ZDUtY2JhZGNkNjZkMzIyIiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY4NjQ2ODIyLCJjc3JmIjoiMTYzNzkzMmMtMGExMC00NWZiLTg1NzQtMmVlMWIwNTEzZTEzIiwiZXhwIjoxNzcxMjM4ODIyfQ.U4Skva5CkCscxH9d5gRVq7LAPDqeZZRUN2pxTSbUdxw', 2, 1, '2026-02-16 10:47:02', '2026-01-17 11:47:02'),
(145, '239f77c4-abbd-4893-abb6-b3505fcce7a4', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2ODY0Nzg0MSwianRpIjoiMjM5Zjc3YzQtYWJiZC00ODkzLWFiYjYtYjM1MDVmY2NlN2E0IiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiI2IiwibmJmIjoxNzY4NjQ3ODQxLCJjc3JmIjoiZGFjYTY2MDUtODhmNy00NzYyLThmZTQtYTdiYjkwZjM0YzNjIiwiZXhwIjoxNzcxMjM5ODQxfQ.kez8dueC7j28MNzvvlNAAd0zpmnwsjuQXpokxwUOgJQ', 6, 1, '2026-02-16 11:04:01', '2026-01-17 12:04:01'),
(146, 'f54b08db-352d-4442-8ac5-bf921305c8c5', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2ODY0ODE0MiwianRpIjoiZjU0YjA4ZGItMzUyZC00NDQyLThhYzUtYmY5MjEzMDVjOGM1IiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY4NjQ4MTQyLCJjc3JmIjoiMzJjMGIxYzgtMGQ3ZS00NGE1LThmM2EtMDhiYzFkNTIwODc5IiwiZXhwIjoxNzcxMjQwMTQyfQ.y1IJ-G0UAv3zBg-1OTd5n0Bm3QVD4RkL6OTTDeJ6xU0', 2, 0, '2026-02-16 11:09:02', '2026-01-17 12:09:02'),
(147, 'd444df51-6248-4b95-90de-45b3ecab6288', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2OTg3NDQ3MywianRpIjoiZDQ0NGRmNTEtNjI0OC00Yjk1LTkwZGUtNDViM2VjYWI2Mjg4IiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIyIiwibmJmIjoxNzY5ODc0NDczLCJjc3JmIjoiNjFjYTBkMDMtMGE4Yy00MGY5LThlYmQtMGU5YThjYjI1YmRmIiwiZXhwIjoxNzcyNDY2NDczfQ.sUYA1xzgceXkACSp80NyJ6NQ2zLnS7MAGVpzTBN6CK4', 2, 0, '2026-03-02 15:47:53', '2026-01-31 16:47:53'),
(148, '2ce822d4-c559-4e41-9d2f-baa4ed58098d', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc3MjU3MTIzMywianRpIjoiMmNlODIyZDQtYzU1OS00ZTQxLTlkMmYtYmFhNGVkNTgwOThkIiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiI3IiwibmJmIjoxNzcyNTcxMjMzLCJjc3JmIjoiN2JhMTdlZDEtYTViMy00NWU4LTg2ZTEtMzlkNGVkNmMyY2M2IiwiZXhwIjoxNzc1MTYzMjMzfQ.xQFUJ6BEbd8SpG0f9JAqPldItIWUcQWdcuDXOVRFZyY', 7, 0, '2026-04-02 20:53:53', '2026-03-03 21:53:53'),
(149, '2c08c669-ff7f-473e-b053-c9fe745efd18', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc3MjU3MTU4NSwianRpIjoiMmMwOGM2NjktZmY3Zi00NzNlLWIwNTMtYzlmZTc0NWVmZDE4IiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiI3IiwibmJmIjoxNzcyNTcxNTg1LCJjc3JmIjoiOTk1OGI4MjYtNjE2ZS00ZmNmLWFiYzgtYTY1N2E2ZGMwYjgwIiwiZXhwIjoxNzc1MTYzNTg1fQ.mekwkHl_tok_pM4FojPYF5H_Y59pV8ShRDv-jurwup8', 7, 0, '2026-04-02 20:59:45', '2026-03-03 21:59:45'),
(150, '112b83d5-090a-4494-9d67-d9c207976fac', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc3MjU3MjU2NSwianRpIjoiMTEyYjgzZDUtMDkwYS00NDk0LTlkNjctZDljMjA3OTc2ZmFjIiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiI3IiwibmJmIjoxNzcyNTcyNTY1LCJjc3JmIjoiZWJmMDYxMzgtZDBlMC00YWI4LWI5OGUtNWZmNzBiNzExZjJjIiwiZXhwIjoxNzc1MTY0NTY1fQ.HVYNhnbz0_10dnY6dY-MkE2bT9fXq0ID5DP2lXZWnsI', 7, 0, '2026-04-02 21:16:05', '2026-03-03 22:16:05'),
(151, 'd2b0b4e7-8e83-43de-840c-3d466c82a735', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc3MjU3MzQxMiwianRpIjoiZDJiMGI0ZTctOGU4My00M2RlLTg0MGMtM2Q0NjZjODJhNzM1IiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiI3IiwibmJmIjoxNzcyNTczNDEyLCJjc3JmIjoiNWNhODZhNTYtYTIyZS00NTQ0LWFjZjAtZmZmZDBlOTc3YTYzIiwiZXhwIjoxNzc1MTY1NDEyfQ.kd4gQofUbepSeGfVB83nj_Qa34igDoPXsLf2NUO14tU', 7, 0, '2026-04-02 21:30:12', '2026-03-03 22:30:12'),
(152, 'e9dd152a-eb2b-4efa-a6ad-a90b57543db2', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc3MjU3NzI3OCwianRpIjoiZTlkZDE1MmEtZWIyYi00ZWZhLWE2YWQtYTkwYjU3NTQzZGIyIiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiIxIiwibmJmIjoxNzcyNTc3Mjc4LCJjc3JmIjoiYmRhNWM4ZDAtZGNhNS00YWZmLTllODctOTU3M2U0YzA1YzgyIiwiZXhwIjoxNzc1MTY5Mjc4fQ.FAwNAvmk764F417LPYLN5iDwPzqMInlCITMVXbClXN8', 1, 1, '2026-04-02 22:34:38', '2026-03-03 23:34:38'),
(153, '03edf1de-f1eb-4e2b-8462-bd86052e53d6', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc3MjU3NzY4MiwianRpIjoiMDNlZGYxZGUtZjFlYi00ZTJiLTg0NjItYmQ4NjA1MmU1M2Q2IiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiI3IiwibmJmIjoxNzcyNTc3NjgyLCJjc3JmIjoiNWEyMzA4MjctZDBhYi00NTBmLWE1MjgtZGZkNzFhNjNlZGRlIiwiZXhwIjoxNzc1MTY5NjgyfQ.x5ArGNWlKrmkxqpvyfci0fUHkxu3XunZKnzHQZm9PQ0', 7, 1, '2026-04-02 22:41:22', '2026-03-03 23:41:22'),
(154, 'e8e6aac4-506e-4384-a10b-5d0c31567689', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc3MjU3Nzc1NiwianRpIjoiZThlNmFhYzQtNTA2ZS00Mzg0LWExMGItNWQwYzMxNTY3Njg5IiwidHlwZSI6InJlZnJlc2giLCJzdWIiOiI3IiwibmJmIjoxNzcyNTc3NzU2LCJjc3JmIjoiNjcwOTAwN2UtNjU3MS00NWM3LWI1MjktYWUzYjYzOWQzZmQ4IiwiZXhwIjoxNzc1MTY5NzU2fQ.ho6Ut3ihC_dZ0dxs4TzjnGyKgGEqtwQ-uG3VlHwkrKg', 7, 0, '2026-04-02 22:42:36', '2026-03-03 23:42:36');

-- --------------------------------------------------------

--
-- Table structure for table `savings_contributions`
--

CREATE TABLE `savings_contributions` (
  `id` int(10) UNSIGNED NOT NULL,
  `profile_id` int(10) UNSIGNED NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `amount` decimal(12,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `savings_contributions`
--

INSERT INTO `savings_contributions` (`id`, `profile_id`, `created_at`, `amount`) VALUES
(15, 2, '2025-12-25 15:32:35', 100.00),
(17, 7, '2026-01-08 10:34:25', 100.00),
(18, 3, '2026-01-31 17:00:21', 3000.00);

-- --------------------------------------------------------

--
-- Table structure for table `savings_profiles`
--

CREATE TABLE `savings_profiles` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `goal_amount` decimal(12,2) NOT NULL DEFAULT 0.00,
  `target_date` date DEFAULT NULL,
  `frequency` varchar(50) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `savings_profiles`
--

INSERT INTO `savings_profiles` (`id`, `user_id`, `name`, `goal_amount`, `target_date`, `frequency`, `created_at`, `updated_at`) VALUES
(2, 1, 'By a house ', 100000.00, '2028-04-28', 'daily', '2025-12-23 16:33:27', '2025-12-23 16:33:27'),
(3, 2, 'Buy a new House ', 5000000.00, '2025-12-20', 'daily', '2025-12-24 10:04:16', '2025-12-24 10:04:16'),
(4, 3, 'Christmas 2026', 2000000000.00, '2026-12-25', 'daily', '2025-12-24 11:05:37', '2025-12-24 11:05:37'),
(7, 5, 'by a 🏡', 100000.00, '2026-01-15', 'daily', '2026-01-08 10:33:42', '2026-01-08 10:33:42');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(10) UNSIGNED NOT NULL,
  `email` varchar(255) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `first_name` varchar(100) DEFAULT NULL,
  `last_name` varchar(100) DEFAULT NULL,
  `phone` varchar(30) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `balance` decimal(12,2) DEFAULT 0.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `email`, `password_hash`, `first_name`, `last_name`, `phone`, `created_at`, `updated_at`, `balance`) VALUES
(1, 'betrandojong146@gmail.com', '$2b$12$Dw5ALrXOme2Ka0lnxybO9Oz.Uek5IyFjf30eivWDiLHjB7HFvN30i', 'Betrand', 'Ojong', '650537134', '2025-12-21 21:58:23', '2026-03-03 23:39:38', 5100.00),
(2, 'ojongbetrand146@gmail.com', '$2b$12$avbQoo0kN3arHLLnUk9ituhx6u3xOQuFXb2FsgjQF2aPvVFMx.I7W', 'Ojong ', 'Akum ', '12345678', '2025-12-22 00:32:07', '2026-01-17 12:15:09', 990804.00),
(3, 'enow12@gmail.com', '$2b$12$3bbZ2shDESDS64ukQBt7o.Inh2LLO6lrD44Sw6ybqEm61IXH1qnwK', 'Martin ', 'Nkongho', '653275590', '2025-12-24 11:01:28', '2025-12-24 11:01:28', 0.00),
(4, 'lolicruz@gmail.com', '$2b$12$8hLrXAO3rTZBeBrjEoqHbOfYagFfY.0vXi1HKuq8uFqGJQA51BX8y', 'Loli ', 'Cruz', '651321719', '2025-12-27 10:25:00', '2025-12-27 10:34:10', 100000.00),
(5, 'jonhdoe@gmail.com', '$2b$12$C3CV27cCPm/FTHo5wwtzI.z0Fofy6MpGbmP8P3enZHVxzOJXQo.Ey', 'john', 'deo', '12345678', '2026-01-08 10:23:01', '2026-01-08 10:30:45', 10000.00),
(6, 'deshnic@mail.com', '$2b$12$hHHXO5/gHdxHtr9dDPu2uOsgbTjbwUhbbyX5EGfHpYoVQprCpXTj2', 'Deshnic', 'Nkwenti', '673854545', '2026-01-17 12:03:31', '2026-01-17 12:03:31', 0.00),
(7, 'joseph12@gmail.com', '$2b$12$.9sMdidUWof1a6qGR5RhJuAivC39NQc1C7sDp38HGztWAsFQAMNSu', 'joseph', 'banner', '123456789', '2026-03-03 21:53:35', '2026-03-03 23:44:46', 1000.00);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `contributions`
--
ALTER TABLE `contributions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `confirmed_by` (`confirmed_by`),
  ADD KEY `idx_group_status` (`group_id`,`status`);

--
-- Indexes for table `expenses`
--
ALTER TABLE `expenses`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_tracking_id` (`tracking_id`);

--
-- Indexes for table `expense_trackings`
--
ALTER TABLE `expense_trackings`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `ux_user_tracking_name` (`user_id`,`name`),
  ADD KEY `idx_tracking_user` (`user_id`);

--
-- Indexes for table `groups`
--
ALTER TABLE `groups`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code` (`code`),
  ADD KEY `admin_id` (`admin_id`);

--
-- Indexes for table `group_members`
--
ALTER TABLE `group_members`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `ux_group_user` (`group_id`,`user_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `group_id` (`group_id`);

--
-- Indexes for table `refresh_tokens`
--
ALTER TABLE `refresh_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `jti` (`jti`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `savings_contributions`
--
ALTER TABLE `savings_contributions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_profile_id` (`profile_id`);

--
-- Indexes for table `savings_profiles`
--
ALTER TABLE `savings_profiles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `ux_user_profile_name` (`user_id`,`name`),
  ADD KEY `idx_user_id` (`user_id`);

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
-- AUTO_INCREMENT for table `contributions`
--
ALTER TABLE `contributions`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT for table `expenses`
--
ALTER TABLE `expenses`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `expense_trackings`
--
ALTER TABLE `expense_trackings`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `groups`
--
ALTER TABLE `groups`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `group_members`
--
ALTER TABLE `group_members`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=85;

--
-- AUTO_INCREMENT for table `refresh_tokens`
--
ALTER TABLE `refresh_tokens`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=155;

--
-- AUTO_INCREMENT for table `savings_contributions`
--
ALTER TABLE `savings_contributions`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `savings_profiles`
--
ALTER TABLE `savings_profiles`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `contributions`
--
ALTER TABLE `contributions`
  ADD CONSTRAINT `contributions_ibfk_1` FOREIGN KEY (`group_id`) REFERENCES `groups` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `contributions_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `contributions_ibfk_3` FOREIGN KEY (`confirmed_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `expenses`
--
ALTER TABLE `expenses`
  ADD CONSTRAINT `expenses_ibfk_1` FOREIGN KEY (`tracking_id`) REFERENCES `expense_trackings` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `expense_trackings`
--
ALTER TABLE `expense_trackings`
  ADD CONSTRAINT `expense_trackings_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `groups`
--
ALTER TABLE `groups`
  ADD CONSTRAINT `groups_ibfk_1` FOREIGN KEY (`admin_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `group_members`
--
ALTER TABLE `group_members`
  ADD CONSTRAINT `group_members_ibfk_1` FOREIGN KEY (`group_id`) REFERENCES `groups` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `group_members_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `notifications_ibfk_2` FOREIGN KEY (`group_id`) REFERENCES `groups` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `refresh_tokens`
--
ALTER TABLE `refresh_tokens`
  ADD CONSTRAINT `refresh_tokens_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `savings_contributions`
--
ALTER TABLE `savings_contributions`
  ADD CONSTRAINT `savings_contributions_ibfk_1` FOREIGN KEY (`profile_id`) REFERENCES `savings_profiles` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `savings_profiles`
--
ALTER TABLE `savings_profiles`
  ADD CONSTRAINT `savings_profiles_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

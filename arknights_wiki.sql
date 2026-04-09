-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 07, 2026 at 03:59 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `arknights_wiki`
--
CREATE DATABASE IF NOT EXISTS `arknights_wiki` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `arknights_wiki`;

-- --------------------------------------------------------

--
-- Table structure for table `banners`
--

DROP TABLE IF EXISTS `banners`;
CREATE TABLE `banners` (
  `id` varchar(50) NOT NULL,
  `type` enum('feat','std') NOT NULL DEFAULT 'feat',
  `name` varchar(150) NOT NULL,
  `op` varchar(150) DEFAULT 'TBA',
  `rarity` tinyint(4) NOT NULL DEFAULT 6,
  `game` varchar(50) NOT NULL DEFAULT 'Arknights',
  `date` varchar(100) DEFAULT 'TBA',
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `image` varchar(500) DEFAULT '',
  `drop_info` text DEFAULT NULL,
  `about` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `banners`
--

INSERT INTO `banners` (`id`, `type`, `name`, `op`, `rarity`, `game`, `date`, `start_date`, `end_date`, `image`, `drop_info`, `about`, `created_at`, `updated_at`) VALUES
('b1', 'feat', 'Deep Resonance', 'Skadi the Corrupting Heart', 6, 'Arknights', 'Until 2025-04-10', '2025-03-20', '2025-04-10', 'https://arknights.wiki.gg/images/thumb/Skadi_the_Corrupting_Heart_Elite_2.png/1024px-Skadi_the_Corrupting_Heart_Elite_2.png?d9fa21', '2% rate. Guaranteed in 50 pulls. First 6★ is 50% Skadi.', 'A limited banner featuring Skadi the Corrupting Heart. This banner will NOT return to standard pool.', '2026-04-04 15:18:29', '2026-04-04 15:18:29'),
('b2', 'feat', 'Lumen Protocol', 'Logos', 6, 'Endfield', 'Until 2025-06-30', '2025-06-01', '2025-06-30', 'https://arknights.wiki.gg/images/thumb/Logos_Elite_2.png/1021px-Logos_Elite_2.png?8f89cc', '1.5% base rate. Pity at 80 pulls.', 'Logos is the first limited Sankta operator in Endfield. Electric AoE kit is a priority pick for Talos-I expedition content.', '2026-04-04 15:18:29', '2026-04-04 15:18:29'),
('b3', 'std', 'Cryo Formation', 'Perlica', 6, 'Endfield', 'Permanent', NULL, NULL, 'https://endfield.wiki.gg/images/thumb/Perlica_Splash_Art.png/1024px-Perlica_Splash_Art.png?61e9d0', '1.5% base rate. Pity carries across banners.', 'Perlica remains the highest-DPS Caster in current Endfield meta. Her S3 creates persistent ice zones.', '2026-04-04 15:18:29', '2026-04-05 09:34:36'),
('b4', 'std', 'Standard Headhunting', 'Thorns, Surtr, W, Eyjafjalla + more', 6, 'Arknights', 'Permanent', NULL, NULL, 'https://arknights.wiki.gg/images/thumb/Surtr_Skin_2.png/1024px-Surtr_Skin_2.png?fab67c', '2% rate. Soft pity at 50, hard pity at 99.', 'The standard pool contains all non-limited 6★ operators. New operators added 6 months after debut.', '2026-04-04 15:18:29', '2026-04-04 15:18:29'),
('b5', 'std', 'Pioneer Standard', 'Ines, Wulfgard + more', 6, 'Endfield', 'Permanent', NULL, NULL, 'https://arknights.wiki.gg/images/thumb/Ines_Skin_2.png/1024px-Ines_Skin_2.png?1f4610', '1.5% base rate. Hard pity at 80.', 'The Endfield standard pool with flagship 6★ picks.', '2026-04-04 15:18:29', '2026-04-04 15:18:29'),
('b6', 'feat', 'Yidhari', 'Pulchra and Panyun', 6, 'Zenless Zone Zero', '04/05/2026', '2026-04-05', '2026-04-20', 'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fwww.videogamer.com%2Fwp-content%2Fuploads%2FYidhari-banner-in-Zenless-Zone-Zero.jpg&f=1&nofb=1&ipt=c1d14d055c044510c53f7fa3c313c8cf91d406ab5f43d87cf2a2d684a791a198', '0.075% to 100% at 80 Pity', 'Yidhari, an S-Rank Ice Rupture Agent, thrives on risk and reward, excelling when HP is low. She gains Sheer Force scaling with max HP, and her ice attacks always deal Sheer Damage, piercing defenses. As her HP drops, her damage increases, requiring careful balance between tanking and healing. She can charge basic attacks at the cost of HP for heavier hits, while some abilities restore it.', '2026-04-05 09:22:18', '2026-04-05 15:27:19'),
('b7', 'feat', 'Spotlight Pretty Derby Scout', 'Almond Eye', 6, 'Uma Musume', 'February 24, 2026 — March 30, 2026', '2026-02-24', '2026-03-30', 'https://umamusu.wiki/w/images/1/1c/Game_Banner_130416_JP.png', '(0.75%)', 'Almond Eye has long smooth light brown hair with a gentle inward curl at the tips. The inner layer is light blue with a soft lavender gradient.', '2026-04-04 15:18:29', '2026-04-06 00:40:17');

-- --------------------------------------------------------

--
-- Table structure for table `news`
--

DROP TABLE IF EXISTS `news`;
CREATE TABLE `news` (
  `id` int(11) NOT NULL,
  `type` enum('event','update','maintenance','collab','announcement') NOT NULL DEFAULT 'event',
  `game` varchar(50) NOT NULL DEFAULT 'arknights',
  `title` varchar(250) NOT NULL,
  `snip` varchar(500) DEFAULT NULL,
  `full` text DEFAULT NULL,
  `image` varchar(500) DEFAULT '',
  `icon` varchar(10) DEFAULT '?',
  `date` varchar(80) NOT NULL DEFAULT 'TBA',
  `is_hero` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `news`
--

INSERT INTO `news` (`id`, `type`, `game`, `title`, `snip`, `full`, `image`, `icon`, `date`, `is_hero`, `created_at`, `updated_at`) VALUES
(1, 'event', 'arknights', 'Contingency Contract Season 12 — Stormwatch', 'The twelfth CC season arrives with three new maps, revised punishment zones, and the debut of two new Risk operators.', 'Contingency Contract Season 12 brings a fresh set of challenges to seasoned doctors. Three brand-new maps have been added, each featuring revised punishment zones designed to pressure even the most optimized lineups. This season also introduces two new Risk operators into the rotating roster. Players who complete all permanent risk stages will receive the exclusive CC Season 12 badge and title.', 'https://arknights.wiki.gg/images/thumb/Thorns_the_Lodestar_Skin_1.png/1024px-Thorns_the_Lodestar_Skin_1.png?bbd51b', '🎯', 'April 1, 2026', 1, '2026-04-04 15:18:29', '2026-04-04 15:18:29'),
(2, 'update', 'endfield', 'Endfield v1.2 — Talos-II Expedition Patch', 'The Talos-II update expands the Endfield map with two new biomes, a squad loadout overhaul, and operator kit adjustments.', 'Endfield v1.2 is the largest content drop since launch. Two new biomes have been added to the Talos sector, bringing fresh enemy types and resource nodes. The squad loadout system has been completely overhauled. Perlica receives a buff to her S3 ice zone duration, while Logos sees a minor cooldown reduction on his E2 passive.', 'https://arknights.wiki.gg/images/thumb/Logos_Elite_2.png/1021px-Logos_Elite_2.png?8f89cc', '⚙️', 'March 28, 2026', 0, '2026-04-04 15:18:29', '2026-04-04 15:18:29'),
(3, 'collab', 'arknights', 'Uma Musume Pretty Derby Collaboration — Wave 2', 'The second wave of the Uma Musume collaboration is confirmed, bringing three new operators and exclusive login bonuses.', 'Following the success of the first wave, Yostar has confirmed a second wave of the Uma Musume Pretty Derby collaboration. Three new operators will be added to the featured banner pool alongside limited voice packs and a special collaboration event. Login bonuses during the event period include an exclusive furniture set themed around the Derby grounds.', 'https://umamusu.wiki/w/images/1/1c/Game_Banner_130416_JP.png', '🐎', 'March 20, 2026', 0, '2026-04-04 15:18:29', '2026-04-04 15:18:29'),
(4, 'maintenance', 'both', 'Scheduled Maintenance — April 7, 2026', 'Both Arknights and Endfield servers will undergo maintenance on April 7 from 10:00 to 14:00 UTC.', 'Scheduled maintenance for both Arknights and Arknights: Endfield is planned for April 7, 2026 between 10:00 and 14:00 UTC. Compensation of 200 Orundum (Arknights) and 1500 Ingots (Endfield) will be distributed to all players who log in within 7 days of maintenance completion.', 'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fwww.heypoorplayer.com%2Fwp-content%2Fuploads%2F2021%2F09%2Farknightspassenger.jpg&f=1&nofb=1&ipt=8f726bd0cc2754137589af26256ed7d81663252900c62f59da64d6c69a14ba5c', '🔧', 'April 7, 2026', 0, '2026-04-04 15:18:29', '2026-04-04 15:18:29'),
(5, 'announcement', 'arknights', 'New Operator Teaser — Codenamed: Dawnbreaker', 'A cryptic teaser hints at an upcoming 6★ Caster with ties to the Bolivar faction and a unique multi-phase skill rotation.', 'The official Arknights social channels posted a short teaser video showing a silhouette in front of the Bolivar skyline. The teaser includes audio fragments and a loading screen referencing a codename: Dawnbreaker. Data miners have identified partial skill descriptors suggesting a 6★ Caster archetype with a unique three-phase skill that transitions between defensive and offensive modes.', 'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fshop.ldrescdn.com%2Frms%2Fld-space%2Fprocess%2Fimg%2F726995637f9246ceb7b1a20e31dcde711769054537.png%3F1769054539539%26x-oss-process%3Dimage%2Fformat%2Cwebp&f=1&nofb=1&ipt=d407a33c4f0da8d6220d86bbc48c58a6ec7a00cf65782457deb1f4cf55cda295', '🌅', 'March 15, 2026', 0, '2026-04-04 15:18:29', '2026-04-04 15:18:29');

-- --------------------------------------------------------

--
-- Table structure for table `operators`
--

DROP TABLE IF EXISTS `operators`;
CREATE TABLE `operators` (
  `id` int(11) NOT NULL,
  `game` varchar(50) NOT NULL DEFAULT 'arknights',
  `name` varchar(120) NOT NULL,
  `real_name` varchar(120) DEFAULT 'Unknown',
  `title` varchar(200) DEFAULT NULL,
  `rarity` tinyint(4) NOT NULL DEFAULT 5,
  `element` varchar(50) NOT NULL DEFAULT 'Physical',
  `class` varchar(80) NOT NULL DEFAULT 'Guard',
  `faction` varchar(120) DEFAULT 'Rhodes Island',
  `species` varchar(80) DEFAULT 'Human',
  `gender` varchar(20) DEFAULT 'Unknown',
  `height` varchar(20) DEFAULT 'Unknown',
  `birthday` varchar(50) DEFAULT 'Unknown',
  `release_date` varchar(50) DEFAULT 'TBA',
  `hp` int(11) DEFAULT 10000,
  `atk` int(11) DEFAULT 800,
  `def` int(11) DEFAULT 600,
  `res` int(11) DEFAULT 0,
  `tier` enum('S','A','B','C','D') DEFAULT NULL,
  `is_featured` tinyint(1) DEFAULT 0,
  `is_meta` tinyint(1) DEFAULT 0,
  `emoji` varchar(10) DEFAULT '⚡',
  `biography` text DEFAULT NULL,
  `image_url` varchar(500) DEFAULT '',
  `pfp_url` varchar(500) DEFAULT '',
  `gif_url` varchar(500) DEFAULT '',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `operators`
--

INSERT INTO `operators` (`id`, `game`, `name`, `real_name`, `title`, `rarity`, `element`, `class`, `faction`, `species`, `gender`, `height`, `birthday`, `release_date`, `hp`, `atk`, `def`, `res`, `tier`, `is_featured`, `is_meta`, `emoji`, `biography`, `image_url`, `pfp_url`, `gif_url`, `created_at`, `updated_at`) VALUES
(1, 'arknights', 'Thorns', 'Mishka', 'Liberi of the Warm Coast', 6, 'Physical', 'Guard', 'Rhodes Island', 'Liberi', 'Male', '189 cm', 'June 1', 'March 2021', 4826, 792, 487, 0, 'S', 1, 1, '⚔️', 'A former member of the Iberian sailing guild. His quiet, measured demeanor conceals a fierce sense of justice and a willingness to wade into the thickest of conflicts. He wields his spear with a fluid, almost hypnotic style reminiscent of ocean currents.', 'https://arknights.wiki.gg/images/thumb/Thorns_the_Lodestar_Skin_1.png/1024px-Thorns_the_Lodestar_Skin_1.png?bbd51b', 'https://arknights.wiki.gg/images/thumb/Thorns_the_Lodestar_Skin_1_icon.png/120px-Thorns_the_Lodestar_Skin_1_icon.png?9c97a0', 'https://media1.tenor.com/m/CnrruhdqA3UAAAAC/thorns-arknights.gif', '2026-04-04 15:18:29', '2026-04-04 15:18:29'),
(2, 'arknights', 'Surtr', 'Unknown', 'The Undying Fire', 6, 'Fire', 'Guard', 'Rhodes Island', 'Cautus', 'Female', '162 cm', 'August 9', 'September 2021', 4455, 864, 332, 0, 'S', 1, 1, '🔥', 'A taciturn Cautus warrior of exceptional destructive capability. Surtr rarely speaks but communicates with devastating efficiency through her blade. Her origins remain classified.', 'https://arknights.wiki.gg/images/thumb/Surtr_Elite_2.png/1024px-Surtr_Elite_2.png?860ff3', 'https://arknights.wiki.gg/images/thumb/Surtr_Elite_2_icon.png/120px-Surtr_Elite_2_icon.png?9d5608', 'https://media1.tenor.com/m/Q-KXXs1goGwAAAAd/arknights-endfield.gif', '2026-04-04 15:18:29', '2026-04-04 15:18:29'),
(3, 'arknights', 'Skadi the Corrupting Heart', 'Skadi', 'Herald of the Deep', 6, 'Physical', 'Supporter', 'Abyssal Hunters', 'Aegir', 'Female', '174 cm', 'January 12', 'August 2021', 6050, 572, 544, 0, 'A', 1, 0, '⚔️', 'Skadi has returned from the ocean depths changed in ways that are difficult to quantify. She maintains her composed professionalism but those who know her original form note subtle, unsettling differences.', 'https://arknights.wiki.gg/images/thumb/Skadi_the_Corrupting_Heart_Elite_2.png/1024px-Skadi_the_Corrupting_Heart_Elite_2.png?d9fa21', 'https://arknights.wiki.gg/images/thumb/Skadi_the_Corrupting_Heart_Elite_2_icon.png/120px-Skadi_the_Corrupting_Heart_Elite_2_icon.png?8e91da', 'https://media1.tenor.com/m/LFNxOWk83owAAAAd/skadi.gif', '2026-04-04 15:18:29', '2026-04-04 15:18:29'),
(4, 'arknights', 'W', 'W', 'The One Who Remains', 6, 'Physical', 'Sniper', 'Reunion (Defected)', 'Sarkaz', 'Female', '168 cm', 'December 25', 'April 2021', 3661, 748, 310, 0, 'S', 1, 1, '⚔️', 'A Sarkaz mercenary with a caustic wit and enthusiasm for explosive ordinance. She has worked for almost every major faction in Terra and appears to enjoy this enormously.', 'https://arknights.wiki.gg/images/thumb/W_Elite_2.png/1024px-W_Elite_2.png?d0a65a', 'https://arknights.wiki.gg/images/thumb/W_Elite_2_icon.png/120px-W_Elite_2_icon.png?5bef11', 'https://media1.tenor.com/m/qCgEthBCXykAAAAC/akwdg-arkights.gif', '2026-04-04 15:18:29', '2026-04-04 15:18:29'),
(5, 'arknights', 'Eyjafjalla', 'Eyja Murmansk', 'Volcano of the Highland', 6, 'Fire', 'Caster', 'Rhodes Island', 'Lupo', 'Female', '158 cm', 'February 10', 'January 2020', 3210, 731, 280, 0, 'B', 0, 0, '🔥', 'A geological researcher whose studies of tectonic arts have given her formidable combat abilities she deploys with cheerful detachment.', 'https://arknights.wiki.gg/images/thumb/Eyjafjalla_Skin_2.png/1024px-Eyjafjalla_Skin_2.png?462989', 'https://arknights.wiki.gg/images/thumb/Eyjafjalla_Skin_2_icon.png/120px-Eyjafjalla_Skin_2_icon.png?338b6f', 'https://media1.tenor.com/m/S0LakqM0JUAAAAAd/arknights-endfield.gif', '2026-04-04 15:18:29', '2026-04-04 15:18:29'),
(6, 'arknights', 'Kal\'tsit', 'Unknown', 'The Ancient Medic', 6, 'Physical', 'Medic', 'Rhodes Island', 'Cautus', 'Female', 'Unknown', 'Unknown', 'October 2020', 3765, 611, 419, 0, 'A', 0, 0, '⚔️', 'One of the most enigmatic figures aboard Rhodes Island. She has knowledge of events centuries old and speaks of them with the casual familiarity of personal memory.', 'https://arknights.wiki.gg/images/thumb/Kal%27tsit_Skin_1.png/1024px-Kal%27tsit_Skin_1.png?77a055', 'https://arknights.wiki.gg/images/thumb/Kal%27tsit_Skin_1_icon.png/120px-Kal%27tsit_Skin_1_icon.png?d2eb89', 'https://media.tenor.com/GGUvZ_2tKzsAAAAi/seseren-arknights.gif', '2026-04-04 15:18:29', '2026-04-04 15:18:29'),
(7, 'arknights', 'Texas', 'Unknown', 'Lone Trail', 5, 'Physical', 'Vanguard', 'Rhodes Island', 'Lupo', 'Female', '163 cm', 'June 10', 'April 2020', 3225, 486, 298, 0, 'B', 0, 0, '⚔️', 'Works for a Siracusan mafia family deployed to Rhodes Island. She is efficient, professional, and economically verbose — preferring to communicate in as few words as possible.', 'https://arknights.wiki.gg/images/thumb/Texas_Skin_2.png/1024px-Texas_Skin_2.png?8fba6a', 'https://arknights.wiki.gg/images/thumb/Texas_Skin_2_icon.png/120px-Texas_Skin_2_icon.png?df4b6b', 'https://media1.tenor.com/m/fU1YPCdZZOsAAAAC/texas-anime.gif', '2026-04-04 15:18:29', '2026-04-04 15:18:29'),
(8, 'arknights', 'Blaze', 'Unknown', 'Burning of the Soot', 6, 'Physical', 'Guard', 'Rhodes Island', 'Liberi', 'Female', '172 cm', 'August 18', 'June 2020', 5445, 748, 462, 0, 'B', 0, 0, '⚔️', 'A former street brawler whose raw combat talent caught the attention of Rhodes Island recruiters. She is loud, direct, and possesses enthusiasm for battle.', 'https://arknights.wiki.gg/images/thumb/Blaze_Skin_2.png/976px-Blaze_Skin_2.png?685c83', 'https://arknights.wiki.gg/images/thumb/Blaze_Skin_2_icon.png/120px-Blaze_Skin_2_icon.png?a1fc35', 'https://media1.tenor.com/m/XB1ZMAJZtFMAAAAC/blaze-arknights.gif', '2026-04-04 15:18:29', '2026-04-04 15:18:29'),
(9, 'arknights', 'Ines', 'Ines', 'Shell of the Earth', 6, 'Physical', 'Specialist', 'Rhodes Island', 'Liberi', 'Female', '157 cm', 'March 5', 'November 2019', 3565, 442, 618, 0, 'A', 0, 0, '⚔️', 'A stalwart defender who takes her protective role deeply seriously. Reliable in crisis, the kind of operator veteran commanders specifically request when things are expected to go badly.', 'images/art splash/Ines_Skin_1.png', 'images/pfp/ines-pfp.jpg', 'images/gif/ines-arknights.gif', '2026-04-04 15:18:29', '2026-04-04 15:18:29'),
(10, 'endfield', 'Perlica', 'Perlica', 'Chief Scientific Advisor', 6, 'Ice', 'Caster', 'Endfield Industries', 'Human', 'Female', 'Unknown', 'Unknown', '2025', 3600, 900, 280, 45, 'S', 1, 1, '❄️', 'Chief scientific advisor to the Endfield expedition. Her mastery of cryo-arts originates from years of fieldwork in frozen wastelands. She approaches both science and combat as exercises in optimization.', 'https://endfield.wiki.gg/images/thumb/Perlica_Splash_Art.png/1024px-Perlica_Splash_Art.png?61e9d0', 'https://endfield.wiki.gg/images/Perlica_Banner.png?9ac8db', 'https://media1.tenor.com/m/CGRP4MSNly0AAAAd/paypal-30000.gif', '2026-04-04 15:18:29', '2026-04-04 15:18:29'),
(11, 'zenless', 'Miyabi', 'Hoshimi Miyabi', 'Chief of Hollow Ops Section 6', 6, 'Ice', 'Anomaly', 'Hollow Special Operations Section 6', 'Thiren (Fox)', 'Female', '170 cm', 'June 19', 'December 18, 2024', 3600, 900, 280, 60, 'S', 1, 1, '❄️', 'Chief of Hollow Special Operations Section 6. A disciplined tactician whose cryo-arts reach absolute zero temperatures. Known for her unreadable expression and surgical precision in combat — her blade leaves frost in the air long after the strike.', 'https://static.wikia.nocookie.net/zenless-zone-zero/images/d/da/Agent_Hoshimi_Miyabi_Portrait.png/revision/latest/scale-to-width-down/1000?cb=20250329051641', 'https://i.pinimg.com/originals/13/2f/37/132f3796d43a9d1b525f6c85b7a1069c.jpg?nii=t', 'https://media1.tenor.com/m/s4o9viETfcwAAAAC/im-all-ears-miyabi.gif', '2026-04-04 15:18:29', '2026-04-04 15:18:29'),
(12, 'arknights', 'Logos', 'Logos', 'Wandering Lateran Scholar', 6, 'Electric', 'Caster', 'Laterano', 'Sankta', 'Male', 'Unknown', 'Unknown', '2025', 3800, 950, 260, 0, 'S', 0, 0, '⚡', 'A wandering Lateran whose connection to the faith is unorthodox. He processes information in ways that appear almost inhuman, constructing elaborate logical frameworks before any action.', 'https://arknights.wiki.gg/images/thumb/Logos_Elite_2.png/1021px-Logos_Elite_2.png?8f89cc', 'https://arknights.wiki.gg/images/thumb/Logos_Elite_2_icon.png/120px-Logos_Elite_2_icon.png?9a3704', 'https://media1.tenor.com/m/NtMIuH80ANUAAAAC/seseren-office-chair.gif', '2026-04-04 15:18:29', '2026-04-04 15:18:29'),
(13, 'endfield', 'Wulfgard', 'Wulfgard', 'Frontline Commander', 5, 'Physical', 'Defender', 'Endfield Industries', 'Human', 'Male', 'Unknown', 'Unknown', '2025', 6800, 520, 900, 20, 'B', 0, 0, '⚔️', 'A veteran defender with decades of service. Wulfgard is known among his squad as steady, dependable, and unexpectedly good at brewing field-ration coffee.', 'https://endfield.wiki.gg/images/thumb/Wulfgard_Splash_Art.png/1024px-Wulfgard_Splash_Art.png?f32aea', 'https://endfield.wiki.gg/images/Wulfgard_Banner.png?701777', 'https://media1.tenor.com/m/Jt-k6QJuz14AAAAd/wulfgard-endfield.gif', '2026-04-04 15:18:29', '2026-04-04 15:18:29'),
(14, 'arknights', 'Mudrock', 'Mudrock', 'Army Of One', 6, 'Physical', 'Defender', 'Rhodes Island', 'Sarkaz', 'Female', '163 cm', 'September 21', 'January 2024', 10000, 800, 600, 0, 'S', 0, 0, '⚔️', 'Sarkaz mercenary Mudrock, formerly a part of the Reunion Movement, led her team far from Ursus after disagreements with the organization. She had no involvement with Reunion whatsoever during the incidents in Chernobog and Lungmen. Searching for a foothold to establish, Mudrock took her team towards Leithanien.', 'https://arknights.wiki.gg/images/thumb/Mudrock_Skin_3.png/1024px-Mudrock_Skin_3.png?747c15', 'https://arknights.wiki.gg/images/thumb/Mudrock_Skin_2_icon.png/120px-Mudrock_Skin_2_icon.png?fcc46e', 'https://media1.tenor.com/m/xhQOa1Po2h8AAAAC/mudrock-spin.gif', '2026-04-04 15:18:29', '2026-04-04 15:18:29'),
(15, 'wutheringwaves', 'Zani', 'Zani', 'Scorched Radiance', 6, 'Physical', 'Hellbreaker', 'Monteli', 'Devil', 'Female', 'Unknown', 'Unknown', 'April 29, 2025', 4000, 943, 600, 30, 'A', 0, 0, '⚔️', 'Zani, a serious and reliable Montelli employee, follows a strict routine and manages tasks with ease. For years, she has clocked in on time without fail, finding as much enjoyment in her well-ordered life as in her carefully planned moments of leisure.', 'https://static.wikia.nocookie.net/wutheringwaves/images/e/ee/Zani_Splash_Art.png/revision/latest/scale-to-width-down/1000?cb=20250611111902', 'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fi.pinimg.com%2F736x%2Ff0%2F03%2F9c%2Ff0039cbd190bb07cd04fa37924d4c9e9.jpg&f=1&nofb=1&ipt=01603bcfaff47484b6b3be4073c8ac97f0177ee10b6b68d5cc5fe387df0d1aaa', 'https://media1.tenor.com/m/mc0r81qtLdMAAAAd/mariqini-tiktok-mariqini.gif', '2026-04-04 15:18:29', '2026-04-04 15:18:29'),
(16, 'umamusume', 'Forever Young', 'Forever Young', 'Everlasting Innovator', 6, 'Nature', 'Runner', 'Umamusume', 'Uma', 'Female', '167 cm', 'February 24', 'February 22, 2026', 10000, 800, 600, 15, 'B', 1, 0, '🌿', 'An innovative Umamusume who boasts that she will revolutionize the world of Umamusume. Wielding traits like the vitality of a gyaru, logical thinking fostered by watching races and businesses from all around the world at a young age, and extraordinary creativity as her weapons, she is working toward her project day after day.', 'https://umamusu.wiki/w/thumb.php?f=Forever_Young_%28Race%29.png&width=270', 'https://umamusu.wiki/w/thumb.php?f=Game_Asset_chara_stand_1138_000002.png&width=300', 'https://media.tenor.com/x3fXZkZh0NkAAAAi/forever-young-uma-musume.gif', '2026-04-04 15:18:29', '2026-04-05 03:11:17'),
(17, 'arknights', 'Exusiai', 'Asher', 'Carefree Messenger', 6, 'Physical', 'Sniper', 'Penguin Logistics', 'Sankta', 'Female', '155 cm', 'December 31', 'January 2020', 3290, 724, 298, 0, 'B', 0, 0, '⚔️', 'One of Penguin Logistics most reliable couriers, which is saying something considering her habit of snacking on the job. Exusiai brings unmatched ranged firepower and infectious cheerfulness to every deployment.', 'https://arknights.wiki.gg/images/thumb/Exusiai_Skin_3.png/1024px-Exusiai_Skin_3.png?a61efc', 'https://arknights.wiki.gg/images/thumb/Exusiai_Skin_3_icon.png/120px-Exusiai_Skin_3_icon.png', 'https://media1.tenor.com/m/8EcTaNr7oVEAAAAd/arknights-cute.gif', '2026-04-04 15:18:29', '2026-04-04 15:19:03'),
(18, 'umamusume', 'Oguri cap', 'Oguri cap', 'Ideal Idol', 6, 'Physical', 'Runner', 'Senior Division', 'Uma', 'Female', '167cm', 'March 27', 'March 27', 6000, 900, 100, 0, 'S', 0, 0, '⚔️', 'A coolheaded dreamer from the countryside.\nOriginally hailing from the countryside, she enrolled in Tracen Academy after dominating the racing scene back home. She works to make her hometown proud, but try as she might, her clumsy side always comes out. At the academy, she\'s known as a fearsome gourmand, able to empty an entire pot of rice in the blink of an eye.', 'https://umamusu.wiki/w/thumb.php?f=Oguri_Cap_%28Race%29.png&width=270', 'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fi.pinimg.com%2Foriginals%2Fc2%2Fae%2F17%2Fc2ae170e86ac57fb7c2ec18697adb75f.jpg%3Fnii%3Dt&f=1&nofb=1&ipt=680b5b1f7cb3fe222abc1ecf49450a4a436d05a2b82510c71a2658e29ebd42da', 'https://media.tenor.com/73zSqCwlnR8AAAAi/oguri-cap-chomp.gif', '2026-04-04 15:27:04', '2026-04-04 15:55:10'),
(19, 'umamusume', 'Gentildonna', 'Gentildonna', 'Noblewoman of Fortitude', 6, 'Fire', 'Operator', 'Senior Division', 'Uma', 'Female', '167cm', 'February 20', 'February 22, 2024.', 7000, 5000, 6500, 0, 'S', 1, 1, '🔥', 'Strength is righteousness - An Umamusume who believes that abilities are above all else. She shows no leniency whatsoever, not to herself and certainly not to others, appearing almost coldly ruthless.\n\nNo words for losers - that is that is the essence of the noble lady, Gentildonna.', 'https://umamusu.wiki/w/thumb.php?f=Gentildonna_%28Race%29.png&width=270', 'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fgametora.com%2Fimages%2Fumamusume%2Fcharacters%2Ficons%2Fchr_icon_1116.png&f=1&nofb=1&ipt=f90d056277c5e6e4eccbb9ba24fab17445aec76d9488dc337c4db423284564ea', 'https://media.tenor.com/DhaKoypMlScAAAAi/%D0%B4%D0%B5%D0%B2%D1%83%D1%88%D0%BA%D0%B8-%D0%BF%D0%BE%D0%BD%D0%B8-%D0%B3%D0%B5%D0%BD%D1%82%D0%B8%D0%BB%D1%8C%D0%B4%D0%BE%D0%BD%D0%BD%D0%B0-umamusume-stick-gentildonna.gif', '2026-04-04 15:54:05', '2026-04-04 15:54:32'),
(20, 'zenless', 'Billy', 'Billy Kid', 'Sons of Calydon (formerly)', 5, 'Physical', 'Attacker', 'Cunning Hares', 'Mecha-Humanoid', 'Male', '188 cm', 'November 25th', 'July 04, 2024', 10000, 800, 600, 0, 'A', 0, 0, '⚔️', 'A handsome cyborg with a casual and carefree personality.\nHe\'s an avid fan of the Starlight Knight show, not only referring to himself as one of the Starlight Knights, but repeating many classic lines from the show.\nRefers to his pair of special custom-made high-caliber revolvers as \"the girls\". They appear to have been a gift from an old friend.\nHe may look unreliable, but once he gets serious Billy can take on any challenge.', 'https://static.wikia.nocookie.net/zenless-zone-zero/images/d/dc/Agent_Billy_Kid_Portrait.png/revision/latest/scale-to-width-down/1000?cb=20240707002211', 'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fi.pinimg.com%2F736x%2Fbf%2F95%2Fe3%2Fbf95e39d6900bc15489b6499fa1c5bd1.jpg&f=1&nofb=1&ipt=cb99c5b9267faf732ecd41208757aeefcd7a981f3d9f4aee0cd76b5802ae9e10', 'https://media1.tenor.com/m/4anqH9wrWv4AAAAd/zzz-zenless-zone-zero.gif', '2026-04-04 16:16:50', '2026-04-04 16:17:11');

-- --------------------------------------------------------

--
-- Table structure for table `outfits`
--

DROP TABLE IF EXISTS `outfits`;
CREATE TABLE `outfits` (
  `id` int(11) NOT NULL,
  `name` varchar(150) NOT NULL,
  `op` varchar(150) NOT NULL,
  `game` varchar(50) NOT NULL DEFAULT 'arknights',
  `rarity` varchar(20) NOT NULL DEFAULT '★★★★★',
  `price` varchar(50) DEFAULT 'N/A',
  `image` varchar(500) DEFAULT '',
  `emoji` varchar(10) DEFAULT '?',
  `description` text DEFAULT NULL,
  `obtain` varchar(255) DEFAULT '',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `outfits`
--

INSERT INTO `outfits` (`id`, `name`, `op`, `game`, `rarity`, `price`, `image`, `emoji`, `description`, `obtain`, `created_at`, `updated_at`) VALUES
(1, 'Shining Dew', 'Skadi', 'arknights', '★★★★★', '18 OP', 'https://arknights.wiki.gg/images/thumb/Skadi_Skin_2.png/1024px-Skadi_Skin_2.png?ea57e5', '🌊', 'A flowing aquatic outfit designed around Skadi\'s Abyssal Hunter origins.', 'Direct purchase. Limited seasonal restock.', '2026-04-04 15:18:29', '2026-04-04 15:18:29'),
(2, 'Rosmontis Art Deco', 'Rosmontis', 'arknights', '★★★★★', '18 OP', 'https://arknights.wiki.gg/images/thumb/Rosmontis_Skin_1.png/1024px-Rosmontis_Skin_1.png?7035b6', '🎨', 'An Art Deco-inspired costume with geometric patterns. Includes custom skill animations.', 'Limited collab store.', '2026-04-04 15:18:29', '2026-04-04 15:18:29'),
(3, 'Renegade', 'Texas', 'arknights', '★★★★', '3 OP', 'https://arknights.wiki.gg/images/thumb/Texas_the_Omertosa_Skin_1.png/1024px-Texas_the_Omertosa_Skin_1.png?582ee8', '🐺', 'A casual streetwear aesthetic depicting Texas off-duty.', 'Standard rotation store.', '2026-04-04 15:18:29', '2026-04-04 15:18:29'),
(4, 'Off Duty', 'Exusiai', 'arknights', '★★★★', '3 OP', 'https://arknights.wiki.gg/images/thumb/Exusiai_Skin_3.png/1024px-Exusiai_Skin_3.png?a61efc', '😴', 'Exusiai in relaxed weekend attire.', 'Standard rotation store.', '2026-04-04 15:18:29', '2026-04-04 15:18:29'),
(5, 'Attorn', 'SilverAsh', 'arknights', '★★★★★', '24 OP', 'https://arknights.wiki.gg/images/thumb/SilverAsh_Skin_3.png/1024px-SilverAsh_Skin_3.png?587f8f', '🦊', 'A high-fashion formal suit befitting SilverAsh\'s Kjerag noble status.', 'Premium store.', '2026-04-04 15:18:29', '2026-04-04 15:18:29'),
(6, 'Lullaby', 'Mudrock', 'arknights', '★★★★★', '18 OP', 'https://arknights.wiki.gg/images/thumb/Mudrock_Skin_1.png/1024px-Mudrock_Skin_1.png?b7f177', '🗿', 'A gentler interpretation of Mudrock\'s aesthetic in a rare moment of peace.', 'Direct purchase.', '2026-04-04 15:18:29', '2026-04-04 15:18:29'),
(7, 'Summer skies and Peaceful waves', 'Wise and Belle', 'zenless', '★★★★★', 'Free!', 'https://www.icy-veins.com/forums/uploads/monthly_2025_07/image_2025-07-04_142446633.thumb.png.8c94fd6cb1e0854f730a5827c59271a3.png', '🎀', '', 'Just Log in!', '2026-04-05 09:24:22', '2026-04-05 12:32:18');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `banners`
--
ALTER TABLE `banners`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `news`
--
ALTER TABLE `news`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `operators`
--
ALTER TABLE `operators`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `outfits`
--
ALTER TABLE `outfits`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `news`
--
ALTER TABLE `news`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `operators`
--
ALTER TABLE `operators`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `outfits`
--
ALTER TABLE `outfits`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;
COMMIT;

-- ────────────────────────────────────────────────────────────
--  TABLE: users  — tracks registered accounts + pull counts
-- ────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS `users` (
  `id`          int(11)      NOT NULL AUTO_INCREMENT,
  `username`    varchar(80)  NOT NULL,
  `password`    varchar(255) NOT NULL COMMENT 'Stored as-is (demo project)',
  `role`        varchar(20)  NOT NULL DEFAULT 'user',
  `pull_count`  int(11)      NOT NULL DEFAULT 0,
  `last_login`  timestamp    NULL     DEFAULT NULL,
  `created_at`  timestamp    NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Seed the two default accounts
INSERT IGNORE INTO `users` (`username`,`password`,`role`) VALUES
('Admin1234',  'Administrator12345', 'admin'),
('user',       'user123',            'user');

-- ────────────────────────────────────────────────────────────
--  TABLE: activity_log  — every login, pull, add, edit
-- ────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS `activity_log` (
  `id`         int(11)      NOT NULL AUTO_INCREMENT,
  `username`   varchar(80)  NOT NULL,
  `role`       varchar(20)           DEFAULT 'user',
  `action`     varchar(50)  NOT NULL COMMENT 'LOGIN | LOGOUT | PULL | ADD | EDIT | DELETE',
  `detail`     text                  DEFAULT NULL,
  `created_at` timestamp    NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

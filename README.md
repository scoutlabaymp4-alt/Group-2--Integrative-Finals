# Group-2--Integrative-Finals
A Collaboratory Final Project in the Subject Integrative Programing 
# Gacha Space Database (Gacha Wiki)

A comprehensive, multi-game fan wiki and headhunting (gacha) simulator built as an educational project. It serves as a centralized hub for tracking operators, banners, outfits, and news across popular gacha titles including *Arknights*, *Arknights: Endfield*, *Zenless Zone Zero*, *Wuthering Waves*, and *Uma Musume Pretty Derby*.

![UI Preview](https://img.shields.io/badge/UI-Dark_Mode-07080d?style=flat-square)
![Tech Stack](https://img.shields.io/badge/Stack-HTML5_%7C_CSS3_%7C_JS_%7C_PHP_%7C_MySQL-teal?style=flat-square)

## ✨ Features

* **Operator Archive:** A dynamic, searchable database of characters. Features sorting, filtering by element/class/tier, side-by-side comparison mode, and interactive stat radar charts.
* **Headhunting Simulator:** A fully functional gacha pull simulator mimicking actual in-game rates, soft/hard pity systems, and 50/50 rate-ups across different games.
* **Role-Based Access Control:** Secure login system with `Admin` and `User` roles.
* **Full CRUD Functionality:** Admins can Create, Read, Update, and Delete operators, banners, news, and outfits directly from the web interface.
* **Activity Logging:** Tracks user actions (logins, gacha pulls, database edits) via an admin dashboard.
* **Interactive UI:** High-performance Vanilla JS animations, ripple effects, lazy-loaded GIFs, and a custom WebGL/Three.js interactive Originium crystal background.

## 🛠️ Tech Stack

* **Frontend:** HTML5, CSS3 (Custom Variables/Tokens), Vanilla JavaScript (ES6+), Bootstrap 5, Three.js (WebGL background).
* **Backend:** PHP 8.x with PDO (PHP Data Objects) for secure database interactions.
* **Database:** MySQL / MariaDB.
* **Architecture:** Single-Page Application (SPA) feel using smooth scrolling and dynamic DOM manipulation, backed by a custom REST-like JSON API (`api.php`).

## 🚀 Installation & Setup

This project is configured to run smoothly on a local development server like **XAMPP**.

### 1. Prerequisites
* Install [XAMPP](https://www.apachefriends.org/) (or any similar LAMP/WAMP stack).
* Ensure Apache and MySQL services are running.

### 2. Database Setup
1. Open your browser and navigate to `http://localhost/phpmyadmin`.
2. Create a new database named `arknights_wiki`.
3. Import the provided `arknights_wiki.sql` file into this database. This will create all necessary tables (`operators`, `banners`, `news`, `outfits`, `users`, `activity_log`) and populate them with seed data.

### 3. Project Configuration
1. Clone this repository into your XAMPP `htdocs` directory (e.g., `C:\xampp\htdocs\gacha-wiki`).
2. *(Optional)* If your local MySQL setup requires a password, edit `db.php` and update the `DB_USER` and `DB_PASS` constants.

```php
define('DB_HOST',    'localhost');
define('DB_NAME',    'arknights_wiki');
define('DB_USER',    'root');
define('DB_PASS',    ''); // Add your MySQL password here if applicable

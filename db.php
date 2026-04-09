<?php
// ================================================================
//  db.php — PDO Database Connection
//  Rhodes Intel · Arknights & Endfield Wiki
//
//  Default XAMPP settings pre-filled.
//  Edit DB_USER / DB_PASS if your MySQL setup differs.
// ================================================================

define('DB_HOST',    'localhost');
define('DB_NAME',    'arknights_wiki');
define('DB_USER',    'root');
define('DB_PASS',    '');
define('DB_CHARSET', 'utf8mb4');

function getDB(): PDO {
    static $pdo = null;
    if ($pdo === null) {
        try {
            $pdo = new PDO(
                sprintf('mysql:host=%s;dbname=%s;charset=%s', DB_HOST, DB_NAME, DB_CHARSET),
                DB_USER, DB_PASS,
                [
                    PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
                    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                    PDO::ATTR_EMULATE_PREPARES   => false,
                ]
            );
        } catch (PDOException $e) {
            http_response_code(500);
            header('Content-Type: application/json');
            die(json_encode([
                'success' => false,
                'error'   => 'DB connection failed. Is XAMPP MySQL running? ' . $e->getMessage()
            ]));
        }
    }
    return $pdo;
}

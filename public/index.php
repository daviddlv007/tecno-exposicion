<?php

use Laminas\Mvc\Application;

// Cambiar al directorio del proyecto
chdir(dirname(__DIR__));

// Configuración simple para mostrar errores
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Inicializar datos en sesión (antes de Laminas)
session_start();
if (!isset($_SESSION['categorias'])) {
    $_SESSION['categorias'] = [
        ['id' => 1, 'nombre' => 'Electrónicos', 'descripcion' => 'Productos electrónicos y tecnológicos'],
        ['id' => 2, 'nombre' => 'Ropa', 'descripcion' => 'Vestimenta y accesorios'],
        ['id' => 3, 'nombre' => 'Hogar', 'descripcion' => 'Artículos para el hogar y decoración']
    ];
    $_SESSION['next_id'] = 4;
}

// Cargar Composer autoloader
if (file_exists('vendor/autoload.php')) {
    include 'vendor/autoload.php';
} else {
    // Fallback: autoloader simple
    spl_autoload_register(function ($class) {
        $class = str_replace('Application\\', '', $class);
        $file = __DIR__ . '/../src/' . str_replace('\\', '/', $class) . '.php';
        if (file_exists($file)) {
            require $file;
        }
    });
}

// Verificar si Laminas está disponible
if (!class_exists(Application::class)) {
    echo "<h1>Instalando dependencias...</h1>";
    echo "<p>Ejecuta: <code>docker exec -it simple_mvc composer install</code></p>";
    exit;
}

// Cargar configuración y ejecutar aplicación Laminas
$appConfig = require __DIR__ . '/../config/application.config.php';
Application::init($appConfig)->run();
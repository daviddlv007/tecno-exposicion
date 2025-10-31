# 🏷️ Proyecto CRUD Categorías - Laminas Framework

## 📋 Descripción

Proyecto de **tres capas** usando el **Framework Laminas de PHP** con arquitectura MVC simplificada. Implementa un CRUD completo para gestión de categorías con:

- ✅ **Estructura oficial de Laminas** para presentaciones MVP
- ✅ **Docker Compose** para entorno aislado 
- ✅ **Datos en sesión** (sin base de datos para simplicidad)
- ✅ **Bootstrap visual** con interfaz amigable

## 🚀 Características

- **Framework**: Laminas (Zend Framework evolution)
- **Arquitectura**: MVC (Modelo-Vista-Controlador) 
- **Capas**:
  - **Presentación**: Controllers + Views (.phtml)
  - **Lógica de Negocio**: Modelos (Categoria.php)
  - **Datos**: Sesiones PHP ($_SESSION)
- **Conteneurización**: Docker + PHP 8.1 + Apache

## 📁 Estructura del Proyecto (Oficial Laminas)

```
proyectos/exposicion-tecno/
├── 📁 config/                    # Configuración global
│   ├── application.config.php    # Configuración principal
│   └── autoload/global.php       # Autoload global
├── 📁 module/Application/         # Módulo principal (OFICIAL)
│   ├── Module.php                # Clase del módulo
│   ├── 📁 config/
│   │   └── module.config.php     # Configuración del módulo
│   ├── 📁 src/                   # Código fuente
│   │   ├── Controller/
│   │   │   └── CategoriaController.php
│   │   └── Categoria.php         # Modelo
│   └── 📁 view/                  # Templates
│       ├── application/categoria/
│       ├── error/
│       └── layout/
├── 📁 public/                    # Punto de entrada web
│   ├── index.php                # Front controller
│   └── .htaccess                 # Rewrite rules
├── composer.json                 # Dependencias
├── docker-compose.yml            # Orquestación Docker
└── README.md                     # Esta documentación
```

## 🛠️ Instalación y Uso

### 1. Clonar e Iniciar

```bash
# Clonar el proyecto
git clone <repository-url>
cd exposicion-tecno

# Iniciar con Docker
docker-compose up -d
```

### 2. Acceder a la Aplicación

- **URL**: http://localhost:8080
- **Puerto**: 8080 (configurable en docker-compose.yml)

### 3. Funcionalidades CRUD

| Acción | URL | Método |
|--------|-----|---------|
| Listar | `/` o `/categoria` | GET |
| Agregar | `/categoria/add` | GET/POST |
| Editar | `/categoria/edit/{id}` | GET/POST |
| Eliminar | `/categoria/delete/{id}` | GET |

## 🔧 Componentes Técnicos

### Framework Laminas

```php
// composer.json
{
    "require": {
        "laminas/laminas-mvc": "^3.6",
        "laminas/laminas-view": "^2.24",
        "laminas/laminas-router": "^3.11"
    }
}
```

### Controlador Principal

```php
<?php
namespace Application\Controller;

use Laminas\Mvc\Controller\AbstractActionController;
use Laminas\View\Model\ViewModel;
use Application\Categoria;

class CategoriaController extends AbstractActionController
{
    // CRUD operations with session storage
}
```

### Modelo de Datos

```php
<?php
namespace Application;

class Categoria
{
    public static function getAll()
    {
        return $_SESSION['categorias'] ?? self::getDefaultData();
    }
    
    // More methods for CRUD operations
}
```

## 🐳 Docker

```yaml
# docker-compose.yml
services:
  web:
    image: php:8.1-apache
    ports:
      - "8080:80"
    volumes:
      - ./:/var/www/html
    command: |
      bash -c "
        apt-get update && 
        apt-get install -y git unzip &&
        curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer &&
        composer install &&
        apache2-foreground
      "
```

## 📊 Datos de Prueba

El sistema incluye categorías predeterminadas:

```php
[
    ['id' => 1, 'nombre' => 'Electrónicos', 'descripcion' => 'Productos electrónicos y tecnológicos'],
    ['id' => 2, 'nombre' => 'Ropa', 'descripcion' => 'Vestimenta y accesorios'],
    ['id' => 3, 'nombre' => 'Hogar', 'descripcion' => 'Artículos para el hogar y decoración']
]
```

## 🎯 Casos de Uso MVP

### Para Presentaciones Académicas:
- ✅ Demuestra arquitectura MVC con Laminas
- ✅ Implementación de patrones de diseño
- ✅ Separación de responsabilidades por capas
- ✅ Routing y gestión de URLs limpias

### Para Demostraciones Técnicas:
- ✅ Framework empresarial (Laminas/Zend heritage)
- ✅ Containerización con Docker
- ✅ Autoloading PSR-4
- ✅ Estructura modular escalable

## 🔍 Detalles Técnicos

### Routing (Rutas)

```php
// module/Application/config/module.config.php
'router' => [
    'routes' => [
        'categoria' => [
            'type' => Segment::class,
            'options' => [
                'route' => '/categoria[/:action[/:id]]',
                'defaults' => [
                    'controller' => CategoriaController::class,
                    'action' => 'index',
                ],
            ],
        ],
    ],
],
```

### View Manager

```php
'view_manager' => [
    'template_map' => [
        'layout/layout' => __DIR__ . '/../view/layout/layout.phtml',
    ],
    'template_path_stack' => [
        __DIR__ . '/../view',
    ],
],
```

## 🎨 Interfaz

- **Responsive Design**: Compatible con móviles y escritorio
- **Iconos**: Emojis para mejor UX
- **Colores**: Esquema Bootstrap-like
- **Confirmaciones**: JavaScript para eliminar

## 📝 Notas de Desarrollo

1. **Persistencia**: Usa `$_SESSION` para simplicidad (no requiere DB)
2. **Validación**: Validación básica en formularios
3. **Seguridad**: Escaping automático en templates .phtml
4. **Autoload**: PSR-4 con Composer para structure oficial

## 🚀 Comandos Útiles

```bash
# Regenerar autoloader
composer dump-autoload

# Ver logs de Docker
docker-compose logs -f

# Acceder al contenedor
docker-compose exec web bash

# Reiniciar servicios
docker-compose restart
```

## 📞 Soporte

Este proyecto está configurado con la **estructura oficial de Laminas** apropiada para:
- ✅ Presentaciones académicas MVP
- ✅ Demos técnicas profesionales  
- ✅ Proof of concept empresariales
- ✅ Base para proyectos escalables

---
*Desarrollado con ❤️ usando Laminas Framework + Docker*
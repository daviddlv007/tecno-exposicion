# Tecno Exposición - Actualización a SQLite

## 📦 Cambios Realizados

### 1. **Base de Datos SQLite**
- La aplicación ahora usa SQLite en lugar de sesiones PHP
- Base de datos: `module/Application/data/tecno-exposicion.db`
- Se crea automáticamente en el primer acceso

### 2. **Nuevo Componente: CategoriaRepository**
- Archivo: `module/Application/src/Model/CategoriaRepository.php`
- Encapsula toda la lógica de acceso a datos
- Métodos disponibles:
  - `findAll()` - Obtiene todas las categorías
  - `findById($id)` - Obtiene una categoría específica
  - `insert($nombre, $descripcion)` - Inserta una nueva categoría
  - `update($id, $nombre, $descripcion)` - Actualiza una categoría
  - `delete($id)` - Elimina una categoría

### 3. **Inyección de Dependencias (Dependency Injection)**
- El `CategoriaController` ahora recibe el `CategoriaRepository` por constructor
- Configuración en `module.config.php`:
  ```php
  'controllers' => [
      'factories' => [
          CategoriaController::class => function($container) {
              $repository = $container->get(CategoriaRepository::class);
              return new CategoriaController($repository);
          },
      ],
  ],
  ```

### 4. **Service Manager**
- Registra la conexión PDO a SQLite
- Registra el `CategoriaRepository` como servicio
- El `Service Manager` es el contenedor IoC de Laminas

## 🗂️ Estructura de Directorios

```
module/Application/
├── data/                          # 📁 Nuevo: almacenamiento de BD
│   └── tecno-exposicion.db       # SQLite DB (se crea automáticamente)
├── src/
│   ├── Controller/
│   │   └── CategoriaController.php (actualizado)
│   └── Model/
│       ├── Categoria.php
│       └── CategoriaRepository.php (✨ NUEVO)
├── config/
│   └── module.config.php          (actualizado)
└── view/
    └── ...
```

## 🚀 Levantamiento del Proyecto

```bash
./levantar_proyecto.sh
```

El script automáticamente:
- ✅ Instala dependencias de Composer
- ✅ Crea el directorio `data` con permisos correctos
- ✅ Configura Apache con VirtualHost
- ✅ Reinicia los servicios

## 💾 Primera Vez que Accedes

La base de datos se crea automáticamente cuando accedes a la aplicación:
1. Se crea la tabla `categorias`
2. Se añaden las columnas: `id`, `nombre`, `descripcion`, `created_at`, `updated_at`

## 🎓 Conceptos de Laminas Demostrados

1. **Routing** - Configuración de rutas en `module.config.php`
2. **Controllers** - AbstractActionController con acciones (indexAction, addAction, etc.)
3. **Models** - Entidades y repositorios para acceso a datos
4. **Service Manager** - Contenedor IoC para inyección de dependencias
5. **View Manager** - Renderizado de templates Phtml
6. **Database** - PDO y SQLite para persistencia

## 📝 Ejemplos de Uso

### Crear una categoría
```
POST /categoria/add
Parameters: nombre, descripcion
```

### Editar una categoría
```
GET/POST /categoria/edit/1
```

### Eliminar una categoría
```
GET /categoria/delete/1
```

### Listar categorías
```
GET /
```

## ✨ Ventajas de esta Arquitectura

- **Separación de responsabilidades** - Repository maneja datos, Controller maneja lógica
- **Testeable** - Fácil mockear el repository para tests
- **Escalable** - Cambiar de SQLite a MySQL solo requiere cambiar la configuración
- **Professional** - Sigue patrones estándar de Laminas

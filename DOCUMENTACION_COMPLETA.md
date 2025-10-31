# 📚 DOCUMENTACIÓN FINAL - Tecno Exposición + SQLite

## 📋 Índice de Archivos

### 🎯 Scripts de Ejecución

| Script | Contexto | Descripción |
|--------|----------|-------------|
| **`levantar_proyecto.sh`** | VM con Fedora 43 + PHP 8.3 ya instalado | Levanta el proyecto en VM existente |
| **`crear_laminas_local.sh`** | WSL/Local sin dependencias | Setup completo: PHP, Apache, Composer, proyecto |
| **`reset_db.sh`** | Ambos contextos | Reinicia BD con 5 categorías de demostración |
| **`1-restore.sh`** | VM/WSL | Restaura Apache a configuración original |
| **`2-setup-env.sh`** | VM/WSL | Setup dual PHP ≤8.3 para ambos entornos |

### 📖 Documentación

| Archivo | Contenido |
|---------|----------|
| **`GUIA_USO.md`** | Paso a paso completo, troubleshooting, flujo de datos |
| **`MIGRACION_SQLITE.md`** | Cambios realizados, conceptos Laminas, estructura |
| **`CAMBIOS_RESUMEN.md`** | Archivos modificados, archivos nuevos, patrones |
| **`README.md`** | Documentación original del proyecto |

---

## 🚀 INICIO RÁPIDO

### Contexto 1: VM con Fedora 43 + PHP 8.3 ya instalado

```bash
cd /home/proyectos/tecno-exposicion
./levantar_proyecto.sh
```

Luego accede a: **http://localhost/**

### Contexto 2: WSL/Local sin nada instalado

```bash
cd /home/proyectos/tecno-exposicion
./crear_laminas_local.sh
```

Luego accede a: **http://localhost/**

### Cargar datos de demostración

```bash
./reset_db.sh
```

---

## 📊 CAMBIOS PRINCIPALES

### ✅ Implementado

1. **Persistencia en SQLite** ✨
   - Base de datos: `module/Application/data/tecno-exposicion.db`
   - Auto-creada en primer acceso
   - Tabla `categorias` con campos: id, nombre, descripcion, timestamps

2. **Patrón Repository** ⭐
   - Archivo: `module/Application/src/Model/CategoriaRepository.php`
   - Encapsula toda lógica de BD
   - Métodos: `findAll()`, `findById()`, `insert()`, `update()`, `delete()`

3. **Inyección de Dependencias** 🔧
   - `CategoriaController` recibe `CategoriaRepository` por constructor
   - Service Manager configura las dependencias
   - Laminas auto-inyecta en las factories

4. **Service Manager (IoC Container)** 📦
   - PDO registrado como servicio
   - CategoriaRepository registrado como servicio
   - CategoriaController factory con inyección

### 📝 Archivos Modificados

```php
// 1. CategoriaController.php
- Cambio: De sesiones a Repository
- Inyección: CategoriaRepository en constructor

// 2. module.config.php
- Cambio: Factories para PDO, Repository, Controller
- Inyección: Service Manager configurado

// 3. levantar_proyecto.sh & crear_laminas_local.sh
- Cambio: Crea directorio data para SQLite
- Permisos: apache:apache en data/

// 4. reset_db.sh (NUEVO)
- Función: Reinicia BD con datos de demo
- Uso: ./reset_db.sh
```

---

## 🎓 CONCEPTOS LAMINAS DEMOSTRADOS

### 1. Routing
```php
'categoria' => [
    'type' => Segment::class,
    'options' => [
        'route' => '/categoria[/:action[/:id]]',
        'constraints' => [
            'action' => '[a-zA-Z][a-zA-Z0-9_-]*',
            'id' => '[0-9]+',
        ],
        'defaults' => [
            'controller' => CategoriaController::class,
            'action' => 'index',
        ],
    ],
],
```

### 2. Dependency Injection
```php
// Factory crea el controller con dependencias
CategoriaController::class => function($container) {
    $repository = $container->get(CategoriaRepository::class);
    return new CategoriaController($repository);
}
```

### 3. Service Manager (IoC)
```php
// Service Manager maneja creación de servicios
'service_manager' => [
    'factories' => [
        PDO::class => function() { /* ... */ },
        CategoriaRepository::class => function($container) { /* ... */ },
    ],
],
```

### 4. Repository Pattern
```php
// Encapsula lógica de acceso a datos
public function findAll() { /* SELECT * FROM categorias */ }
public function insert($nombre, $desc) { /* INSERT */ }
public function update($id, $nombre, $desc) { /* UPDATE */ }
public function delete($id) { /* DELETE */ }
```

### 5. MVC Architecture
```
Modelo:     Categoria, CategoriaRepository
Vista:      category/index.phtml, add.phtml, edit.phtml
Controlador: CategoriaController (indexAction, addAction, etc.)
```

---

## 🗂️ ESTRUCTURA FINAL

```
/home/proyectos/tecno-exposicion/
├── module/Application/
│   ├── src/
│   │   ├── Controller/
│   │   │   └── CategoriaController.php ✏️ (actualizado)
│   │   └── Model/
│   │       ├── Categoria.php
│   │       └── CategoriaRepository.php ✨ (NUEVO)
│   ├── config/
│   │   └── module.config.php ✏️ (actualizado)
│   ├── data/ 📁 (NUEVO)
│   │   └── tecno-exposicion.db (creado en runtime)
│   └── view/
│       ├── application/
│       │   └── categoria/
│       │       ├── index.phtml
│       │       ├── add.phtml
│       │       └── edit.phtml
│       ├── layout/
│       │   └── layout.phtml
│       └── error/
│           ├── 404.phtml
│           └── index.phtml
├── public/
│   ├── index.php
│   └── .htaccess
├── Scripts:
│   ├── levantar_proyecto.sh ⭐
│   ├── crear_laminas_local.sh
│   ├── reset_db.sh
│   ├── 1-restore.sh
│   └── 2-setup-env.sh
├── Documentación:
│   ├── GUIA_USO.md
│   ├── MIGRACION_SQLITE.md
│   ├── CAMBIOS_RESUMEN.md
│   └── README.md
└── composer.json, .htaccess, etc.
```

---

## ✅ FLUJO DE EJECUCIÓN

### 1. Levantar el Proyecto
```bash
./levantar_proyecto.sh
```
- ✅ Instala dependencias de Composer
- ✅ Ajusta permisos
- ✅ Crea directorio data/
- ✅ Configura VirtualHost con rewrite rules
- ✅ Reinicia Apache

### 2. Primera Carga (http://localhost/)
- ✅ Apache enruta a index.php
- ✅ Laminas carga el router
- ✅ Router detecta ruta: `/` → CategoriaController@indexAction
- ✅ Service Manager crea CategoriaController con CategoriaRepository
- ✅ CategoriaRepository se conecta a SQLite
- ✅ Se crea la tabla `categorias` (si no existe)
- ✅ Se devuelven 0 categorías (primera vez)
- ✅ Se renderiza la vista

### 3. Crear Categoría
- POST /categoria/add
- Service Manager inyecta Repository
- Repository::insert() inserta en SQLite
- Redirecciona a /
- Los datos persisten en BD

### 4. Reiniciar con Demo
```bash
./reset_db.sh
```
- ❌ Elimina BD anterior
- ✅ Crea nueva
- ✅ Inserta 5 categorías
- ✅ Recarga la página: ves los 5 datos

---

## 📚 REFERENCIAS

### Documentos Internos
- `GUIA_USO.md` - Instrucciones paso a paso
- `MIGRACION_SQLITE.md` - Cambios técnicos
- `CAMBIOS_RESUMEN.md` - Resumen de archivos

### Sitios Oficiales
- Laminas MVC: https://docs.laminas.dev/laminas-mvc/
- Laminas Router: https://docs.laminas.dev/laminas-router/
- Service Manager: https://docs.laminas.dev/laminas-servicemanager/

---

## 🎯 PRÓXIMOS PASOS (Opcional)

1. **Añadir Validación** - Usar Laminas Validator
2. **Migraciones** - Usar PHPUnit para tests
3. **API REST** - Usar Laminas API Tools
4. **Caché** - Redis o Memcached
5. **Autenticación** - Laminas Authentication

---

## 💡 RESUMEN FINAL

✨ **Tu proyecto ahora demuestra:**

✅ Arquitectura Laminas MVC profesional  
✅ Persistencia en SQLite  
✅ Patrón Repository  
✅ Inyección de Dependencias  
✅ Service Manager (IoC Container)  
✅ Routing y Controllers  
✅ Validación y Seguridad básica  
✅ Escalabilidad (fácil cambiar de SQLite a MySQL)  

🚀 **Listo para producción** (con ajustes menores)

---

**Última actualización:** 31 de Octubre de 2025

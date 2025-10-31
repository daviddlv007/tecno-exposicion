# 🚀 Guía de Uso - Tecno Exposición con SQLite

## 1️⃣ Levantamiento en WSL/Local (Fedora 42)

```bash
cd /home/proyectos/tecno-exposicion
./levantar_proyecto.sh
```

**Salida esperada:**
```
📚 Instalando dependencias de Composer...
🔐 Configurando permisos...
⚙️  Configurando VirtualHost...
✓ Verificando configuración de Apache...
🔄 Reiniciando Apache...
════════════════════════════════════════════════════════════
✅ ¡Proyecto levantado exitosamente!
🗄️  Base de Datos SQLite:
   Ubicación: /home/proyectos/tecno-exposicion/module/Application/data/tecno-exposicion.db
   Se crea automáticamente en el primer acceso
```

## 2️⃣ Acceso a la Aplicación

```
http://localhost/
```

**Primera carga:**
- ✅ Se crea automáticamente la BD SQLite
- ✅ Se genera la tabla `categorias`
- ✅ Verás un listado vacío de categorías

## 3️⃣ Operaciones CRUD

### 📝 Crear Categoría
1. Click en "Añadir Categoría"
2. Rellena:
   - **Nombre**: Ej. "Electrónica"
   - **Descripción**: Ej. "Dispositivos y componentes"
3. Guarda
4. ✅ Se persiste en SQLite automáticamente

### 👁️ Ver Categorías
- Accede a `http://localhost/`
- Verás todas las categorías ordenadas por ID (descendente)

### ✏️ Editar Categoría
1. Haz click en "Editar" (junto a la categoría)
2. Modifica los datos
3. Guarda
4. ✅ Los cambios se guardan en BD

### 🗑️ Eliminar Categoría
1. Click en "Eliminar" (junto a la categoría)
2. ✅ Se elimina de la BD inmediatamente

## 4️⃣ Reiniciar BD con Datos de Demo

Si quieres cargar datos de demostración:

```bash
./reset_db.sh
```

**Esto va a:**
- ❌ Eliminar la BD anterior
- ✅ Crear una nueva
- ✅ Insertar 5 categorías de ejemplo:
  - Electrónica
  - Informática
  - Telecomunicaciones
  - Energías Renovables
  - Inteligencia Artificial

**Salida:**
```
🗄️  Reiniciando base de datos SQLite...
❌ Base de datos anterior eliminada
✅ Base de datos reiniciada con datos de demostración
📍 Ubicación: /home/proyectos/tecno-exposicion/module/Application/data/tecno-exposicion.db

📊 Categorías creadas:
1|Electrónica
2|Informática
3|Telecomunicaciones
4|Energías Renovables
5|Inteligencia Artificial
```

## 5️⃣ Verificar Base de Datos

```bash
# Ver contenido de la BD directamente
sqlite3 /home/proyectos/tecno-exposicion/module/Application/data/tecno-exposicion.db

# En el prompt SQLite:
sqlite> SELECT * FROM categorias;
```

## 6️⃣ Logs de la Aplicación

```bash
# Errores PHP/Apache
tail -f /var/log/httpd/tecno-exposicion-error.log

# Accesos HTTP
tail -f /var/log/httpd/tecno-exposicion-access.log
```

## 7️⃣ Flujo de Datos (Arquitectura)

```
┌─────────────────┐
│  Cliente HTTP   │
│  (Navegador)    │
└────────┬────────┘
         │
         ▼
┌─────────────────────────────────┐
│   Apache VirtualHost            │
│   localhost:80                  │
└────────┬────────────────────────┘
         │
         ▼
┌─────────────────────────────────┐
│  Laminas Router                 │
│  /categoria[/:action[/:id]]     │
└────────┬────────────────────────┘
         │
         ▼
┌─────────────────────────────────┐
│  CategoriaController            │
│  ├─ indexAction()               │
│  ├─ addAction()                 │
│  ├─ editAction()                │
│  └─ deleteAction()              │
└────────┬────────────────────────┘
         │
         ▼
┌─────────────────────────────────┐
│  Service Manager (IoC)          │
│  Inyecta CategoriaRepository    │
└────────┬────────────────────────┘
         │
         ▼
┌─────────────────────────────────┐
│  CategoriaRepository            │
│  ├─ findAll()                   │
│  ├─ findById($id)               │
│  ├─ insert($nombre, $desc)      │
│  ├─ update($id, ...)            │
│  └─ delete($id)                 │
└────────┬────────────────────────┘
         │
         ▼
┌─────────────────────────────────┐
│  PDO SQLite                     │
│  tecno-exposicion.db            │
└─────────────────────────────────┘
```

## 8️⃣ Troubleshooting

### ❌ Problema: "Not Found" al acceder a localhost

**Solución:**
```bash
# Reinicia Apache
sudo systemctl restart httpd

# Verifica que el VirtualHost está activo
sudo apachectl -S | grep tecno
```

### ❌ Problema: Permiso denegado en escritura de BD

**Solución:**
```bash
sudo chown apache:apache /home/proyectos/tecno-exposicion/module/Application/data/tecno-exposicion.db
sudo chmod 644 /home/proyectos/tecno-exposicion/module/Application/data/tecno-exposicion.db
```

### ❌ Problema: Cambios no se guardan

**Solución:**
1. Verifica que existe `/var/log/httpd/tecno-exposicion-error.log`
2. Revisa los errores: `tail -f /var/log/httpd/tecno-exposicion-error.log`
3. Asegúrate que Apache está corriendo: `sudo systemctl status httpd`

## 9️⃣ Resumen de Rutas

| Ruta | Método | Acción |
|------|--------|--------|
| `/` | GET | Listado de categorías |
| `/categoria/add` | GET | Formulario de nueva categoría |
| `/categoria/add` | POST | Guarda nueva categoría |
| `/categoria/edit/1` | GET | Formulario de edición |
| `/categoria/edit/1` | POST | Guarda categoría editada |
| `/categoria/delete/1` | GET | Elimina categoría |

---

**¿Necesitas ayuda? Revisa los logs o ejecuta:**
```bash
./reset_db.sh
sudo systemctl restart httpd
```
